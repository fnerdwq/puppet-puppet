# set flavor specific variables (private)
class puppet::params {

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
