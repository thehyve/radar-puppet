class radar::user (
    $user = $radar::params::user,
    $repo_key = $radar::params::user_ssh_private_key,
) inherits radar::params {
    group { $user:
        ensure => present,
    }

    $ssh_dir = "/home/${user}/.ssh"

    user { $user:
        ensure        => present,
        comment       => "User running Radar stack",
        gid           => $user,
        managehome    => true,
        home          => "/home/${user}",
        shell         => '/bin/sh',
        require => [
            Group[$user],
        ]
    } ->
    file { "/home/${user}":
        ensure => directory,
        mode   => '0755',
        owner  =>   $user,
    } ->
    file { "${ssh_dir}":
        ensure => directory,
        mode   => '0700',
        owner  => $user,
    } ->
    file { "${ssh_dir}/id_rsa":
        ensure  => file,
        content => $repo_key,
        mode    => '0600',
        owner   => $user,
    }

    # fix exception when github is not in known hosts
    # in non-interactive mode.
    $known_hosts = "${ssh_dir}/known_hosts"

    exec { 'add_github_ssh_known_hosts':
        command => "/usr/bin/ssh-keyscan -t rsa github.com >> '${ssh_dir}/known_hosts'",
        unless  => "/bin/grep -c github.com '${ssh_dir}/known_hosts' 2>/dev/null",
        require => File["${ssh_dir}"],
    }
}
