class ss_nessus_agent::agent inherits ::ss_nessus_agent {

  if $ss_nessus_agent::http_proxy {
      $proxy_environment = ["http_proxy=${ss_nessus_agent::http_proxy}", "https_proxy=${ss_nessus_agent::http_proxy}"]
  } else {
      $proxy_environment = []
  }

  exec { 'download':
    command     => "curl -s -f ${ss_nessus_agent::download_url} -o /usr/src/nessusagent.deb",
    path        => '/usr/bin:/usr/sbin:/bin',
    onlyif      => "test ! -f /usr/src/nessusagent.deb",
    environment => $proxy_environment,
  }
  -> package { 'nessusagent':
    ensure   => installed,
    provider => dpkg,
    source   => '/usr/src/nessusagent.deb',
  }

  # The setup and configuration utilises the custom facts
  if $params::nessus_agent_enabled == true {
    if !$facts['ss_nessus_agent_connected'] {
      exec { 'ss_nessus_agent_install_agent':
        command => "sudo -u root dpkg -i /usr/src/nessusagent.deb",
        path    => '/usr/bin:/usr/sbin:/bin',
      }
      -> exec { 'ss_nessus_agent_start_agent':
        command => "sudo -u root systemctl start nessusagent",
        path    => '/usr/bin:/usr/sbin:/bin',
      }
      -> exec { 'ss_nessus_agent_link_agent':
        command => "/opt/nessus_agent/sbin/nessuscli agent link --key=${ss_nessus_agent::link_token} name=${$facts['environmentname']} --cloud --proxy-host=${ss_nessus_agent::http_proxy_host} --proxy-port=${ss_nessus_agent::http_proxy_port}",
        path    => '/usr/bin:/usr/sbin:/bin',
      }
    }
  } else {
    if $facts['ss_nessus_agent_connected'] {
      exec { 'ss_nessus_agent_unlink_agent':
        command => "/opt/nessus_agent/sbin/nessuscli agent unlink",
        path    => '/usr/bin:/usr/sbin:/bin',
      }
    }
    if $facts['ss_nessus_agent_running'] {
      exec { 'ss_nessus_agent_stop_agent':
        command => "sudo -u root systemctl stop nessusagent",
        path    => '/usr/bin:/usr/sbin:/bin',
      }
    }
  }
}
