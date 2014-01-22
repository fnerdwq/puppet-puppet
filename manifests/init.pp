# == Class: puppet
#
# This class configures the the puppet agent and
# if chosen the puppetmaster.
# Further configuration options see the special client and
# server classes.
#
# This works on Debian like systems.
# Puppet Version >= 3.4.0
#
# === Parameters
#
# [*manage_client*]
#   include the puppet::client class, default: true
#
# [*manage_server*]
#   include the puppet::server class, default: false
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
  $manage_client = true,
  $manage_server = false,
) inherits puppet::params {

  $_manage_client = str2bool($manage_client)
  $_manage_server = str2bool($manage_server)

  if $_manage_client {
    include puppet::client
  }

#  if $_manage_server {
#    include puppet::server
#  }

}
