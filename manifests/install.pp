# == Class: libreswan::install
#
# Class is called from libreswan class to install
#
# === Parameters
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
# === Authors
#
# Anton Baranov <abaranov@linux.com>
class libreswan::install (
  Variant[Boolean, Enum['installed', 'latest']]
    $package_ensure,
  String $package_name,
){
  package { $package_name:
    ensure => $package_ensure,
  }
}
