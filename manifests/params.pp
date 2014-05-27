# set flavor specific variables (private)
class puppet::params {
  # Variables
  $config_dir  = '/etc/puppet'
  $config_file = "${config_dir}/puppet.conf"

  # Module Parameter
  $facter               = 'latest'
  $hiera                = 'latest'
  $version              = 'latest'
  $main_config          = { 'logdir'   => '/var/log/puppet',
                            'vardir'   => '/var/lib/puppet',
                            'ssldir'   => '$vardir/ssl',
                            'rundir'   => '/var/run/puppet',
                            'factpath' => '$vardir/lib/facter'}
  $agent_name           = 'puppet'
  $agent_enable         = true
  $agent_config         = { 'pluginsync' => 'true',
                            'server'     => "puppet.${::domain}"}
  $master               = false
  $master_name          = 'puppetmaster'
  $master_enable        = true
  $master_config        = {}
  $passenger            = true
  $inventory            = false
  $inventory_allow      = "dashboard.${::domain}"
  $environments_config  = {}
  $environments_dir     = undef
  $environments_owner   = 'puppet'
  $environments_group   = 'puppet'
  $hiera_datadir        = "${config_dir}/hieradata"
  $hiera_datadir_create = true
  $hiera_hierarchy      = ['%{::clientcert}', 'common']
  $autosign_list        = []
  $fileserver           = {}

  # Further Variables
  case $::osfamily {
    'Debian': {
      $apache_service_name = 'apache2'
    }
#    'RedHat': {
#      $apache_service_name = 'httpd'
#    }
    default:  {
      fail("Module ${module_name} is not supported on ${::operatingsystem}/${::osfamily}")
    }
  }
}
