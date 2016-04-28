# Class: libreswan
# ===========================
#
# Full description of class libreswan here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class libreswan (
  Variant[Boolean, Enum['present','absent']]
    $ensure                       = $::libreswan::params::ensure,
  String         $package_name    = $::libreswan::params::package_name,
  Variant[Boolean, Enum['installed', 'latest']]
    $package_ensure               = $::libreswan::params::package_ensure,
  String         $service_name    = $::libreswan::params::service_name,
  Variant[Boolean, Enum['stopped', 'running']]
    $service_ensure               = $::libreswan::params::service_ensure,
  Variant[Boolean, Enum['manual','mask']]
    $service_enable               = $::libreswan::params::service_enable,
  Pattern['^\/'] $config          = $::libreswan::params::config,
  Pattern['^\/'] $configdir       = $::libreswan::params::configdir,
  Pattern['^\/'] $config_secrets  = $::libreswan::params::config_secrets,
  Hash           $ipsec_config    = $::libreswan::params::ipsec_config,
) inherits ::libreswan::params {

  class { '::libreswan::install':
    package_name   => $package_name,
    package_ensure => $package_ensure,
  }
  class { '::libreswan::config':
    ensure         => $ensure,
    ipsec_config   => $ipsec_config,
    config         => $config,
    configdir      => $configdir,
    config_secrets => $config_secrets,
  }
  class { '::libreswan::service':
    service_name   => $service_name,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }

  contain '::libreswan::install'
  contain '::libreswan::config'
  contain '::libreswan::service'

  Class['::libreswan::config'] ~> Class['::libreswan::service']
}
