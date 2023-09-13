class ss_nessus_agent (
  $link_token,
  $download_url,
  $environment_name = '',
  $nessus_agent_enabled = true,
  $http_proxy = '',
  $http_proxy_host = '',
  $http_proxy_port = '',
) {
  class { 'ss_nessus_agent::agent': }
}
