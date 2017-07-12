# Puppet module of the RADAR docker-compose stack

This installs the [RADAR docker-compose stack](https://github.com/RADAR-CNS/RADAR-Docker) using [Puppet](https://Puppet.com). This Puppet module leaves the RADAR docker-compose stack in a consistent state, so if Puppet is no longer used the stack will remain fully functional.

The module will install `docker-ce` and `docker-compose` from the Docker repository as well as a `radar-docker` systemd service.

## Requirements

This Puppet module has been tested on Ubuntu 16.04 LTS with systemd, but it should also work with Ubuntu versions 14.04 LTS, 16.10, 17.04 and 17.10 as long as they use systemd and the Puppet systemd module is installed.

## Configuration

To use RADAR-docker in your projects, write `include radar` in your Puppet manifest. This will update all RADAR-Docker configuration to the Puppet configuration. Note that while Puppet is running, it will revert any locally made changes to the RADAR-Docker configuration.

The following properties are required to be set:

```yaml
# SMTP details for sending notifications
radar::params::smtp_host: mail.example.com
radar::params::smtp_user: myuser@example.com
radar::params::smtp_pwd: mypassword
radar::params::notification_from: no-reply@example.com
radar::params::notification_to: myuser@example.com

# mongodb password
radar::params::hot_storage_pwd: random_string
```

The following properties are optional

```yaml
# Github repository to use for the RADAR-Docker stack
radar::params::docker_repo: https://github.com/RADAR-CNS/RADAR-Docker.git
radar::params::docker_repo_revision: dev
radar::params::docker_repo_dir: "/dcompose-stack/radar-cp-hadoop-stack"

# whether to use SSL on your host. If true,
# HTTP 443 will be used. Call renew_ssl_certificate
# twice (!!) from the RADAR-Docker repository afterwards to
# obtain a LetsEncrypt certificate
radar::params::use_ssl: true

# system user name
radar::params::user: radar

# Private SSH key, this can be used to retrieve
# a private git repository. Add the corresponding
# public key to the git repository deploy keys.
radar::params::user_ssh_private_key: |
  --- BEGIN PRIVATE KEY ---
  ...
  --- END PRIVATE KEY ---

# specify multiple volumes, if present
radar::params::volume_1_dir: /home/radar/data
radar::params::volume_2_dir: /home/radar/data

# Docker-compose version
radar::params::docker_compose_version: 1.14.0

# define output users
radar::params::output_users:
  - user: test
    password: mypassword
  - user: test2
    password: myotherpassword

# topics to allow and follow
radar::params::radar_topics: "android_empatica_e4_acceleration,android_empatica_e4_acceleration_output,android_empatica_e4_battery_level,android_empatica_e4_battery_level_output,android_empatica_e4_blood_volume_pulse,android_empatica_e4_blood_volume_pulse_output,android_empatica_e4_electrodermal_activity,android_empatica_e4_electrodermal_activity_output,android_empatica_e4_heartrate,android_empatica_e4_inter_beat_interval,android_empatica_e4_inter_beat_interval_output,android_empatica_e4_sensor_status,android_empatica_e4_sensor_status_output,android_empatica_e4_temperature,android_empatica_e4_temperature_output,application_server_status,application_record_counts,application_uptime,application_external_time,android_phone_battery_level,android_phone_acceleration,android_phone_light,android_pebble2_acceleration,android_pebble2_battery_level,android_pebble2_heart_rate,android_pebble2_heart_rate_filtered,schemaless-key,schemaless-value"
radar::params::radar_rest_topics: "android_empatica_e4_acceleration_output,android_empatica_e4_battery_level_output,android_empatica_e4_blood_volume_pulse_output,android_empatica_e4_electrodermal_activity_output,android_empatica_e4_heartrate,android_empatica_e4_inter_beat_interval_output,android_empatica_e4_sensor_status_output,android_empatica_e4_temperature_output,application_server_status,application_record_counts,application_uptime,application_external_time"
radar::params::radar_raw_topics: "android_empatica_e4_acceleration,android_empatica_e4_battery_level,android_empatica_e4_blood_volume_pulse,android_empatica_e4_electrodermal_activity,android_empatica_e4_inter_beat_interval,android_empatica_e4_sensor_status,android_empatica_e4_temperature,application_server_status,application_record_counts,application_uptime,application_external_time,android_phone_battery_level,android_phone_acceleration,android_phone_light,android_pebble2_acceleration,android_pebble2_battery_level,android_pebble2_heart_rate,android_pebble2_heart_rate_filtered"
```
