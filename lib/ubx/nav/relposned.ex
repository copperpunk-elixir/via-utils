defmodule ViaUtils.Ubx.Nav.Relposned do
  require ViaUtils.Ubx.ClassDefs, as: ClassDefs
  defmacro class, do: ClassDefs.nav()
  defmacro id, do: 0x3C

  defmacro bytes,
    do: [1, 1, 2, 4, -4, -4, -4, -4, -4, 4, -1, -1, -1, -1, 4, 4, 4, 4, 4, 4, 4]

  defmacro multipliers,
    do: [1, 1, 1, 1, 1, 1, 1, 1, 1.0e-5, 1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 1.0e-5, 1, 1]

  defmacro version(), do: :version
  defmacro reserved1(), do: :reserved1
  defmacro refStationId(), do: :ref_station_id
  defmacro iTOW(), do: :itow_ms
  defmacro relPosN(), do: :rel_pos_n_cm
  defmacro relPosE(), do: :rel_pos_e_cm
  defmacro relPosD(), do: :rel_pos_d_cm
  defmacro relPosLength(), do: :rel_pos_length_cm
  defmacro relPosHeading(), do: :rel_pos_hdg_deg
  defmacro reserved2(), do: :reserved2
  defmacro relPosHPN(), do: :rel_pos_hpn_mm
  defmacro relPosHPE(), do: :rel_pos_hpe_mm
  defmacro relPosHPD(), do: :rel_pos_hpd_mm
  defmacro relPosHPLength(), do: :rel_pos_hp_len_mm
  defmacro accN(), do: :acc_n_mm
  defmacro accE(), do: :acc_e_mm
  defmacro accD(), do: :acc_d_mm
  defmacro accLength(), do: :acc_len_mm
  defmacro accHeading(), do: :acc_hdg_deg
  defmacro reserved3(), do: :reserved3
  defmacro flags(), do: :flags

  defmacro keys,
    do: [
      version(),
      reserved1(),
      refStationId(),
      iTOW(),
      relPosN(),
      relPosE(),
      relPosD(),
      relPosLength(),
      relPosHeading(),
      reserved2(),
      relPosHPN(),
      relPosHPE(),
      relPosHPD(),
      relPosHPLength(),
      accN(),
      accE(),
      accD(),
      accLength(),
      accHeading(),
      reserved3(),
      flags()
    ]
end
