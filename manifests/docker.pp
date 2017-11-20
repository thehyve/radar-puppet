class radar::docker (
  $docker_compose_version = $radar::params::docker_compose_version
) inherits radar::params {
    include ::apt

    unless $::lsbdistcodename in ['xenial', 'zesty', 'yakkety', 'trusty'] {
        fail("Only trusty is supported, not $::lsbdistcodename")
    }

    apt::source { 'docker':
        location    => 'https://download.docker.com/linux/ubuntu',
        release     => $::lsbdistcodename,
        repos       => 'stable',
        key         => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
        key_server  => 'keyserver.ubuntu.com',
        include_src => false,
    } ->
    package { 'docker-ce':
        ensure => present,
    } ~>
    file_line { 'Docker without iptables':
        path   => '/lib/systemd/system/docker.service',
        line   => 'ExecStart=/usr/bin/dockerd -H fd:// --iptables=false --dns 8.8.8.8 --dns 8.8.4.4',
        match  => '^ExecStart=/usr/bin/dockerd -H fd://',
        ensure => present,
    }

    $docker_compose = '/usr/local/bin/docker-compose'

    exec { 'download docker-compose':
        command => "/usr/bin/curl -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-Linux-x86_64 > ${docker_compose}",
        user    => 'root',
        creates => $docker_compose,
    } ->
    file { $docker_compose:
        mode => '755',
    }
}
