#puppet-puppet

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What Puppet affects](#what-puppet-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with Puppet](#beginning-with-Puppet)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [TODOs](#Todos)

##Overview

This puppet module manages the puppet agent (server to come) on Debian like system. 

Written for Puppet >= 3.4.0.

##Module Description

See [Overview](#overview) for now.

##Setup

###What Puppet affects

* the puppet agent configuration :-) 

###Setup Requirements

Nothing special.
	
###Beginning with Ssh	

Simply include it.

##Usage

Just include the module by 

```puppet
include puppet
```

Configure it through hiera or declare it resource-like by calling the server/client class explicitly and set the parameters, e.g.:

```puppet
class { 'puppet::client':
  version = '3.4.2-1puppetlabs1',
}
```

##Limitations:

Debian like systems.
Tested on:

* Debian 7

Puppet Version >= 3.4.0, due to specific hiera usage.

## TODOs

* Extend to RedHat like systems
* Make more general version numbers possible (e.g. 3.4.2 instead of 3.4.2-1puppetlabs1), not that simple for Debian
* Introduce possibility to remove configuration entries (e.g. undef in config)
* hiera\_hash for \*\_config parameters?
* add config for [main] section
* provision with initial puppet.conf
