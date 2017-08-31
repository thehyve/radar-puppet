class radar::configuration (
    $host = lookup('slave_aspect::hostname'),
    $hot_storage_pwd = $radar::params::hot_storage_pwd,
    $hot_storage_usr = $radar::params::hot_storage_usr,
    $hot_storage_name = $radar::params::hot_storage_name,
    $smtp_host = $radar::params::smtp_host,
    $smtp_user = $radar::params::smtp_user,
    $smtp_pwd  = $radar::params::smtp_pwd,
    $docker_repo_dir = $radar::params::docker_repo_dir,
    $user      = $radar::params::user,
    $use_ssl   = $radar::params::use_ssl,
    $notification_from = $radar::params::notification_from,
    $notification_to = $radar::params::notification_to,
    $notification_threshold = $radar::params::notification_threshold,
    $radar_topics      = $radar::params::radar_topics,
    $radar_raw_topics  = $radar::params::radar_raw_topics,
    $radar_rest_topics = $radar::params::radar_rest_topics,
    $volume_1_dir = $radar::params::volume_1_dir,
    $volume_2_dir = $radar::params::volume_2_dir,
    $output_users = $radar::params::output_users,
    $maintainer_email = $radar::params::maintainer_email,
    $env = $radar::params::env,
) inherits radar::params {
    require radar::user
    require radar::code

    $dcompose_home = "/home/${user}/radar-docker${docker_repo_dir}"

    File {
        ensure          => file,
        owner           => $user,
        notify          => Service['radar-docker'],
    }

    $env_vars = {
        'host'              => $host,
        'use_ssl'           => $use_ssl,
        'hot_storage_pwd'   => $hot_storage_pwd ,
        'radar_topics'      => $radar_topics,
        'radar_raw_topics'  => $radar_raw_topics,
        'radar_rest_topics' => $radar_rest_topics,
        'volume_1_dir'      => $volume_1_dir,
        'volume_2_dir'      => $volume_2_dir,
        'maintainer_email'  => $maintainer_email,
        'env'               => $env,
    }

    file {"${dcompose_home}/.env":
        content => epp('radar/env.epp', $env_vars),
    }

    $smtp_vars = {
        'smart_host' => $smtp_host,
        'smart_port' => $smtp_port,
        'smart_user' => $smtp_user,
        'smart_pwd'  => $smtp_pwd,
    }

    file {"${dcompose_home}/etc/smtp.env":
        content => epp('radar/smtp.epp', $smtp_vars),
    }

    $radar_vars = {
        'notification_from'      => $notification_from,
        'notification_to'        => $notification_to,
        'notification_threshold' => $notification_threshold,
    }

    file {"${dcompose_home}/etc/radar.yml":
        content => epp('radar/radar.yml.epp', $radar_vars),
        replace => no,
    }

    $nginx_vars = {
        # Nothing at the moment
    }

    if ($use_ssl) {
        file {"${dcompose_home}/etc/nginx.conf":
            content => epp('radar/nginx.ssl.conf.epp', $nginx_vars),
        }
    } else {
        file {"${dcompose_home}/etc/nginx.conf":
            content => epp('radar/nginx.conf.epp', $nginx_vars),
        }
    }

    $hdfs_vars = {
        'radar_raw_topics'  => $radar_raw_topics,
    }
    file {"${dcompose_home}/etc/sink-hdfs.properties":
        content => epp('radar/sink-hdfs.properties.epp', $hdfs_vars),
    }

    $mongo_vars = {
        'mongo_password' => $hot_storage_pwd,
        'radar_rest_topics' => $radar_rest_topics,
    }
    file {"${dcompose_home}/etc/sink-mongo.properties":
        content => epp('radar/sink-mongo.properties.epp', $mongo_vars),
    }

    $rest_api_vars = {
        'host'           => $host,
        'mongo_password' => $hot_storage_pwd,
    }
    file {"${dcompose_home}/etc/rest-api/radar.yml":
        content => epp('radar/rest-api.yml.epp', $rest_api_vars),
    }

    $output_users.each | Hash[String, String] $output_user | {
        $htuser = $output_user[user]
        $htpassword = $output_user[password]

        exec { "add_${htuser}_to_htaccess":
            command => "/bin/bash -c 'echo \"${htuser}:$(echo -n '${htpassword}' | /usr/bin/openssl passwd -apr1 -stdin)\" >> ${dcompose_home}/etc/htpasswd'",
            unless  => "/bin/grep -ce '^${htuser}:' ${dcompose_home}/etc/htpasswd",
            notify  => Service['radar-docker'],
        }
    }
}
