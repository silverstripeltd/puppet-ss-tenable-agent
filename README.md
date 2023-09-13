# Puppet Tenable Nessus agent

Install, configure and register Tenable's Nessus agent with service

## Agent

This will download and install the Nessus agent from specified URL.

Configuration is done via the `/opt/nessus_agent/sbin/nessuscli` CLI application installed, when the agent package has been installed.

This will link the agent by running the commands:

``` sh
systemctl start nessusagent
/opt/nessus_agent/sbin/nessuscli agent link --key=<key> name=<environmentname> --cloud --proxy-host=<http_proxy_host> --proxy-port=<http_proxy_port>
```

Once registered and enabled the secret (passphrase) is required to reconfigure and in particular disable/ stop the client. This is only visible via the web interface.

This will link the agent with the Tenable Cloud, and can be configured through the UI to have scans run on it. 

Once the agent is installed, setup and enabled, you can link/start and unlink/stop the agent via puppet, by setting the `nessus_agent_enabled` parameter to true/false.

## Parameters

`http_proxy`: Optional parameter, a string detailing the proxy host and port ie 'blah.co.nz:111' which if defined, will be added to the curl request to download the nessus agent package

`http_proxy_port`: Optional parameter, the port used by the proxy

`http_proxy_host`: Optional parameter, the host used by the proxy

`link_token`: A parameter which defines the key/token needed to link the nessus agent to tenable cloud

`download_url`: The URL to download the nessus agent package from

`nessus_agent_enabled` A parameter which if set (to true), will install, start, and link the agent to tenable cloud. If not set (or set to anything other than true), it will unlink/stop the agent (if it is currently running/linked)

`environment_name` Optional parameter, if defined will name the agent what is defined (in Tenable Cloud). If not defined, the name will defaulte to the name of the machine where you are installing the agent.