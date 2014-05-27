# Set up puppet agent configuration files (private)
class puppet::agent::config {

  puppet::configsection {'agent':
    order  => 99,
    config => merge($puppet::params::agent_config,
                    $puppet::agent_config)
  }

}
