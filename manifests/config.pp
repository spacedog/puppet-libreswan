# == Class: libreswan::config
#
# Class is called from libreswan class to configure ipsec
#
# === Parameters
#
# [*ipsec_config*]
#   The Hash of configs for ipsec config section.
#
#   Type: Hash
#   Default: {}
# [*ensure*]
#   The state of the puppet resources whithin that module
#
#   Type: Variant[Boolean, Enum['present','absent']]
#   Default: present
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
# [*purge_configdir*]
#   Remove or not all unmanaged files from configdur
#
#   Type: Boolean
#   Default: false
#
# === Dependencies
#
# puppetlabs/stdin
# puppetlabs/concat
#
# === Authors
#
# Anton Baranov <abaranov@linux.com>
# == Class libreswan::config
#
# This class is called from libreswan for service config.
#
class libreswan::config(
  Hash           $ipsec_config,
  Variant[Boolean, Enum['present','absent']]
    $ensure,
  Pattern['^\/'] $config,
  Pattern['^\/'] $configdir,
  Pattern['^\/'] $config_secrets,
  Boolean        $purge_configdir,
){
  # ipsec.conf
  concat {$config:
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  concat::fragment {"${config}_HEADER":
    target  => $config,
    content => '# File is managed by puppet\n',
    order   => '00',
  }

  concat::fragment {"${config}_setup":
    target  => $config,
    content => template("${module_name}/ipsec.conf_setup.erb"),
    order   => '01',
  }
  # Make sure to include /etc/ipsec.d/*.conf
  concat::fragment {"${config}_FOOTER":
    target  => $config,
    content => "include ${configdir}/*.conf\n",
    order   => '99',
  }
  # ipsec.secrets
  file {$config_secrets:
    ensure  => $ensure,
    mode    => '0400',
    owner   => 'root',
    group   => 'root',
    content => "include ${configdir}/*.secret\n",
  }

  # ipsec.d
  case $ensure {
    true,'present': {
      $_densure = 'directory'
    }
    default: {
      $_densure = 'absent'
    }

  }
  file { $configdir:
    ensure => $_densure,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
  if $purge_configdir == true {
    File[$configdir] {
      recurse      => true,
      purge        => true,
      recurselimit => 1,
    }
  }
}
