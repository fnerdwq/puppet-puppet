# Set up an puppet environment configuration (private)
define puppet::environment::config {

  $environment_config = $puppet::environments_config[$name]

  puppet::configsection {$name:
    config => $environment_config
  }

}
