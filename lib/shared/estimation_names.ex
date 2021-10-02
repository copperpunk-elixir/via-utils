defmodule ViaUtils.Shared.EstimationNames do
  defmacro latitude_rad, do: :latitude_rad
  defmacro longitude_rad, do: :longitude_rad
  defmacro altitude_m, do: :altitude_m
  defmacro ground_altitude_m, do: :ground_altitude_m
  defmacro vertical_velocity_mps, do: :vertical_velocity_mps
  defmacro airspeed_mps, do: :airspeed_mps
  defmacro position_rrm, do: :position_rrm
  defmacro course_rad, do: :course_rad
  defmacro groundspeed_mps, do: :groundspeed_mps
end
