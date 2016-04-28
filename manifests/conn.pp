# == Define: libreswan::conn
#
# Manages ipsec connections
#
# === Parameters
#
# [*ensure*] 
#   The state of the connection file
#   
#   Type: Variant[Boolean, Enum['present','absent']] 
#   Default: Present
#
# [*options*]
#   The Hash of ipsec connection options
#   
#   Type: hash
#
# === Authors
#
# Anton Baranov <abaranov@linux.com>
define libreswan::conn (
  Hash $options,
  Variant[Boolean, Enum['present','absent']]
    $ensure = 'present',
) {

  if ! defined(Class['::libreswan']) {
    fail('Include libreswan class before using any libreswan defined resources')
  }

  $_target = "${::libreswan::configdir}/${title}.conf"

  file { $_target:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => template("${module_name}/conn.conf.erb"),
  }
}
