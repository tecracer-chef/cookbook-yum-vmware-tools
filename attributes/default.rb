#
# Cookbook Name:: yum-vmware-tools
# Attributes:: default
#
# Copyright 2010, Eric G. Wolfe
# Copyright 2010, Tippr Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['yum']['vmware']['version'] = 'latest'

if node['dmi'] && node['dmi']['system'] &&
   node['dmi']['system']['manufacturer'] &&
   node['dmi']['system']['manufacturer'] =~ /vmware/i
  default['yum']['vmware']['enabled'] = true
else
  default['yum']['vmware']['enabled'] = false
end

default['yum']['vmware']['baseurl'] = "http://packages.vmware.com/tools/esx/#{node['yum']['vmware']['version']}/rhel#{node['platform_version'].to_i}/$basearch"
default['yum']['vmware']['gpgkey'] = 'http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub'

if node['platform_version'].to_i == 5 || node['yum']['vmware']['force_official']
  default['yum']['vmware']['packages'] = %w(
    vmware-tools-esx
    vmware-tools-esx-kmods
  )

  default['yum']['vmware']['services'] = %w(
    vmware-tools-services  )
elsif node['platform_version'].to_i >= 6
  default['yum']['vmware']['packages'] = %w(
    open-vm-tools  )

  default['yum']['vmware']['services'] = %w(
    vmtoolsd  )
end
