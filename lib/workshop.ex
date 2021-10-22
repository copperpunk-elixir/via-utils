defmodule ViaUtils.Workshop do
  use GenServer
  require Logger

  def start_link(config) do
    Logger.debug("Start ViaUtils.Workshop")
    ViaUtils.Process.start_link_singular(GenServer, __MODULE__, config)
  end

  @impl GenServer
  @spec init(any) :: {:ok, %{cast_data: nil, send_data: nil}}
  def init(config) do
    ViaUtils.Comms.start_operator(__MODULE__)

    state = %{
      cast_data: nil,
      send_data: nil
    }

    Enum.each(Keyword.get(config, :groups, []), fn group ->
      ViaUtils.Comms.join_group(__MODULE__, group)
    end)

    {:ok, state}
  end

  @impl GenServer
  def handle_info({:workshop, data}, state) do
    Logger.debug("Rx Send data: #{inspect(data)}")
    {:noreply, %{state | send_data: data}}
  end

  @impl GenServer
  def handle_cast({:workshop, data}, state) do
    Logger.debug("Rx Cast data: #{inspect(data)}")
    {:noreply, %{state | cast_data: data}}
  end

  @impl GenServer
  def handle_cast({:deliver_message, cast_or_send, msg, group, global_or_local}, state) do
    Logger.debug(
      "Workshop #{cast_or_send} #{global_or_local} msg: #{inspect(msg)} to group #{inspect(group)}"
    )

    ViaUtils.Comms.deliver_msg_to_group(
      __MODULE__,
      cast_or_send,
      msg,
      nil,
      group,
      global_or_local
    )

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:get_data, cast_or_send}, _from, state) do
    {:reply, Map.fetch!(state, cast_or_send), state}
  end

  def get_cast_data() do
    GenServer.call(__MODULE__, {:get_data, :cast_data})
  end

  def get_send_data() do
    GenServer.call(__MODULE__, {:get_data, :send_data})
  end

  def send_local_message(message, group \\ nil) do
    send_message(message, group, :local)
  end

  def send_global_message(message, group \\ nil) do
    send_message(message, group, :global)
  end

  def send_message(message, group, global_or_local) do
    GenServer.cast(__MODULE__, {:deliver_message, :send, message, group, global_or_local})
  end

  def cast_local_message(message, group \\ nil) do
    cast_message(message, group, :local)
  end

  def cast_global_message(message, group \\ nil) do
    cast_message(message, group, :global)
  end

  def cast_message(message, group, global_or_local) do
    GenServer.cast(__MODULE__, {:deliver_message, :cast, message, group, global_or_local})
  end
end
