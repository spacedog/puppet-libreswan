# == Class: libreswan
#
# Class manages libreswan config, install and ipsec connections and secrets
#
# === Parameters
#
# [*ensure*]
#   The state of the puppet resources whithin that module
#
#   Type: Variant[Boolean, Enum['present','absent']]
#   Default: present
#
# [*package_name*]
#   The name of the package that provides libreswan
#
#   Type: String
#   Default: libreswan
#
# [*package_ensure*]
#   The state of the libreswan package in the system
#
#   Type: Variant[Boolean, Enum['installed', 'latest']]
#   Default: installed
#
# [*service_name*]
#   The name of the service that provides ipsec
#
#   Type: String
#   Default: ipsec
#
# [*service_ensure*]
#   The state of the libreswan service in the system
#
#   Type: Variant[Boolean, Enum['stopped', 'running']]
#   Default: running
#
# [*service_enable*]
#   Define if the service is started during the boot process
#
#   Type: Variant[Boolean, Enum['manual','mask']]
#   Default: true
#
# [*manage_service*]
#   Define if puppet manages service for you
#
#   Type: Boolean
#   Default: true
#
# [*config*]
#   Absolute path to the ipsec.conf file
#
#   Type: Pattern['^\/']
#   Default: /etc/ipsec.conf
#
# [*configdir*]
#   Absolute path to the ipsec.d directory
#
#   Type: Pattern['^\/']
#   Default: /etc/ipsec.d
#
# [*config_secrets*]
#   Absolute path to the ipsec.secrets file
#
#   Type: Pattern['^\/']
#   Default: /etc/ipsec.secrets
#
# === Dependencies
#
# puppetlabs/stdin
# puppetlabs/concat
#
# === Authors
#
# Anton Baranov <abaranov@linux.com>
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
  Boolean        $manage_service  = $::libreswan::params::manage_service,
  Pattern['^\/'] $config          = $::libreswan::params::config,
  Pattern['^\/'] $configdir       = $::libreswan::params::configdir,
  Pattern['^\/'] $config_secrets  = $::libreswan::params::config_secrets,
  Boolean        $purge_configdir = $::libreswan::params::purge_configdir,
  Hash           $ipsec_config    = $::libreswan::params::ipsec_config,
) inherits ::libreswan::params {

  class { '::libreswan::install':
    package_name   => $package_name,
    package_ensure => $package_ensure,
  }
  class { '::libreswan::config':
    ensure          => $ensure,
    ipsec_config    => $ipsec_config,
    config          => $config,
    configdir       => $configdir,
    config_secrets  => $config_secrets,
    purge_configdir => $purge_configdir,
  }
  if $manage_service {
    class { '::libreswan::service':
      service_name   => $service_name,
      service_ensure => $service_ensure,
      service_enable => $service_enable,
      subscribe      => Class['::libreswan::config'],
    }
  }


  Class[::libreswan::install] -> Class[::libreswan::config]


}
