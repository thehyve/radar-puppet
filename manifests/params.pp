class radar::params(
  $hipchat_room           = 'RADAR-Developers',
  $docker_repo            = 'https://github.com/RADAR-CNS/RADAR-Docker.git',
  $docker_repo_revision   = 'dev' ,
  $docker_repo_dir        = 'dcompose-stack/radar-cp-hadoop-stack/',
  $user                   = 'radar',
  $user_ssh_private_key   = '',
  $smtp_host              = 'smtp.gmail.com',
  $smtp_user              = 'radar@thehyve.nl',
  $smtp_pwd               = '',
  $hot_storage_pwd        = '',
  $docker_compose_version = '1.14.0',
  $use_ssl                = true,
  $notification_from      = 'radar@thehyve.nl',
  $notification_to        = 'radar@thehyve.nl',
  $volume_1_dir           = "/home/${user}/data",
  $volume_2_dir           = "/home/${user}/data",
  $output_users           = [],
  $radar_topics           = 'android_empatica_e4_acceleration,android_empatica_e4_acceleration_output,android_empatica_e4_battery_level,android_empatica_e4_battery_level_output,android_empatica_e4_blood_volume_pulse,android_empatica_e4_blood_volume_pulse_output,android_empatica_e4_electrodermal_activity,android_empatica_e4_electrodermal_activity_output,android_empatica_e4_heartrate,android_empatica_e4_inter_beat_interval,android_empatica_e4_inter_beat_interval_output,android_empatica_e4_sensor_status,android_empatica_e4_sensor_status_output,android_empatica_e4_temperature,android_empatica_e4_temperature_output,application_server_status,application_record_counts,application_uptime,application_external_time,android_phone_battery_level,android_phone_acceleration,android_phone_light,android_pebble2_acceleration,android_pebble2_battery_level,android_pebble2_heart_rate,android_pebble2_heart_rate_filtered,schemaless-key,schemaless-value',
  $radar_rest_topics     = 'android_empatica_e4_acceleration_output,android_empatica_e4_battery_level_output,android_empatica_e4_blood_volume_pulse_output,android_empatica_e4_electrodermal_activity_output,android_empatica_e4_heartrate,android_empatica_e4_inter_beat_interval_output,android_empatica_e4_sensor_status_output,android_empatica_e4_temperature_output,application_server_status,application_record_counts,application_uptime,application_external_time',
  $radar_raw_topics      = 'android_empatica_e4_acceleration,android_empatica_e4_battery_level,android_empatica_e4_blood_volume_pulse,android_empatica_e4_electrodermal_activity,android_empatica_e4_inter_beat_interval,android_empatica_e4_sensor_status,android_empatica_e4_temperature,application_server_status,application_record_counts,application_uptime,application_external_time,android_phone_battery_level,android_phone_acceleration,android_phone_light,android_pebble2_acceleration,android_pebble2_battery_level,android_pebble2_heart_rate,android_pebble2_heart_rate_filtered',
) {

}
