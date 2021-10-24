defmodule ViaUtils.Ubx.AccelGyro.DtAccelGyro do
  require ViaUtils.Constants, as: VC
  require ViaUtils.Ubx.ClassDefs, as: ClassDefs
  require ViaUtils.Shared.ValueNames, as: SVN
  defmacro class, do: ClassDefs.accel_gyro()
  defmacro id, do: 0x00
  defmacro bytes, do: [2, -2, -2, -2, -2, -2, -2]

  defmacro multipliers,
    do: [
      1.0e-6,
      VC.gravity() / 8192,
      VC.gravity() / 8192,
      VC.gravity() / 8192,
      VC.deg2rad() / 16.4,
      VC.deg2rad() / 16.4,
      VC.deg2rad() / 16.4
    ]

  defmacro dt_s(), do: SVN.dt_s()
  defmacro ax_mpss(), do: SVN.accel_x_mpss()
  defmacro ay_mpss(), do: SVN.accel_y_mpss()
  defmacro az_mpss(), do: SVN.accel_z_mpss()
  defmacro gx_rps(), do: SVN.gyro_x_rps()
  defmacro gy_rps(), do: SVN.gyro_y_rps()
  defmacro gz_rps(), do: SVN.gyro_z_rps()
  defmacro keys, do: [dt_s(), ax_mpss(), ay_mpss(), az_mpss(), gx_rps(), gy_rps(), gz_rps()]
end
