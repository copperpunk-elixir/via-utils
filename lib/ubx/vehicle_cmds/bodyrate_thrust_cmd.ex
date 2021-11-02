defmodule ViaUtils.Ubx.VehicleCmds.BodyrateThrustCmd do
  require ViaUtils.Ubx.ClassDefs, as: ClassDefs
  defmacro class, do: ClassDefs.vehicle_cmds()
  defmacro id, do: 0x01
  defmacro bytes, do: [-2, -2, -2, 2]
  defmacro multipliers, do: [1.0e-3, 1.0e-3, 1.0e-3, 1.0e-4]
  defmacro keys, do: [:rollrate_rps, :pitchrate_rps, :yawrate_rps, :thrust_scaled]
end
