#!/usr/bin/env bats

@test "vmware-tools.repo does not exist" {
  test ! -f /etc/yum.repos.d/vmware-tools.repo
}

@test "vmware-tools is not installed" {
  rpm -q vmware-tools-esx && rpm -q open-vm-tools
  [ $? == 1 ]
}

@test "init script does not exist" {
  test ! -x /etc/init.d/vmware-tools-services || test ! -x /etc/init.d/vmtoolsd 
}
