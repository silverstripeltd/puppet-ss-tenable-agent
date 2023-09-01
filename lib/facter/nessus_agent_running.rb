Facter.add("ss_nessus_agent_running") do
    setcode do
        if ! File.exists? "/opt/ss_nessus_agent/sbin/nessuscli"
            ss_nessus_agent_running = false
          else
           runningStatus = Facter::Util::Resolution.exec('/opt/ss_nessus_agent/sbin/nessuscli agent status | grep "Running"')
              if runningStatus.match('Running:')
                  line_parts = runningStatus.split(/(?<=:\s)([^\s]+)/)
                  if line_parts[1] == "Yes" 
                      ss_nessus_agent_running = true
                  else
                      ss_nessus_agent_running = false
                  end
              end
          end
      end
  end
