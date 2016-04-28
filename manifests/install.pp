# == Class libreswan::install
#
# This class is called from libreswan for install.
#
class libreswan::install (
  Variant[Boolean, Enum['installed', 'latest']]
    $package_ensure,
  String $package_name,
){
  package { $package_name:
    ensure => $package_ensure,
  }
}
