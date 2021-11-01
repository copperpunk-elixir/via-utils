defmodule ViaUtils.Shared.Groups do
  defmacro airspeed_val, do: :airspeed_val
  defmacro autopilot_control_mode, do: :autopilot_control_mode
  defmacro clear_mission, do: :clear_mission
  defmacro controller_bodyrate_commands, do: :controller_bodyrate_commands
  defmacro controller_direct_actuator_output, do: :controller_direct_actuator_output
  defmacro command_channels, do: :command_channels
  defmacro commands_for_current_pilot_control_level, do: :commands_for_current_pcl
  defmacro commands_for_any_pilot_control_level, do: :commands_for_any_pcl
  defmacro current_pilot_control_level_and_commands, do: :current_pcl_and_commands
  defmacro display_mission, do: :display_mission
  defmacro downward_range_distance_val, do: :downward_range_distance_val
  defmacro dt_accel_gyro_val, do: :dt_accel_gyro_val
  defmacro estimation_attitude, do: {:estimation_values, :attitude}

  defmacro estimation_position_velocity,
    do: {:estimation_values, :position_velocity}

  defmacro get_host_ip_address, do: :get_host_ip_address
  defmacro get_realflight_ip_address, do: :get_realflight_ip_address

  defmacro gps_itow_position_velocity_val, do: :gps_pos_vel_val
  defmacro gps_itow_relheading_val, do: :gps_relhdg_val

  defmacro host_ip_address, do: :host_ip_address
  defmacro load_mission, do: :load_mission
  defmacro message_sorter_value, do: :message_sorter_value
  defmacro realflight_ip_address, do: :realflight_ip_address
  defmacro remote_pilot_override_commands, do: :remote_pilot_override_commands
  defmacro roll_pitch_yawrate_thrust_cmd, do: :rp_ydot_t_cmd
  defmacro rollrate_pitchrate_yawrate_thrust_cmd, do: :rdot_pdot_y_dot_t_cmd
  defmacro set_realflight_ip_address, do: :set_realflight_ip_address
  defmacro simulation_update_actuators, do: :simulation_update_actuators
  defmacro sorter_pilot_control_level_and_goals, do: :sorter_pcl_and_goals
  defmacro speed_course_altitude_sideslip_cmd, do: :scas_cmd
  defmacro speed_courserate_altituderate_sideslip_cmd, do: :s_cdot_adot_s_cmd
  defmacro virtual_uart_downward_range, do: :virtual_uart_downward_range
  defmacro virtual_uart_dt_accel_gyro, do: :virtual_uart_dt_accel_gyro
  defmacro virtual_uart_gps, do: :virtual_uart_gps
  defmacro virtual_uart_command_rx, do: :virtual_uart_command_rx
  defmacro virtual_uart_companion, do: :virtual_uart_companion
  defmacro virtual_uart_actuator_output, do: :virtual_uart_actuator_output
end
