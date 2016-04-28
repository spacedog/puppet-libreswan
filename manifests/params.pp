# == Class libreswan::params
#
# This class is meant to be called from libreswan.
# It sets variables according to platform.
#
class libreswan::params {
  # Default variables  
  $ensure          = 'present'
  $package_ensure  = 'installed'
  $service_ensure  = 'running'
  $service_enable  = true
  $ipsec_config    = {}
  # OS Specific variables
  case $::osfamily {
    'Debian': {
      $package_name   = 'libreswan'
      $service_name   = 'ipsec'
      $config         = '/etc/ipsec.conf'
      $configdir      = '/etc/ipsec.d'
      $config_secrets = '/etc/ipsec.secrets'
    }
    'RedHat', 'Amazon': {
      $package_name   = 'libreswan'
      $service_name   = 'ipsec'
      $config         = '/etc/ipsec.conf'
      $configdir      = '/etc/ipsec.d'
      $config_secrets = '/etc/ipsec.secrets'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

}
