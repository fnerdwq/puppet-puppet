# install the puppet client package (private)
class puppet::client::install {

  # such that no complaints about apt::update_timeout not beeing evaluated
  include apt

# TODO: OS Abhaengigkeit
  apt::source { 'puppetlabs':
    location   => 'http://apt.puppetlabs.com',
    repos      => 'main',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }

# TODO: change to *ed version for package to put only version names....
#  user custom facts 'available_versions'
  if $puppet::client::facter == 'latest' {
    $version_facter = latest
    apt::pin { 'pin_facter_version': ensure => absent }
  } else {
    $version_facter = $puppet::client::facter
    apt::pin { 'pin_facter_version':
      packages => 'facter',
      version  => $version_facter,
      priority => '1001',
    }
  }

  if $puppet::client::hiera == 'latest' {
    $version_hiera = latest
    apt::pin { 'pin_hiera_version': ensure => absent }
  } else {
    $version_hiera = $puppet::client::hiera
    apt::pin { 'pin_hiera_version':
      packages => 'hiera',
      version  => $version_hiera,
      priority => '1001',
    }
  }

  if $puppet::client::version == 'latest' {
    $version_puppet = latest
    apt::pin { 'pin_puppet_version': ensure => absent }
  } else {
    $version_puppet = $puppet::client::version
    apt::pin { 'pin_puppet_version':
      packages => 'puppet puppet-common',
      version  => $version_puppet,
      priority => '1001',
    }
  }

  # install required package
  package { 'facter':
    ensure  => $version_facter,
    require => Apt::Pin['pin_facter_version'],
  }
  package { 'hiera':
    ensure  => $version_hiera,
    require => [ Package['facter'],
                  Apt::Pin['pin_puppet_version'] ],
  }
  package { 'puppet-client':
    ensure  => $version_puppet,
    name    => 'puppet',
    require => [ Package['hiera'],
                  Apt::Pin['pin_puppet_version'] ],
  }

}
