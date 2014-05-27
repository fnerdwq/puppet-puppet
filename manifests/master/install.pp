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

  # if deep(er) merge wanted for hiera >= 1.2.0
  if    versioncmp($::hieraversion, '1.2.0') > 0
    and $puppet::merge_behavior in ['deep','deeper'] {

    package {'deep_merge':
      ensure   => latest,
      provider => gem,
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
