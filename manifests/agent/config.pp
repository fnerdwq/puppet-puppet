# Set up puppet agent configuration files (private)
class puppet::agent::config {

  $configurations = prefix(
    join_keys_to_values($puppet::agent_config, '='), 'agent||')

  puppet::configfile { $configurations: }

}
