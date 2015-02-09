#
# Cookbook Name:: vmware-tools
# Recipe:: undo
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

# List of current, and past packages to remove
vmware_packages = %w(
  vmware-tools-nox
  vmware-tools-common
  vmware-open-vm-tools-common
  vmware-open-vm-tools-nox
  vmware-open-vm-tools-kmod
  vmware-open-vm-tools-xorg-drv-display
  vmware-open-vm-tools-xorg-drv-mouse
  vmware-tools-esx
  vmware-tools-esx-nox
  open-vm-tools
)

# List of current, and past services to remove
vmware_services = %w(
  vmware-tools
  vmware-tools-services
  vmtoolsd
)

# Stop vmware-tools service
vmware_services.each do |vmsvc|
  service vmsvc do
    supports status: true, restart: true
    action [:disable, :stop]
    ignore_failure true
  end
end

# Remove optional packages
vmware_packages.each do |vmpkg|
  package vmpkg do
    action :remove
    ignore_failure true
  end
end

# Execute yum clean all
execute 'yum -y clean all' do
  action :nothing
end

# Remove yum repository file
yum_repository 'vmware-tools' do
  action :delete
  notifies :run, 'execute[yum -y clean all]', :immediately
end

ruby_block 'Removing yum-vwmare-tools::undo recipe' do
  block do
    node.run_list.remove('recipe[yum-vmware-tools::undo]')
  end
end
