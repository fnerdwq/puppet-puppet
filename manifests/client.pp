# == Class: puppet::client
#
# Configures the puppet agent.
#
# [*facter*]
#   see puppet::facter
#
# [*hiera*]
#   see puppet::hiera
#
# [*version*]
#   see puppet::version
#
# [*service_manage*]
#   should we care about managing the puppet agent service? default: true 
#
# [*service_name*]
#   the service name to manage, default: 'puppet'
#
# [*service_ensure*]
#   should the service be running or not, default: true 
#   possible: true/false/running/stopped
#
# [*config*]
#   a hash with key values for the [agent] section of puppet.conf, ad default
#   'pluginsync' => 'true' and 'server' => host puppet in current $::domain
#
# === Examples
#
# class { 'puppet::client':
#   version => '3.4.2-1puppetlabs1'    
# }
#
# === Authors
#
# Frederik Wagner <wagner@wagit.de>
#
# === Copyright
#
# Copyright 2014 Frederik Wagner
#
class puppet::client (
  $facter         = hiera('puppet::facter',  'latest'),
  $hiera          = hiera('puppet::hiera',   'latest'),
  $version        = hiera('puppet::version', 'latest'),
  $service_manage = true,
  $service_name   = 'puppet',
  $service_ensure = true,
  $config         = { 'pluginsync' => 'true',
                      'server'     => "puppet.${::domain}" }
) {
# TODO: for config other merge lookup?

# only for os check
  include puppet::params

  validate_string($facter)
  validate_string($hiera)
  validate_string($version)
  validate_bool(str2bool($service_manage))
  validate_string($service_name)
  # implicit validation of $service_ensure in puppet::config::service
  validate_hash($config)

  class { 'puppet::client::install': }
  -> class { 'puppet::client::config': }
  ~> class { 'puppet::client::service': }

}
