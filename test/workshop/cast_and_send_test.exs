defmodule ViaUtils.Process.StartTimerTest do
  use ExUnit.Case
  require Logger

  setup do
    RingLogger.attach()
    ViaUtils.Comms.Supervisor.start_link(nil)
    {:ok, []}
  end

  test "Cast and Send Test" do
    groups = [:gps_uart, :companion]
    config = [groups: groups]
    ViaUtils.Workshop.start_link(config)
    Process.sleep(20)
    send_data = %{x: 5}
    cast_data = [test: :success]

    Enum.each(groups, fn group ->
      ViaUtils.Workshop.send_local_message({:workshop, send_data}, group)
      ViaUtils.Workshop.cast_local_message({:workshop, cast_data}, group)
    end)

    Process.sleep(50)
    send_data_rx = ViaUtils.Workshop.get_send_data()
    cast_data_rx = ViaUtils.Workshop.get_cast_data()
    Logger.debug("Send data: #{inspect(send_data_rx)}")
    assert send_data == send_data_rx
    Logger.debug("Cast data: #{inspect(cast_data_rx)}")
    assert cast_data == cast_data_rx
  end
end
