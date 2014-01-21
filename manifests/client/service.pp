# mange the puppet service (private)
class puppet::client::service {

  if str2bool($puppet::client::service_manage) {

    case $puppet::client::service_ensure {
      /(?i)(running|true)/ : {  $ensure  = true
                                $default = 'yes' }
      /(?i)(stopped|false)/: {  $ensure  = false
                                $default = 'no' }
      default: { fail('Value of puppet::service_ensure can must be true/false/running/stopped') }
      }

    ini_setting { 'default: start puppet agent':
      path    => '/etc/default/puppet',
      section => '',
      setting => 'START',
      value   => $default,
      notify  => Service['puppet-agent'],
    }

    service { 'puppet-agent':
      ensure     => $ensure,
      name       => $puppet::client::service_name,
      enable     => $ensure,
      hasrestart => true,
      hasstatus  => true,
    }
  }
}

