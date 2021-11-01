defmodule ViaUtils.Ubx.VehicleCmds.BodyrateActuatorOutput do
  require ViaUtils.Ubx.ClassDefs, as: ClassDefs
  require ViaUtils.Shared.ActuatorNames, as: SAN
  defmacro class, do: ClassDefs.vehicle_cmds()
  defmacro id, do: 0x02
  defmacro bytes, do: [-2, -2, -2, 2]
  defmacro multiplier, do: [1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4]
  defmacro keys, do: [SAN.aileron(), SAN.elevator(), SAN.throttle(), SAN.rudder()]
end
