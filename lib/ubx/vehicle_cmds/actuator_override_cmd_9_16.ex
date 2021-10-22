defmodule ViaUtils.Ubx.VehicleCmds.ActuatorOverrideCmd_9_16 do
  require ViaUtils.Ubx.ClassDefs, as: ClassDefs
  require ViaUtils.Shared.ActuatorNames, as: Act
  defmacro class, do: ClassDefs.vehicle_cmds()
  defmacro id, do: 0x11
  defmacro bytes, do: [-2, -2, -2, -2, -2, -2, -2, -2, 1]
  defmacro multiplier, do: [1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4, 1]

  defmacro keys,
    do: [
      Act.aileron(),
      Act.elevator(),
      Act.throttle(),
      Act.rudder(),
      Act.flaps(),
      Act.gear(),
      Act.aux1(),
      Act.process_actuators()
    ]
end
