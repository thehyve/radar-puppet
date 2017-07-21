class radar {
    include radar::params
    include radar::user
    include radar::code
    include radar::docker
    include radar::configuration
    include radar::service

    package { 'default-jre-headless':
        ensure => present,
    } ->
    file { "/etc/environment":
        ensure  => file,
    } ->
    file_line { 'Append JAVA_HOME to /etc/environment':
        path  => '/etc/environment',
        line  => 'JAVA_HOME=/usr/lib/jvm/default-java/jre',
        match => "^\s*JAVA_HOME=.*$",
    } ~>
    notifications::hipchat { 'test-msg':
      message         => "Config updated",
      hipchat_room    => 'CHDR - CIDER',
      sender          => 'radar-puppet',
    }
}
