class radar::service (
   $host = lookup('slave_aspect::hostname'),
   $docker_repo_dir = $radar::params::docker_repo_dir,
   $user = $radar::params::user,
   $volume_1_dir = $radar::params::volume_1_dir,
   $volume_2_dir = $radar::params::volume_2_dir,
) inherits radar::params {
    require radar::docker
    require radar::configuration
    include ::systemd

    exec { 'create_hadoop_network':
        command => '/usr/bin/docker network create hadoop',
        unless  => '/usr/bin/docker network ls --format "{{.Name}}" | /bin/grep -ce "^hadoop$"',
        user    => 'root',
    }
    exec { 'create_certs_volume':
        command => '/usr/bin/docker volume create certs',
        unless  => '/usr/bin/docker volume ls --format "{{.Name}}" | /bin/grep -ce "^certs$"',
        user    => 'root',
    }
    exec { 'create_certs-data_volume':
        command => '/usr/bin/docker volume create certs-data',
        unless  => '/usr/bin/docker volume ls --format "{{.Name}}" | /bin/grep -ce "^certs-data$"',
        user    => 'root',
    }

    file { $volume_1_dir:
        ensure => directory,
        notify => Service['radar-docker'],
    }

    if $volume_2_dir != $volume_1_dir {
        file { $volume_2_dir:
            ensure => directory,
            notify => Service['radar-docker'],
        }
    }

    ::systemd::unit_file { 'radar-docker.service':
        content => epp('radar/radar-docker.service.epp', {'user' => $user, 'docker_repo_dir' => $docker_repo_dir}),
    } ~>
    service {'radar-docker':
        provider   => systemd,
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => [
            Exec['create_certs_volume'],
            Exec['create_certs-data_volume'],
            Exec['create_hadoop_network'],
        ],
    } ~>
    notifications::hipchat { 'restart-notif':
      message         => "Radar-Docker service restarted on ${host}",
      hipchat_room    => 'CIDER',
      sender          => 'radar-puppet',
    }

    ::systemd::unit_file { 'radar-output.service':
        content => epp('radar/radar-output.service.epp', {'user' => $user, 'docker_repo_dir' => $docker_repo_dir}),
    } ->
    ::systemd::unit_file { 'radar-output.timer':
        content => epp('radar/radar-output.timer.epp', {}),
    } ~>
    service {'radar-output.timer':
        provider => systemd,
        ensure   => running,
        enable   => true,
        require  => Service['radar-docker'],
    }
}
