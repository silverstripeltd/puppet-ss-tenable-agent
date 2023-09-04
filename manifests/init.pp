class ss_nessus_agent (
  $link_token,
  $download_url,
  $http_proxy = '',
  $http_proxy_host = '',
  $http_proxy_port = '',
) {
  class { 'ss_nessus_agent::agent': }
}
