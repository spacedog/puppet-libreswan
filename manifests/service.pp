# == Class libreswan::service
#
# This class is meant to be called from libreswan.
# It ensure the service is running.
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
