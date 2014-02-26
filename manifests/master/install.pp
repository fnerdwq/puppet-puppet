# installs the puppet master package (private)
class puppet::master::install {

  if $puppet::version == 'latest' {
    $version_puppet = latest
    apt::pin { 'pin_puppetmaster_version': ensure => absent }
  } else {
    $version_puppet = $puppet::version
    apt::pin { 'pin_puppetmaster_version':
      packages => 'puppetmaster puppetmaster-common puppetmaster-passenger',
      version  => $version_puppet,
      priority => '1001',
    }
  }

  if $puppet::passenger {
    package {'puppetmaster-passenger':
      ensure  => $version_puppet,
      require => Apt::Pin['pin_puppetmaster_version'],
    }

    package {'puppetmaster':
      ensure => absent,
    }
  } else {
    package {'puppetmaster':
      ensure  => $version_puppet,
      require => Apt::Pin['pin_puppetmaster_version'],
    }

    package {'puppetmaster-passenger':
      ensure => absent,
    }
  }

}
