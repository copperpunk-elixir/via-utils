defmodule ViaUtils.Ubx.Nav.Pvt do
  require ViaUtils.Ubx.ClassDefs, as: ClassDefs
  defmacro class, do: ClassDefs.nav()
  defmacro id, do: 0x07

  defmacro bytes,
    do: [
      4,
      2,
      1,
      1,
      1,
      1,
      1,
      1,
      4,
      -4,
      1,
      1,
      1,
      1,
      -4,
      -4,
      -4,
      -4,
      4,
      4,
      -4,
      -4,
      -4,
      -4,
      -4,
      4,
      4,
      2,
      1,
      1,
      -4,
      -2,
      2
    ]

  defmacro multipliers,
    do: [
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1.0e-7,
      1.0e-7,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1.0e-5,
      1,
      1.0e-5,
      0.01,
      1,
      1,
      1.0e-5,
      0.01,
      0.01
    ]

  defmacro iTOW(), do: :itow_ms
  defmacro year(), do: :year
  defmacro month(), do: :month
  defmacro day(), do: :day
  defmacro hour(), do: :hour
  defmacro min(), do: :min
  defmacro sec(), do: :sec
  defmacro valid(), do: :valid
  defmacro tAcc(), do: :t_acc_ns
  defmacro nano(), do: :nano_ns
  defmacro fixType(), do: :fix_type
  defmacro flags(), do: :flags
  defmacro flags2(), do: :flags2
  defmacro numSV(), do: :num_sv
  defmacro lon(), do: :longitude_deg
  defmacro lat(), do: :latitude_deg
  defmacro height(), do: :height_mm
  defmacro hMSL(), do: :h_msl_mm
  defmacro hAcc(), do: :h_acc_mm
  defmacro vAcc(), do: :v_acc_mm
  defmacro velN(), do: :v_north_mmps
  defmacro velE(), do: :v_east_mmps
  defmacro velD(), do: :v_down_mmps
  defmacro gSpeed(), do: :groundspeed_mmps
  defmacro headMot(), do: :heading_of_motion_deg
  defmacro sAcc(), do: :speed_acc_est_mmps
  defmacro headAcc(), do: :heading_acc_est_deg
  defmacro pDOP(), do: :position_dop
  defmacro flags3(), do: :flags3
  defmacro reserved1(), do: :reserved1
  defmacro headVeh(), do: :heading_of_vehicle_deg
  defmacro magDec(), do: :mag_dec_deg
  defmacro magAcc(), do: :mag_dec_acc_deg

  defmacro keys,
    do: [
      iTOW(),
      year(),
      month(),
      day(),
      hour(),
      min(),
      sec(),
      valid(),
      tAcc(),
      nano(),
      fixType(),
      flags(),
      flags2(),
      numSV(),
      lon(),
      lat(),
      height(),
      hMSL(),
      hAcc(),
      vAcc(),
      velN(),
      velE(),
      velD(),
      gSpeed(),
      headMot(),
      sAcc(),
      headAcc(),
      pDOP(),
      flags3(),
      reserved1(),
      headVeh(),
      magDec(),
      magAcc()
    ]
end
