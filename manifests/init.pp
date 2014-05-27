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
# [*main_config*]
#   a hash with key values for the [main] section of puppet.conf
#   *Optional* (defaults to -> see params.pp)
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
# [*merge_behavior*]
#   For hiera > 1.2.0, the merge behavior for hiera_hash
#   *Optional* (defaults to native)
#
# [*inventory*]
#   enable inventory service in auth.conf
#   *Optional* (defaults to false)
#
# [*inventory_allow*]
#   which hosts can access inventory service
#   *Optional* (defaults to dashboard.$::domain)
#
# [*environments_config*]
#   A hash of hashes for extra sections of puppet.conf.
#   The outter hash keys are the sections/environments, for the inner hashes
#   see *agent_config*.
#   *Optional* (defaults to {})
#
# [*environments_dir*]
#   If set, create this directory to check out environments.
#   *Optional* (default to undef)
#
# [*environments_owner*]
#   Owner of the environements directory
#   *Optional* (defaults to puppet)
#
# [*environments_group*]
#   Group of the environments directory
#   *Optional* (defaults to pupppet)
#
# [*hiera_datadir*]
#   Datadir for the yaml hiera backend (only yaml for now!)
#   *Optional* (defaults to /etc/puppet/hieradata)
#
# [*hiera_datadir_create*]
#   Should we create the hiera datatdir?
#   *Optional* (defaults to true)
#
# [*hiera_hierarchy*]
#   Array of the hiera hierachy.
#   *Optional* (defaults to ['%{::clientcert}', 'common']
#
# [*autosign_list*]
#   Array of entries in autosing.conf
#   *Optional* (defaults to [])
#
# [*fileserver*]
#   Hash to describe fileserver.conf entries:
#   { 'mountpoint1' => {
#        comment => 'This is a comment',
#        path    => '/filsystem/path',
#        allow   => ['*.example.de','*.example.com']
#      },
#      ...
#   }
#   *Optional* (defaults to {})
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
  $facter               = $puppet::params::facter,
  $hiera                = $puppet::params::hiera,
  $version              = $puppet::params::version,
  $main_config          = {},
  $agent_name           = $puppet::params::agent_name,
  $agent_enable         = $puppet::params::agent_enable,
  $agent_config         = {},
  $master               = $puppet::params::master,
  $master_name          = $puppet::params::master_name,
  $master_enable        = $puppet::params::master_enable,
  $master_config        = {},
  $passenger            = $puppet::params::passenger,
  $merge_behavior       = $puppet::params::merge_behavior,
  $inventory            = $puppet::params::inventory,
  $inventory_allow      = $puppet::params::inventory_allow,
  $environments_config  = $puppet::params::environments_config,
  $environments_dir     = $puppet::params::environments_dir,
  $environments_owner   = $puppet::params::environments_owner,
  $environments_group   = $puppet::params::environments_group,
  $hiera_datadir        = $puppet::params::hiera_datadir,
  $hiera_datadir_create = $puppet::params::hiera_datadir_create,
  $hiera_hierarchy      = $puppet::params::hiera_hierarchy,
  $autosign_list        = $puppet::params::autosign_list,
  $fileserver           = $puppet::params::fileserver
) inherits puppet::params {
  validate_string($facter)
  validate_string($hiera)
  validate_string($version)
  validate_hash($main_config)
  validate_string($agent_name)
  validate_bool(str2bool($agent_enable))
  validate_hash($agent_config)
  validate_bool(str2bool($master))
  validate_string($master_name)
  validate_bool(str2bool($master_enable))
  validate_hash($master_config)
  validate_bool(str2bool($passenger))
  validate_re($merge_behavior,['^native$','^deep$','$^deeper$'])
  validate_bool(str2bool($inventory))
  validate_string($inventory_allow)
  validate_hash($environments_config)
  if $environments_dir {
    validate_absolute_path($environments_dir)
  }
  validate_string($environments_owner)
  validate_string($environments_group)
  validate_string($hiera_datadir)
  validate_bool(str2bool($hiera_datadir_create))
  validate_array($hiera_hierarchy)
  validate_array($autosign_list)
  validate_hash($fileserver)

  contain puppet::install
  contain puppet::config
  contain puppet::agent::config
  contain puppet::agent::service

  Class['puppet::install']
  -> Class['puppet::config']

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
