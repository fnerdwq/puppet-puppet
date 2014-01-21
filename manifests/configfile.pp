# change puppet configuration settings (private)
# Define name/title must be in form 'key=value'
define puppet::configfile (
  $section,
  $path     = '/etc/puppet/puppet.conf',
  $ensure   = present,
)
{
  $settings = split($name, '=')

  ini_setting { "${path}: [${section}] ${name}":
    ensure  => $ensure,
    path    => $path,
    section => $section,
    setting => $settings[0],
    value   => $settings[1],
  }
}

