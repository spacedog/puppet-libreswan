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
      $densure = 'absent'
    }

  }
  file { $configdir:
    ensure => $_densure,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
}
