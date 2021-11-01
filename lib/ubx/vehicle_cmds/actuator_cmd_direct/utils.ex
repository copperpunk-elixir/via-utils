defmodule ViaUtils.Ubx.VehicleCmds.ActuatorCmdDirect.Utils do
  require ViaUtils.Ubx.VehicleCmds.ActuatorCmdDirect, as: ActuatorCmdDirect
  require Logger

  def get_payload_bytes_and_values(actuator_output_map, channel_names) do
    {channel_payload_values, channel_payload_bytes} =
      Enum.reduce(channel_names, {[], []}, fn {ch_num, ch_name}, {values_acc, bytes_acc} ->
        actuator_output = Map.fetch!(actuator_output_map, ch_name)

        {[1, -2] ++ bytes_acc,
         [ch_num, round(actuator_output * ActuatorCmdDirect.multiplier())] ++ values_acc}
      end)

    Logger.debug(
      "act msg val/bytes: #{ViaUtils.Format.eftb_list(channel_payload_values, 0)}:#{inspect(channel_payload_bytes)}"
    )

    {channel_payload_bytes, channel_payload_values}
  end

  def get_actuator_output(payload) do
    Enum.map_every(payload, 3, fn value ->
      value * 1.0e-4
    end)
  end
end
