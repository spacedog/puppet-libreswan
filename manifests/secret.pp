define libreswan::secret (
  Variant[String,Hash] $secret,
  Optional[String]     $id = undef,
  Variant[Boolean, Enum['present','absent']]
    $ensure = 'present',
  Enum['PSK','XAUTH','RSA']
    $type = 'PSK',
) {

  if ! defined(Class['::libreswan']) {
    fail('Include libreswan class before using any libreswan defined resources')
  }

  file { "${::libreswan::configdir}/${title}.secret":
    ensure    => $ensure,
    owner     => 'root',
    group     => 'root',
    mode      => '0400',
    show_diff => false,
    content   => template("${module_name}/ipsec.secret.erb"),
  }


}
