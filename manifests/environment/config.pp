# Set up an puppet environment configuration (private)
define puppet::environment::config {

  $environment_config = $puppet::environments_config[$name]

  $configurations = prefix(
    join_keys_to_values($environment_config, '='), "${name}||")

  puppet::configfile { $configurations: }

}
