# Puppet Tenable Nessus agent

Install, configure and register Tenable's Nessus agent with service

## Agent

This will download and install the Nessus agent from specified URL.

Configuration is done via the `/opt/nessus_agent/sbin/nessuscli` CLI application installed when the agent package.

This will link the agent by running the commands:

``` sh
systemctl start nessusagent
/opt/nessus_agent/sbin/nessuscli agent link --key=<key> name=<environmentname> --cloud --proxy-host=<http_proxy_host> --proxy-port=<http_proxy_port>
```

Once registered and enabled the secret (passphrase) is required to reconfigure and in particular disable/ stop the client. This is only visible via the web interface.

This will link the agent with the Tenable Cloud, and can be configured through the UI to have scans run on it. 

Once the agent is installed, setup and enabled, you can link/start and unlink/stop the agent via puppet, by setting the `nessus_agent_enabled` parameter to true/false.