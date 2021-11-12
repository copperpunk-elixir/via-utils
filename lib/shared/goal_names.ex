defmodule ViaUtils.Shared.GoalNames do
  require ViaUtils.Shared.ValueNames, as: SVN

  defmacro agl_m(), do: :goal_agl_m
  defmacro aileron_scaled, do: :aileron_scaled
  defmacro altitude_m(), do: :goal_altitude_m
  defmacro altitude_rate_mps(), do: :goal_altitude_rate_mps
  defmacro any_pcl(), do: :any_pcl
  defmacro autopilot_control_mode(), do: :autopilot_control_mode
  defmacro course_rad(), do: :goal_course_rad
  defmacro course_rate_rps(), do: :goal_course_rate_rps
  defmacro current_pcl(), do: :current_pcl
  defmacro elevator_scaled, do: :elevator_scaled
  defmacro groundspeed_mps(), do: :goal_groundspeed_mps
  defmacro deltayaw_rad(), do: :goal_deltayaw_rad
  defmacro flaps_scaled(), do: :flaps_scaled
  defmacro gear_scaled(), do: :gear_scaled
  defmacro pilot_control_level(), do: SVN.pilot_control_level()
  defmacro pitch_rad(), do: :goal_pitch_rad
  defmacro pitchrate_rps(), do: :goal_pitchrate_rps
  defmacro roll_rad(), do: :goal_roll_rad
  defmacro rollrate_rps(), do: :goal_rollrate_rps
  defmacro rudder_scaled, do: :rudder_scaled
  defmacro sideslip_rad(), do: :goal_sideslip_rad
  defmacro throttle_scaled(), do: :throttle_scaled
  defmacro thrust_scaled(), do: :thrust_scaled
  defmacro time_since_boot_s(), do: SVN.time_since_boot_s()
  defmacro vehicle_id(), do: SVN.vehicle_id()
  defmacro yaw_rad(), do: :goal_yaw_rad
  defmacro yawrate_rps(), do: :goal_yawrate_rps

  defmacro cmds_pcl_1(), do: [rollrate_rps(), pitchrate_rps(), yawrate_rps(), throttle_scaled()]
  defmacro cmds_pcl_2(), do: [roll_rad(), pitch_rad(), deltayaw_rad(), thrust_scaled()]
  defmacro cmds_pcl_3(), do: [groundspeed_mps(), course_rad(), altitude_m(), sideslip_rad()]

  defmacro cmds_pcl_4(),
    do: [groundspeed_mps(), course_rate_rps(), altitude_rate_mps(), sideslip_rad()]
end
