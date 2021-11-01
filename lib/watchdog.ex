defmodule ViaUtils.Watchdog do
  require Logger
  defstruct [:timer, :duration_ms, :callback]

  @spec new(any()) :: struct()
  def new(callback) do
    %ViaUtils.Watchdog{callback: callback}
  end

  @spec new(any(), integer()) :: struct()
  def new(callback, duration_ms) do
    Logger.debug("New watchdog with callback #{inspect(callback)} every #{duration_ms} ms")
    %ViaUtils.Watchdog{callback: callback, duration_ms: round(duration_ms)}
  end

  @spec reset(struct()) :: struct()
  def reset(watchdog) do
    %{callback: callback, timer: timer, duration_ms: duration_ms} = watchdog

    # Logger.debug(
    #   "reset watchdog #{inspect(callback)}/#{duration_ms} with timer: #{inspect(timer)}"
    # )

    if is_nil(duration_ms),
      do: raise("Watchdog #{inspect(callback)} duration_ms has not been set.")

    timer = ViaUtils.Process.reattach_timer(timer, duration_ms, callback)

    %{watchdog | timer: timer}
  end

  @spec reset(struct(), integer()) :: struct()
  def reset(watchdog, duration_ms) do
    %{callback: callback, timer: timer} = watchdog
    # Logger.debug("reset watchdog #{inspect(callback)} with timer: #{inspect(timer)}")
    timer = ViaUtils.Process.reattach_timer(timer, round(duration_ms), callback)
    %{watchdog | timer: timer}
  end
end
