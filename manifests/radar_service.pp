class radar::radar_service (
  $user            = $radar::params::user,
  $docker_repo_dir = $radar::params::docker_repo_dir,
) inherits radar:params {

  $config_vars = { 'user' => $user, 'docker_repo_dir' => $docker_repo_dir}

  file {'/etc/init/systemd/system/radar-docker.service':
     ensure  => file,
     content => epp('radar/radar-docker.service.epp', $config_vars),
  }
}
