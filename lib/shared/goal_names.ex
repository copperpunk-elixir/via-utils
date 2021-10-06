defmodule ViaUtils.Shared.GoalNames do
  defmacro course_rate_rps(), do: :course_rate_rps
  defmacro altitude_rate_mps(), do: :altitude_rate_rps
  defmacro groundspeed_mps(), do: :groundspeed_mps
  defmacro sideslip_rad(), do: :sideslip_rad
  defmacro roll_rad(), do: :roll_rad
  defmacro pitch_rad(), do: :pitch_rad
  defmacro deltayaw_rad(), do: :deltayaw_rad
  defmacro thrust_scaled(), do: :thrust_scaled
  defmacro rollrate_rps(), do: :rollrate_rps
  defmacro pitchrate_rps(), do: :pitchrate_rps
  defmacro yawrate_rps(), do: :yawrate_rps
  defmacro throttle_scaled(), do: :throttle_scaled
  defmacro flaps_scaled(), do: :flaps_scaled
  defmacro gear_scaled(), do: :gear_scaled
  defmacro pilot_control_level(), do: :pilot_control_level
  defmacro autopilot_control_mode(), do: :autopilot_control_mode
  defmacro current_pcl(), do: :current_pcl
  defmacro any_pcl(), do: :any_pcl
end
