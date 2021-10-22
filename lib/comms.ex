defmodule ViaUtils.Comms do
  use GenServer
  require Logger

  @spec start_unsupervised_operator(atom(), integer()) :: tuple()
  def start_unsupervised_operator(name, refresh_groups_interval_ms \\ 1000) do
    start_link(name: name, refresh_groups_loop_interval_ms: refresh_groups_interval_ms)
  end

  @spec start_operator(atom) :: {:error, any} | {:ok, pid} | {:ok, pid, any}
  defdelegate start_operator(name), to: ViaUtils.Comms.Supervisor

  def start_link(config) do
    name = Keyword.fetch!(config, :name)
    Logger.debug("Start ViaUtils.Comms: #{inspect(name)}")
    ViaUtils.Process.start_link_singular(GenServer, __MODULE__, config, via_tuple(name))
  end

  @impl GenServer
  def init(config) do
    state = %{
      groups: %{},
      # purely for dianostics
      name: Keyword.fetch!(config, :name)
    }

    ViaUtils.Process.start_loop(
      self(),
      Keyword.fetch!(config, :refresh_groups_loop_interval_ms),
      :refresh_groups
    )

    Logger.debug("Comms.Operator #{inspect(config[:name])} started at #{inspect(self())}")
    {:ok, state}
  end

  @impl GenServer
  def handle_cast({:join_group, group, process_id}, state) do
    # We will be added to our own record of the group during the
    # :refresh_groups cycle
    Logger.warn(
      "#{inspect(state.name)} at #{inspect(process_id)} is joining group: #{inspect(group)}"
    )

    # :pg.create(group)

    if !is_in_group?(group, process_id) do
      :pg.join(group, process_id)
      :erlang.send_after(20, self(), :refresh_groups)
    end

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:leave_group, group, process_id}, state) do
    # We will be remove from our own record of the group during the
    # :refresh_groups cycle
    if is_in_group?(group, process_id) do
      :pg.leave(group, process_id)
    end

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(
        {:deliver_msg_to_group, delivery_method, global_or_local, message, sender, group},
        state
      ) do
    delivery_function =
      case delivery_method do
        :send -> fn dest, msg -> send(dest, msg) end
        :cast -> fn dest, msg -> GenServer.cast(dest, msg) end
      end

    group_members = get_group_members(state.groups, group, global_or_local)

    deliver_msg_to_group_members(delivery_function, message, group_members, sender)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:refresh_groups, state) do
    groups =
      Enum.reduce(:pg.which_groups(), %{}, fn group, acc ->
        all_group_members = :pg.get_members(group)
        local_group_members = :pg.get_local_members(group)

        Map.put(acc, group, %{global: all_group_members, local: local_group_members})
      end)

    {:noreply, %{state | groups: groups}}
  end

  def join_group(operator_name, group, process_id) do
    GenServer.cast(via_tuple(operator_name), {:join_group, group, process_id})
  end

  def join_group(operator_name, group) do
    GenServer.cast(via_tuple(operator_name), {:join_group, group, self()})
  end

  def leave_group(operator_name, group, process_id) do
    GenServer.cast(via_tuple(operator_name), {:leave_group, group, process_id})
  end

  def leave_group(operator_name, group) do
    GenServer.cast(via_tuple(operator_name), {:leave_group, group, self()})
  end

  def deliver_msg_to_group(
        operator_name,
        delivery_method,
        message,
        sender,
        group,
        global_or_local
      ) do
    group =
      if is_nil(group) do
        if is_tuple(message), do: elem(message, 0), else: message
      else
        group
      end

    GenServer.cast(
      via_tuple(operator_name),
      {:deliver_msg_to_group, delivery_method, global_or_local, message, sender, group}
    )
  end

  @spec send_local_msg_to_group(atom(), any(), any(), any()) :: atom()
  def send_local_msg_to_group(operator_name, message, sender, group \\ nil) do
    deliver_msg_to_group(
      operator_name,
      :send,
      message,
      sender,
      group,
      :local
    )
  end

  @spec send_global_msg_to_group(atom(), any(), any(), any()) :: atom()
  def send_global_msg_to_group(operator_name, message, sender, group \\ nil) do
    deliver_msg_to_group(
      operator_name,
      :send,
      message,
      sender,
      group,
      :global
    )
  end

  @spec cast_local_msg_to_group(atom(), any(), any(), any()) :: atom()
  def cast_local_msg_to_group(operator_name, message, sender, group \\ nil) do
    deliver_msg_to_group(
      operator_name,
      :cast,
      message,
      sender,
      group,
      :local
    )
  end

  @spec cast_global_msg_to_group(atom(), any(), any(), any()) :: atom()
  def cast_global_msg_to_group(operator_name, message, sender, group \\ nil) do
    deliver_msg_to_group(
      operator_name,
      :cast,
      message,
      sender,
      group,
      :global
    )
  end

  defp deliver_msg_to_group_members(delivery_function, message, group_members, sender) do
    Enum.each(group_members, fn dest ->
      if dest != sender do
        # Logger.debug("Send #{inspect(message)} to #{inspect(dest)}")
        delivery_function.(dest, message)
        # GenServer.cast(dest, message)
      end
    end)
  end

  def is_in_group?(group, pid) do
    :pg.get_members(group)
    |> Enum.member?(pid)
  end

  def get_group_members(groups, group, global_or_local) do
    Map.get(groups, group, %{})
    |> Map.get(global_or_local, [])
  end

  def via_tuple(name) do
    ViaUtils.Registry.via_tuple(__MODULE__, name)
  end
end
