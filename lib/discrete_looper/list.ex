defmodule ViaUtils.DiscreteLooper.List do
  require Logger
  defstruct interval_ms: nil, members: %{}, time_ms: 0, name: nil

  @spec new(any(), integer()) :: struct()
  def new(name, interval_ms) do
    # Logger.info("Creating DiscreteLooper with inteval: #{interval_ms}")
    %ViaUtils.DiscreteLooper.List{
      name: name,
      interval_ms: interval_ms,
      time_ms: 0,
      members: %{}
    }
  end

  @spec add_member_to_looper(struct(), any(), integer()) :: struct()
  def add_member_to_looper(looper, value_to_store, new_interval_ms) do
    looper_interval_ms = looper.interval_ms

    members =
      if valid_interval?(new_interval_ms, looper_interval_ms) do
        members = looper.members
        # Logger.info("add #{inspect(pid)} to #{new_interval_ms}/#{send_when_stale} member list")
        # Logger.info("members: #{inspect(members)}")
        # Logger.debug("looper_interval: #{looper_interval_ms}")
        # num_intervals = round(1000 / looper_interval_ms)
        # Logger.info("num_ints: #{num_intervals}")
        Enum.reduce(looper_interval_ms..1000//looper_interval_ms, members, fn single_interval_ms,
                                                                              members_acc ->
          # Logger.debug("single_interveal: #{single_interval_ms}")
          # Logger.debug("members: #{inspect(members_acc)}")
          # Logger.debug("mems for int: #{inspect(Map.get(members, single_interval_ms))}")

          current_members_for_interval = Map.get(members, single_interval_ms, %{})

          members_for_interval =
            if rem(single_interval_ms, new_interval_ms) == 0 do
              Map.merge(current_members_for_interval, %{value_to_store => nil})
            else
              Map.drop(current_members_for_interval, [value_to_store])
            end

          # Logger.debug("members for interval: #{inspect(members_for_interval)}")

          if Enum.empty?(members_for_interval),
            do: members_acc,
            else: Map.put(members_acc, single_interval_ms, members_for_interval)
        end)
      else
        Logger.warn(
          "Add Members Interval #{new_interval_ms} is invalid: #{looper_interval_ms} for #{inspect(looper.name)}"
        )

        looper.members
      end

    # Logger.debug("#{inspect(looper.name)} updated all members: #{inspect(members)}")
    %{looper | members: members}
  end

  @spec update_members_for_interval(struct(), list(), integer()) :: struct()
  def update_members_for_interval(looper, new_member_list, interval_ms) do
    members =
      if valid_interval?(interval_ms, looper.interval_ms) do
        Map.put(
          looper.members,
          interval_ms,
          Enum.into(new_member_list, %{}, fn key -> {key, nil} end)
        )
      else
        Logger.warn(
          "Update Members Interval #{interval_ms} is invalid for #{inspect(looper.name)}"
        )

        looper.members
      end

    %{looper | members: members}
  end

  @spec update_all_members(struct(), list()) :: struct()
  def update_all_members(looper, member_interval_list) do
    looper = new(looper.name, looper.interval_ms)

    Enum.reduce(member_interval_list, looper, fn {value, interval_ms}, acc ->
      add_member_to_looper(acc, value, interval_ms)
    end)
  end

  @spec step(struct()) :: struct()
  def step(looper) do
    time_ms = looper.time_ms + looper.interval_ms
    # Logger.debug("#{inspect(looper.name)} time: #{time_ms}}")
    time_ms = if time_ms > 1000, do: looper.interval_ms, else: time_ms
    %{looper | time_ms: time_ms}
  end

  @spec get_members_now(struct) :: list()
  def get_members_now(looper) do
    Map.get(looper.members, looper.time_ms, %{})
    |> Map.keys()
  end

  @spec get_members_for_interval(struct(), integer()) :: list
  def get_members_for_interval(looper, interval_ms) do
    Map.get(looper.members, interval_ms, %{})
    |> Map.keys()
  end

  @spec get_all_members_flat(struct()) :: list()
  def get_all_members_flat(looper) do
    Enum.reduce(looper.members, [], fn {_interval, values}, acc ->
      Enum.uniq(Map.keys(values) ++ acc)
    end)
  end

  @spec valid_interval?(integer(), integer()) :: boolean()
  def valid_interval?(desired_interval_ms, interval_ms) do
    rem(desired_interval_ms, interval_ms) == 0
  end
end
