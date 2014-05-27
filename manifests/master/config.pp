# Set up puppet master configuration files (private)
class puppet::master::config {

  # if passenger is configured, add essential master parameters
  if $puppet::passenger {
    # These are needed when the puppetmaster is run by passenger
    # and can safely be removed if webrick is used.
    $passenger_master_config = {
      'ssl_client_header'        => 'SSL_CLIENT_S_DN',
      'ssl_client_verify_header' => 'SSL_CLIENT_VERIFY',
    }
  } else {
    $passenger_master_config = {}
  }

  puppet::configsection {'master':
    order  => 10,
    config => merge($puppet::params::master_config,
                    $passenger_master_config,
                    $puppet::master_config)
  }

  $inventory       = $puppet::inventory
  $inventory_allow = $puppet::inventory_allow
  file {"${puppet::params::config_dir}/auth.conf":
    ensure  => present,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/auth.conf.erb'),
  }

  $fileserver = $puppet::fileserver
  file {"${puppet::params::config_dir}/fileserver.conf":
    ensure  => present,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/fileserver.conf.erb'),
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

  # create environment directory
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
  file {'/etc/hiera.yaml':
    ensure  => link,
    target  => "${puppet::params::config_dir}/hiera.yaml",
    require => File["${puppet::params::config_dir}/hiera.yaml"],
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
