# Set up puppet master configuration files (private)
class puppet::master::config {

  $configurations = prefix(
    join_keys_to_values($puppet::master_config, '='), 'master||')

  puppet::configfile { $configurations: }

  $inventory       = $puppet::inventory
  $inventory_allow = $puppet::inventory_allow

  file {"${puppet::params::config_dir}/auth.conf":
    ensure  => present,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/auth.conf.erb'),
  }

  if $puppet::passenger {

    # config.ru which fixes UTF-8 problem
    file {'/usr/share/puppet/rack/puppetmasterd/config.ru':
      ensure => present,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0644',
      source => 'puppet:///modules/puppet/config.ru',
    }

  }

  if $puppet::environments_dir {
    file {$puppet::environments_dir:
      ensure => directory,
      owner  => $puppet::environments_owner,
      group  => $puppet::environments_group,
      mode   => '0750',
    }
  }

  $hiera_datadir   = $puppet::hiera_datadir
  $hiera_hierarchy = $puppet::hiera_hierarchy
  file {"${puppet::params::config_dir}/hiera.yaml":
    ensure  => present,
    owner   => puppet,
    group   => puppet,
    content => template('puppet/hiera.yaml.erb'),
  }

  if str2bool($puppet::hiera_datadir_create) {

    validate_absolute_path($puppet::hiera_datadir)

    file {$puppet::hiera_datadir:
      ensure => directory,
      owner  => puppet,
      group  => puppet,
      mode   => '0750',
    }
  }

  $autosign_list =  $puppet::autosign_list
  file {"${puppet::params::config_dir}/autosign.conf":
    ensure  => present,
    owner   => puppet,
    group   => puppet,
    mode    => '0640',
    content => template('puppet/autosign.conf.erb'),
  }

}
