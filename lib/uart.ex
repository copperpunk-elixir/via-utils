defmodule ViaUtils.Uart do
  require Logger

  @moduledoc """
  Documentation for `UtilsUart`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> UtilsUart.hello()
      :world

  """
  @spec open_connection_and_return_uart_ref(binary(), list()) :: any()
  def open_connection_and_return_uart_ref(device_description, options) do
    {:ok, uart_ref} = Circuits.UART.start_link()
    open_connection_with_uart_ref(uart_ref, device_description, options)
    uart_ref
  end

  @spec open_connection_with_uart_ref(GenServer.server(), binary(), list(), integer) :: atom()
  def open_connection_with_uart_ref(uart_ref, device_description, options, num_tries \\ 1) do
    port = get_uart_devices_containing_string(device_description)
    Logger.debug("Opening #{device_description}. Attempt #{num_tries}")

    case Circuits.UART.open(uart_ref, port, options) do
      {:error, error} ->
        Logger.error(
          "Error opening UART #{device_description}: #{inspect(error)}. Retrying in 1s"
        )

        Process.sleep(1000)
        open_connection_with_uart_ref(uart_ref, device_description, options, num_tries + 1)

      _success ->
        Logger.debug("#{device_description} opened UART")
    end
  end

  @spec get_uart_devices_containing_string(binary()) :: list()
  def get_uart_devices_containing_string(device_string) do
    if String.contains?(device_string, "ttyAMA") or String.contains?(device_string, "ttyS0") do
      # open port directly
      device_string
    else
      device_string = String.downcase(device_string)
      Logger.debug("devicestring: #{device_string}")
      uart_ports = Circuits.UART.enumerate()
      Logger.debug("ports: #{inspect(uart_ports)}")

      matching_ports =
        Enum.reduce(uart_ports, [], fn {port_name, port}, acc ->
          device_description = Map.get(port, :description, "")
          Logger.debug("description: #{String.downcase(device_description)}")

          if String.contains?(String.downcase(device_description), device_string) do
            acc ++ [port_name]
          else
            acc
          end
        end)

      case length(matching_ports) do
        0 -> Logger.error("no devices matching the description")
        1 -> Enum.at(matching_ports, 0)
        num_matches -> raise "There are #{num_matches} matching devices"
      end
    end
  end

  @spec real_ubx_write() :: function()
  def real_ubx_write() do
    fn ubx_message, uart_ref ->
      Circuits.UART.write(uart_ref, ubx_message)
    end
  end

  @spec virtual_ubx_write(any(), any()) :: function()
  def virtual_ubx_write(group, operator) do
    fn ubx_message, _ ->
      # Logger.debug("group, msg: #{inspect(group)}/#{inspect(ubx_message)}")

      # if is_nil(ubx_message) do
      #   Logger.warn("#{operator} nil message")
      # else
        ViaUtils.Comms.send_local_msg_to_group(
          operator,
          {:circuits_uart, 0, ubx_message},
          self(),
          group
        )
      # end
    end
  end
end
