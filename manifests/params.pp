# set flavor specific variables (private)
class puppet::params {

  case $::osfamily {
    'Debian': {
    }
#    'RedHat': {
#      $client_package = 'puppet'
#    }
    default:  {
      fail("Module ${module_name} is not supported on ${::operatingsystem}/${::osfamily}")
    }
  }
}
