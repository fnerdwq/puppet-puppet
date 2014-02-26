# Set up puppet master configuration files (private)
class puppet::master::config {

  $configurations = prefix(
    join_keys_to_values($puppet::master_config, '='), 'master||')

  puppet::configfile { $configurations: }

  $inventory       = $puppet::inventory
  $inventory_allow = $puppet::inventory_allow

  file {'/etc/puppet/auth.conf':
    ensure  => present,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
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

}
