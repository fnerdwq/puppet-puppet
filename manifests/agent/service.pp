# mange the puppet service (private)
class puppet::agent::service {

  if str2bool($puppet::agent_enable) {
    $enable  = true
    $default = 'yes'
  } else {
    $enable  = false
    $default = 'no'
  }

  ini_setting { 'default: puppet':
    path    => '/etc/default/puppet',
    section => '',
    setting => 'START',
    value   => $default,
    notify  => Service[$puppet::agent_name],
  }

  service { $puppet::agent_name:
    ensure     => $enable,
    enable     => $enable,
    hasrestart => true,
    hasstatus  => true,
  }
}

