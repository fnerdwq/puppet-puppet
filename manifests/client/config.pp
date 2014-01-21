# Set up puppet client configuration files (private)
class puppet::client::config {

  $configurations = join_keys_to_values($puppet::client::config, '=')

  notice $configurations

  puppet::configfile { $configurations:
    section   => 'agent',
  }

}
