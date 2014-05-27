# Fact: hieraversion
#
# Purpose: returns the version of the hiera installed.
#
# Resolution: Uses the Hiera.version method.
#
# Caveats:
#

Facter.add(:hieraversion) do
  setcode do
    require 'hiera/version'
    Hiera.version.to_s
  end
end
