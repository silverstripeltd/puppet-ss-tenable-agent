class ss_nessus_agent::agent inherits ::ss_nessus_agent {

  if $ss_nessus_agent::http_proxy {
      $proxy_environment = ["http_proxy=${ss_nessus_agent::http_proxy}", "https_proxy=${ss_nessus_agent::http_proxy}"]
  } else {
      $proxy_environment = []
  }

  exec { 'download':
    command     => "curl -s -f ${ss_nessus_agent::download_url} -o /usr/src/nessusagent",
    path        => '/usr/bin:/usr/sbin:/bin',
    onlyif      => "test ! -f /usr/src/nessusagent",
    environment => $proxy_environment,
  }
  -> package { 'nessusagent':
    ensure   => installed,
    provider => dpkg,
    source   => '/usr/src/nessusagent'
  }

  # The setup and configuration utilises the custom facts
  if defined?('$::ss_nessus_agent_puppet') {
      if !$facts['ss_nessus_agent_enabled'] && defined?('$::ss_nessus_agent_puppet'){
        -> exec { 'ss_nessus_agent_link_agent':
        command => "/opt/ss_nessus_agent/sbin/nessuscli agent link --key=${ss_nessus_agent::link_token} name=" . $facts['environmentname'] . " --cloud --proxy-host=gateway.cwp.govt.nz --proxy-port=${ss_nessus_agent::http_proxy}",
        path    => '/usr/bin:/usr/sbin:/bin',
        }
        -> exec { 'ss_nessus_agent_start_agent':
        command => "systemctl start nessusagent",
        path    => '/usr/bin:/usr/sbin:/bin',
        }
      }
      else {
        -> exec { 'ss_nessus_agent_stop_agent':
        command => "systemctl stop nessusagent",
        path    => '/usr/bin:/usr/sbin:/bin',
        }        
      }
  }
}
