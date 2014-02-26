# mange the puppet service (private)
class puppet::master::service {

  if $puppet::passenger {

    service { $puppet::params::apache_service_name:
      ensure     => str2bool($puppet::master_enable),
      enable     => str2bool($puppet::master_enable),
      hasrestart => true,
      hasstatus  => true,
    }

  } else {
    if str2bool($puppet::master_enable) {
      $default = 'yes'
    } else {
      $default = 'no'
    }

    ini_setting { 'default: puppetmaster':
      path    => '/etc/default/puppetmaster',
      section => '',
      setting => 'START',
      value   => $default,
      notify  => Service[$puppet::master_name],
    }

    service { $puppet::master_name:
      ensure     => str2bool($puppet::master_enable),
      enable     => str2bool($puppet::master_enable),
      hasrestart => true,
      hasstatus  => true,
    }
  }
}

