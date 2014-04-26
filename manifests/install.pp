# install the puppet package (private)
class puppet::install {

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
  if $puppet::facter =~ /^(latest|installed|present|absent|purged)$/ {
    apt::pin { 'pin_facter_version': ensure => absent }
  } else {
    apt::pin { 'pin_facter_version':
      packages => 'facter',
      version  => $puppet::facter,
      priority => '1001',
    }
  }

  if $puppet::hiera =~ /^(latest|installed|present|absent|purged)$/ {
    apt::pin { 'pin_hiera_version': ensure => absent }
  } else {
    apt::pin { 'pin_hiera_version':
      packages => 'hiera',
      version  => $puppet::hiera,
      priority => '1001',
    }
  }

  if $puppet::version =~ /^(latest|installed|present|absent|purged)$/ {
    apt::pin { 'pin_puppet_version': ensure => absent }
  } else {
    apt::pin { 'pin_puppet_version':
      packages => 'puppet puppet-common',
      version  => $puppet::version,
      priority => '1001',
    }
  }

  # install required package
  package { 'facter':
    ensure  => $puppet::facter,
    require => Apt::Pin['pin_facter_version'],
  }
  package { 'hiera':
    ensure  => $puppet::hiera,
    require => [ Package['facter'],
                  Apt::Pin['pin_puppet_version'] ],
  }
  package { 'puppet':
    ensure  => $puppet::version,
    name    => 'puppet',
    require => [ Package['hiera'],
                  Apt::Pin['pin_puppet_version'] ],
  }

}
