# libreswan #
#### Table of Contents 

1. [Overview](#overview)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Reference](#reference)
5. [Limitations](#limitations)

## Overview

[![Build Status](https://travis-ci.org/spacedog/puppet-libreswan.svg?branch=master)](https://travis-ci.org/spacedog/puppet-libreswan)

Module installs, configures libreswan - a free software implementation of the most widely supported and standarized VPN protocol based on ("IPsec") and the Internet Key Exchange ("IKE").

## Setup

For a basic use just include libreswan class into the manifest:
```puppet
class { 'libreswan': } 
```


## Usage

To configure ipsec options (config setup seciton in ipsec.conf file) the
ipsec_config hash should be used:
```puppet
$ipsec_config = {
  <key>       => <value>,
}

class {'libreswan':
  ipsec_config => $ipsec_config,
}
```

To manage ipsec connection the libreswan::conn defined type should be used 
```yaml
libreswan::conns:
  snt:
    left: 10.11.11.1
    leftsubnet: 10.0.1.0/24
    leftnexthop: 172.16.55.66
    leftsourceip: 10.0.1.1
    right: 192.168.22.1
    rightsubnet: 10.0.2.0/24
    rightnexthop: 172.16.88.99
    rightsourceip: 10.0.2.1
    keyingtries: %forever
```
Then use create_resources function to create connection: 
```puppet
create_resources('libreswan::conn', $conns)
```

To manage ipsec secrets the libreswan::secret type is used:
```yaml
libreswan::secrets:
  'conn1':
    ensure: 'present'
    id: '10.0.0.1 192.168.0.1'
    type: 'PSK'
    secret: 'test'
  'conn2':
    ensure: 'present'
    type: RSA
    secret:
      PublicExponent: 0x03
      PrivateExponent: 0x316e6593...
      Prime1: 0x316e6593...
      Prime2: 0x316e6593...
      Exponent1: 0x316e6593...
      Exponent2: 0x316e6593...
      Coefficient: 0x316e6593...
      CKAIDNSS: 0x316e6593...
```
```puppet
create_resources('libreswan::secrets', $secrets)
```

## Reference

### `libreswan`

#### [*ensure*]
The state of the puppet resources whithin that module

Type: Variant[Boolean, Enum['present','absent']]

Default: present

####  [*package_name*]
The name of the package that provides libreswan

Type: String

Default: libreswan

#### [*package_ensure*]
The state of the libreswan package in the system

Type: Variant[Boolean, Enum['installed', 'latest']] 

Default: installed
 
#### [*service_name*]
The name of the service that provides ipsec

Type: String

Default: ipsec

#### [*service_ensure*]
The state of the libreswan service in the system

Type: Variant[Boolean, Enum['stopped', 'running']] 

Default: running
 
####  [*service_enable*]
Define if the service is started during the boot process

Type: Variant[Boolean, Enum['manual','mask']] 

Default: true

#### [*config*]
Absolute path to the ipsec.conf file

Type: Pattern['^\/']

Default: /etc/ipsec.conf

#### [*configdir*]
Absolute path to the ipsec.d directory

Type: Pattern['^\/']

Default: /etc/ipsec.d

#### [*config_secrets*]
Absolute path to the ipsec.secrets file

Type: Pattern['^\/']

Default: /etc/ipsec.secrets

#### [*purge_configdir*]
Remove or not all unmanaged files from configdur

Type: Boolean

Default: false

### `libreswan::conn`

#### [*ensure*] 
The state of the connection file

Type: Variant[Boolean, Enum['present','absent']] 

Default: Present

#### [*options*]
The Hash of ipsec connection options

Type: hash

### `libreswan::secret`

#### [*ensure*] 
The state of the connection secret file

Type: Variant[Boolean, Enum['present','absent']] 

Default: Present

#### [*secret*] 
The secret for ipsec connection

Type:  Variant[String,Hash] 

#### [*id*]
The connection id to identify the secret is for 

Type: Optional[String]

#### [*type*]
The secret type

Type: Enum['PSK','XAUTH','RSA'] 

Default: PSK

#### [*options*]
The Hash of ipsec connection options

Type: hash

## Limitations

Puppet4
