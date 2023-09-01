class ss_nessus_agent (
  $site_token,
  $download_url,
  $http_proxy = '',
) {
  class { 'ss_nessus_agent::agent': }
}
