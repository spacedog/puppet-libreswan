# == Class libreswan::service
#
# This class is meant to be called from libreswan.
# It ensure the service is running.
#
# === Parameters
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
# === Dependencies
#
# puppetlabs/stdin
# puppetlabs/concat
#
# === Authors
#
# Anton Baranov <abaranov@linux.com>
#
class libreswan::service (
  String $service_name,
  Variant[Boolean, Enum['stopped', 'running']]
    $service_ensure,
  Variant[Boolean, Enum['manual','mask']]
    $service_enable,
){

  service { $service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
