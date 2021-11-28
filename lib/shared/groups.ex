defmodule ViaUtils.Shared.Groups do
  @processed :processed
  @ubx :ubx

  defmacro airspeed_val, do: :airspeed_val
  defmacro autopilot_control_mode, do: :autopilot_control_mode
  defmacro clear_mission, do: :clear_mission
  defmacro controller_bodyrate_throttle_commands, do: :controller_bodyrate_throttle_commands
  defmacro controller_direct_actuator_output, do: :controller_direct_actuator_output
  defmacro command_channels, do: :command_channels
  defmacro commands_for_current_pilot_control_level, do: :commands_for_current_pcl
  defmacro commands_for_any_pilot_control_level, do: :commands_for_any_pcl
  defmacro current_pcl_and_all_commands_val, do: {@processed, :current_pcl_and_commands}
  defmacro display_mission, do: :display_mission
  defmacro downward_range_distance_val, do: {@processed, :downward_range_distance_val}
  defmacro dt_accel_gyro_val, do: {@processed, :dt_accel_gyro_val}
  defmacro estimation_attitude_attrate_val, do: {@processed, :attitude_atttituderate}

  defmacro estimation_position_velocity_val,
    do: {@processed, :position_velocity}

  defmacro get_host_ip_address, do: :get_host_ip_address
  defmacro get_realflight_ip_address, do: :get_realflight_ip_address

  defmacro gps_itow_position_velocity_val, do: {@processed, :gps_pos_vel_val}
  defmacro gps_itow_relheading_val, do: {@processed, :gps_relhdg_val}

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
  defmacro subscribe_to_msg, do: :subscribe_to_msg
  defmacro telemetry_ground_send_message(), do: :telemetry_ground_send_msg
  defmacro val_prefix, do: @processed
  defmacro ubx_attitude_attrate_val, do: {@ubx, :attitude_attrate_val}
  defmacro ubx_attitude_thrust_cmd, do: {@ubx, :attitude_thrust_cmd}
  defmacro ubx_bodyrate_throttle_cmd, do: {@ubx, :bodyrate_throttle_cmd}
  defmacro ubx_position_velocity_val, do: {@ubx, :position_velocity_val}
  defmacro ubx_speed_course_altitude_sideslip_cmd, do: {@ubx, :scas_cmd}
  defmacro ubx_speed_courserate_altrate_sideslip_cmd, do: {@ubx, :scrars_cmd}
  defmacro virtual_uart_command_rx, do: :virtual_uart_command_rx
  defmacro virtual_uart_companion, do: :virtual_uart_companion
  defmacro virtual_uart_downward_range, do: :virtual_uart_downward_range
  defmacro virtual_uart_dt_accel_gyro, do: :virtual_uart_dt_accel_gyro
  defmacro virtual_uart_gps, do: :virtual_uart_gps
  defmacro virtual_uart_telemetry_ground, do: :virtual_telemetry_ground
  defmacro virtual_uart_telemetry_vehicle, do: :virtual_telemetry_vehicle
  defmacro virtual_uart_actuator_output, do: :virtual_uart_actuator_output
end
