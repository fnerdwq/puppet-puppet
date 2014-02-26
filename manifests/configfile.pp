# change puppet configuration settings (private)
# Define name/title must be in form 'section||key=value'
define puppet::configfile (
  $ensure   = present,
)
{
  $path    = '/etc/puppet/puppet.conf'

  # splitting of 'section'
  $split   = split($name, '\|\|')

  # splitting off 'setting' and 'value'
  $setting = split($split[1], '=')

  ini_setting { "puppet.conf/${split[0]}/${setting[0]}":
    ensure  => $ensure,
    path    => $path,
    section => $split[0],
    setting => $setting[0],
    value   => $setting[1],
  }
}

