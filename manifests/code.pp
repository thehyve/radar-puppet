class radar::code (
  $repository    = $radar::params::docker_repo,
  $user          = $radar::params::user,
  $revision      = $radar::params::docker_repo_revision,
) inherits radar::params {
    package { 'git':
        ensure => 'present'
    }

    $repo_dir  = "/home/${user}/radar-docker"

    vcsrepo { "${repo_dir}":
        ensure   => present,
        provider => git,
        source   => $repository,
        user     => $user,
        revision => $revision,
        require  => [Exec['add_github_ssh_known_hosts'], File["/home/${user}/.ssh/id_rsa"]],
    }
}
