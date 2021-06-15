defmodule ViaUtils.Process.StartTimerTest do
 use ExUnit.Case
  require Logger

  setup do
    {:ok, []}
  end

  test "Start timer with decimal interval test" do
    {:ok, pid} = ViaUtils.Helper.Process.GenServer.start_link(nil)
    ViaUtils.Process.start_loop(pid, 20, :timer_callback)
    Process.sleep(1000)
  end
end
