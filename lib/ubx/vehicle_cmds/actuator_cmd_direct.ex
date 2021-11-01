defmodule ViaUtils.Ubx.VehicleCmds.ActuatorCmdDirect do
  require ViaUtils.Ubx.ClassDefs, as: ClassDefs
  defmacro class, do: ClassDefs.vehicle_cmds()
  defmacro id, do: 0x10
  defmacro multiplier, do: 10000

  @doc """
   This is a variable length message - You must define the keys and bytes on your own
   The multiplier for each value is 10000
   Every command consists of a pair:

   channel_number (1 bytes)
   channel_value (2 bytes, [-10000,10000])

  """
end
