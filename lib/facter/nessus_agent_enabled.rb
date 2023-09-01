Facter.add("ss_nessus_agent_connected") do
    setcode do
      if ! File.exists? "/opt/ss_nessus_agent/sbin/nessuscli"
        ss_nessus_agent_connected = false
        else
            linkStatus = Facter::Util::Resolution.exec('/opt/ss_nessus_agent/sbin/nessuscli agent status | grep "Link status"')
            if linkStatus.match('Link status:')
                line_parts = linkStatus.split(/(?<=:\s)([^\s]+)/)
                if line_parts[1] == "Connected" 
                    ss_nessus_agent_connected = true
                else
                    ss_nessus_agent_connected = false
                end
            end
        end
    end
end