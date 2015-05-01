#
# Cookbook Name:: yum-vmware-tools
# Recipe:: default
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

# ISSUE #2 - attribute load ordering
node.default['yum']['vmware']['force_official'] = false

package 'dmidecode' do
  notifies :reload, 'ohai[ohai_reload]', :immediately
end

ohai 'ohai_reload' do
  action :nothing
end

return unless node['yum']['vmware']['enabled']

if node['platform_version'].to_i == 5 || node['yum']['vmware']['force_official']
  yum_repository 'vmware-tools' do
    description 'VMware Tools'
    baseurl node['yum']['vmware']['baseurl']
    gpgkey node['yum']['vmware']['gpgkey']
    action :create
  end
else
  include_recipe 'yum-epel'
end

node['yum']['vmware']['packages'].each do |vmware_pkg|
  package vmware_pkg
end

node['yum']['vmware']['services'].each do |vmware_svc|
  service vmware_svc do
    provider Chef::Provider::Service::Upstart if node['platform_version'].to_i == 6 && node['yum']['vmware']['force_official']
    action [:enable, :start]
  end
end
