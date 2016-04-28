# == Define: libreswan::secrets
#
# Manages secrets for ipsec connections
#
# === Parameters
#
# [*ensure*] 
#   The state of the connection secret file
#   
#   Type: Variant[Boolean, Enum['present','absent']] 
#   Default: Present
#
# [*secret*] 
#   The secret for ipsec connection
#   
#   Type:  Variant[String,Hash] 
#
# [*id*]
#   The connection id to identify the secret is for 
#   
#   Type: Optional[String]
#
# [*type*]
#   The secret type
#   
#   Type: Enum['PSK','XAUTH','RSA'] 
#   Default: PSK
#
# [*options*]
#   The Hash of ipsec connection options
#   
#   Type: hash
#
# === Authors
#
# Anton Baranov <abaranov@linux.com>
define libreswan::secret (
  Variant[String,Hash] $secret,
  Optional[String]     $id = undef,
  Variant[Boolean, Enum['present','absent']]
    $ensure = 'present',
  Enum['PSK','XAUTH','RSA']
    $type = 'PSK',
) {

  include ::libreswan

  file { "${::libreswan::configdir}/${title}.secret":
    ensure    => $ensure,
    owner     => 'root',
    group     => 'root',
    mode      => '0400',
    show_diff => false,
    content   => template("${module_name}/ipsec.secret.erb"),
  }


}
