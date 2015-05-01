require 'spec_helper'

describe 'yum-vmware-tools::default' do

  shared_examples 'Open vmtools' do
    it 'creates EPEL repository file' do
      expect(chef_run).to create_yum_repository('epel')
    end

    it 'installs open-vm-tools' do
      expect(chef_run).to install_package('open-vm-tools')
    end

    it 'start and enable vmtoolsd' do
      expect(chef_run).to start_service('vmtoolsd')
      expect(chef_run).to enable_service('vmtoolsd')
    end
  end

  shared_examples 'Official VMWare packages' do |version|
    it 'creates vmware-tools repository file' do
      expect(chef_run).to create_yum_repository('vmware-tools').with(baseurl: "http://packages.vmware.com/tools/esx/5.5latest/rhel#{version}/$basearch")
    end

    it 'installs vmware-tools-esx-kmods and vmware-tools-esx' do
      expect(chef_run).to install_package('vmware-tools-esx-kmods')
      expect(chef_run).to install_package('vmware-tools-esx')
    end

    it 'starts and enables vmware-tools-services' do
      expect(chef_run).to start_service('vmware-tools-services')
      expect(chef_run).to enable_service('vmware-tools-services')
    end 
  end

  context 'on Centos 6.4 x86_64' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']) do |node|
        node.automatic['dmi']['system']['manufacturer'] = 'VMWare Inc.'
        node.automatic['kernel']['machine'] = 'x86_64'
      end.converge(described_recipe)
    end
    it_behaves_like 'Open vmtools'
  end

  context 'on Centos 6.4 x86_64 with force_official' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']) do |node|
        node.automatic['dmi']['system']['manufacturer'] = 'VMWare Inc.'
        node.automatic['kernel']['machine'] = 'x86_64'
        node.override['yum']['vmware']['force_official'] = true
        node.override['yum']['vmware']['version'] = '5.5latest'
      end.converge(described_recipe)
    end
    it_behaves_like 'Official VMWare packages', 6
  end

  context 'on Centos 5.9 x86_64 with force_official' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: 5.9, step_into: ['yum_repository']) do |node|
        node.automatic['dmi']['system']['manufacturer'] = 'VMWare Inc.'
        node.automatic['kernel']['machine'] = 'x86_64'
        node.override['yum']['vmware']['version'] = '5.5latest'
      end.converge(described_recipe)
    end
    it_behaves_like 'Official VMWare packages', 5
  end
end
