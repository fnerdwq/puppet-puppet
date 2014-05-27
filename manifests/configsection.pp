# change puppet configuration file section (private)
define puppet::configsection (
  $section  = $title,
  $order    = 50,
  $config   = {},
) {

  validate_hash($config)

  concat::fragment {"${puppet::params::config_file} - ${section}":
    target  => $puppet::params::config_file,
    order   => $order,
    content => template('puppet/puppet.conf.erb'),
  }

}

