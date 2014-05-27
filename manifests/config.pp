# general puppet config (private)
class puppet::config {

  file {$puppet::params::config_dir:
    ensure       => directory,
    owner        => puppet,
    group        => puppet,
    mode         => '0640',
    recurse      => true,
    recurselimit => 1,
  }

  file {"${puppet::params::config_dir}/manifests":
    ensure      => directory,
    owner       => puppet,
    group       => puppet,
    mode        => '0750',
  }

  concat {$puppet::params::config_file:
    owner => puppet,
    group => puppet,
    mode  => '0644',
  }

  puppet::configsection { 'main':
    order  => 01,
    config => merge($puppet::params::main_config,
                    $puppet::main_config)
  }

}
