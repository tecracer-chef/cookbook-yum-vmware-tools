yum-vmware-tools Cookbook
=========================

[![Build Status](https://secure.travis-ci.org/atomic-penguin/cookbook-yum-vmware-tools.png?branch=master)](http://travis-ci.org/atomic-penguin/cookbook-yum-vmware-tools)

Installs vmware-tools for EL 5, from packages.vmware.com.

For EL 6, installs open-vm-tools by default, from EPEL.

An undo recipe is included to remove, and cleanup, older vmware-tools installations.

Requirements
------------

* RHEL platform family, version 5 or 6. 
* VMWare guest.

#### packages

- `dmidecode` - needs dmidecode to inspect BIOS, and determine VMWare virtual hardware.

Attributes
----------

#### yum-vmware-tools::default

These are the attributes you may need to override in a role.

* `yum['vmware']['version']` - VMWare Tool release string, used to compute baseurl.
  - Default, 'latest'

* `yum['vmware']['force_official']` - Force official VMWare packages to be used as the yum source on EL6.
     Opposed to using open-vm-tools sourced from EPEL.
  - Default, false, uses open-vm-tools from EPEL.

These are attributes you should probably leave alone.

* `yum['vmware']['enabled']` - Boolean flag, computed by presence of VMWare virtual hardware.
  - Default, true when `dmi['system']['manufacturer']` is `'VMWare Inc.'`, false on other hardware.

* `yum['vmware']['baseurl']` - Base URL, to use in the vmware-tools.repo file.
  - Default, computed by `yum['vmware']['version']` and `node['platform_version']`.

* `yum['vmware']['gpgkey']` - URL of VMWare packaging key

* `yum['vmware']['packages']` - List of packages to install
  - EL5 default, [ vmware-tools-esx, vmware-tools-esx-kmods ]
  - EL6 default, [ open-vm-tools ]

* `yum['vmware']['services']` - Service script(s) to enable, and start
  - EL5 default, [ vmware-tools-services ]
  - EL6 default, [ vmtoolsd ]

Usage
-----

#### yum-vmware-tools::default

Example, force official repository on Enterprise Linux 6.x

```
default_attributes(
  :yum => {
    :vmware => {
      :force_official => false
    } 
  }
),
run_list: [ "recipe[yum-vmware-tools]" ]
```

#### yum-vmware-tools::undo

Example, remove older vmware-tools installation.

```
run_list: [ "recipe[yum-vmware-tools::undo]" ]
```

License and Authors
-------------------

Author:: Eric G. Wolfe <eric.wolfe@gmail.com> [![endorse](https://api.coderwall.com/atomic-penguin/endorsecount.png)](https://coderwall.com/atomic-penguin)
Copyright:: 2010-2011

Author:: Tippr, Inc.
Copyright:: 2010

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
