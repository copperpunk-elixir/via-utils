defmodule ViaUtils.Shared.ControlTypes do
  defmacro autopilot_control_mode_full_auto, do: 1
  defmacro autopilot_control_mode_controller_assist, do: 2
  defmacro autopilot_control_mode_remote_pilot_override, do: 3
  defmacro input_inverted, do: -1
  defmacro input_not_inverted, do: 1

  # groundspeed_courserate_altituderate_sideslip
  defmacro pilot_control_level_4, do: 4
  # groundspeed_course_altitude_sideslip
  defmacro pilot_control_level_3, do: 3
  # roll_pitch_deltayaw_thrust
  defmacro pilot_control_level_2, do: 2
  # rollrate_pitchrate_yawrate_thrust
  defmacro pilot_control_level_1, do: 1
  defmacro remote_pilot_override, do: 0

  # Controller names (input-output)
  defmacro speed_thrust_pid(), do: :speed_thrust_pid
  defmacro altitude_pitch_pid(), do: :altitude_pitch_pid
  defmacro course_roll_pid(), do: :course_roll_pid
  defmacro roll_rollrate_scalar(), do: :roll_rollrate_scalar
  defmacro pitch_pitchrate_scalar(), do: :pitch_pitchrate_scalar
  defmacro deltayaw_yawrate_scalar(), do: :deltayaw_yawrate_scalar
  defmacro thrust_throttle_scalar(), do: :thrust_throttle_scalar
  defmacro rollrate_aileron_pid(), do: :rollrate_aileron_pid
  defmacro pitchrate_elevator_pid(), do: :pitchrate_elevator_pid
  defmacro yawrate_rudder_pid(), do: :yawrate_rudder_pid

  # Controller parameters
  defmacro min_airspeed_for_climb_mps(), do: :ctrl_min_airspeed_for_climb

  # PID parameters
  defmacro kp(), do: :kp
  defmacro ki(), do: :ki
  defmacro kd(), do: :kd
  defmacro output_min(), do: :output_min
  defmacro output_neutral(), do: :output_neutral
  defmacro output_max(), do: :output_max
  defmacro time_constant_s(), do: :time_constant_s
  defmacro integrator_range(), do: :integrator_range
  defmacro integrator_airspeed_min_mps(), do: :integrator_airspeed_min_mps
  defmacro feed_forward_function(), do: :feed_forward_function
  defmacro feed_forward_multiplier(), do: :feed_forward_multiplier
  defmacro feed_forward_speed_max_mps(), do: :feed_forward_speed_max_mps

  # Scalar Parameters
  defmacro multiplier(), do: :multiplier
  defmacro command_rate_max(), do: :command_rate_max
  defmacro initial_command(), do: :initial_command
end
