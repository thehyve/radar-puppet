class radar::notifications (
    $hipchat_room = $radar::params::hipchat_room,
    $hostname     = lookup('slave_aspect::hostname'),
    $docker_commit = $radar::params::docker_commit,
    $docker_branch = $radar::params::docker_branch
)inherits radar::params{
    Notifications::Hipchat {
      hipchat_room => $hipchat_room,
      sender       => 'Radar-Puppet',

    }

    notifications::hipchat {'docker-repo-updated':
      message => "Radar-Docker repository has been updated at ${hostname}. Current branch: ${docker_branch}, current commit: ${docker_commit}",
    }
}
