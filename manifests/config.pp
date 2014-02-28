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

}
