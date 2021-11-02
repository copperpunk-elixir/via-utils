defmodule ViaUtils.Ubx.VehicleCmds.ActuatorCmdDirect.Utils do
  require ViaUtils.Ubx.VehicleCmds.ActuatorCmdDirect, as: ActuatorCmdDirect
  require Logger

  def get_payload_bytes_and_values(actuator_output_map, channel_names) do
    Enum.reduce(channel_names, {[], []}, fn {ch_num, ch_name}, {bytes_acc, values_acc} ->
      actuator_output = Map.fetch!(actuator_output_map, ch_name)

      {[1, -2] ++ bytes_acc,
       [ch_num, round(actuator_output / ActuatorCmdDirect.multipliers())] ++ values_acc}
    end)
  end

  def get_actuator_output(payload, channel_names) do
    Enum.reduce(Stream.chunk_every(payload, 3), %{}, fn [ch_num | value_two_bytes], acc ->
      # Logger.debug("ch/two_bytes: #{ch_num}/#{inspect(value_two_bytes)}")

      value =
        ViaUtils.Enum.list_to_int(value_two_bytes, 2)
        |> ViaUtils.Math.twos_comp(16)
        |> Kernel.*(ActuatorCmdDirect.multipliers())

      channel_name = Map.get(channel_names, ch_num, nil)
      if is_nil(channel_name), do: acc, else: Map.put(acc, channel_name, value)
    end)
  end
end
