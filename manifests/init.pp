# == Class: puppet
#
# This class configures the the puppet agent and
# if chosen the puppetmaster.
#
# This works on Debian like systems.
# Puppet Version >= 3.4.0
#
# === Parameters
#
# [*facter*]
#   Facter version to use, use complete debian version number.
#   *Optional* (defaults to latest)
#
# [*hiera*]
#   Hiera version to use, use complete debian version number.
#   *Optional* (defaults to latest)
#
# [*version*]
#   Puppet version to use, use complete debian version number.
#   *Optional* (defaults to latest)
#
# [*agent_name*]
#   Name of puppet agent service
#   *Optional* (defaults to puppet)
#
# [*agent_enable*]
#   Enable the puppet agent service
#   *Optional* (defaults to true)
#
# [*agent_config*]
#   a hash with key values for the [agent] section of puppet.conf
#   *Optional* (defaults to 'pluginsync' => 'true' and
#     'server' => host puppet in current $::domain)
#
# [*master*]
#   Configure the puppet master
#   *Optional* (defaults to false)
#
# [*master_name*]
#   Name of the puppet master service
#   *Optional* (defaults to puppetmaster)
#
# [*master_enable*]
#   Enable the puppet master service
#   *Optional* (defaults to true)
#
# [*master_config*]
#   a hash with key values for the [master] section of puppet.conf, see
#   *agent_config*.
#   *Optional* (defaults to {})
#
# [*passenger*]
#   Should the puppetmaster be run under apache passenger
#   *Optional* (defaults to true)
#
# [*inventory*]
#   enable inventory service in auth.conf
#   *Optional* (defaults to false)
#
# [*inventory_allow*]
#   which hosts can access inventory service
#   *Optional* (defaults to )
#
# [*environments_config*]
#   A hash of hashes for extra sections of puppet.conf.
#   The outter hash keys are the sections/environments, for the inner hashes
#   see *agent_config*.
#   *Optional* (defaults to )
#
# === Examples
#
# include puppet
#
# === Authors
#
# Frederik Wagner <wagner@wagit.de>
#
# === Copyright
#
# Copyright 2014 Frederik Wagner
#
class puppet (
  $facter              = 'latest',
  $hiera               = 'latest',
  $version             = 'latest',
  $agent_name          = 'puppet',
  $agent_enable        = true,
  $agent_config        = {'pluginsync' => 'true',
                          'server'     => "puppet.${::domain}"},
  $master              = false,
  $master_name         = 'puppetmaster',
  $master_enable       = true,
  $master_config       = {},
  $passenger           = true,
  $inventory           = false,
  $inventory_allow     = "dashboard.${::domain}",
  $environments_config = {},
) inherits puppet::params {

  validate_string($facter)
  validate_string($hiera)
  validate_string($version)
  validate_string($agent_name)
  validate_bool(str2bool($agent_enable))
  validate_hash($agent_config)
  validate_bool(str2bool($master))
  validate_string($master_name)
  validate_bool(str2bool($master_enable))
  validate_hash($master_config)
  validate_bool(str2bool($passenger))
  validate_bool(str2bool($inventory))
  validate_string($inventory_allow)
  validate_hash($environments_config)

  contain puppet::install
  contain puppet::agent::config
  contain puppet::agent::service

  Class['puppet::install']
  -> Class['puppet::agent::config']
  ~> Class['puppet::agent::service']

  if $master {
    contain puppet::master::install
    contain puppet::master::config
    contain puppet::master::service

    Class['puppet::install']
    -> Class['puppet::master::install']
    -> Class['puppet::master::config']
    ~> Class['puppet::master::service']

    if $environments_config {
      $environments = keys($environments_config)

      puppet::environment::config { $environments:
        notify => Class['puppet::master::service']
      }
    }
  }


}
