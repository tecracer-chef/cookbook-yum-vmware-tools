#!/usr/bin/env bats

@test "vmware-tools.repo or epel.repo exists" {
  test -f /etc/yum.repos.d/vmware-tools.repo || test -f /etc/yum.repos.d/epel.repo
}

@test "vmware-tools is installed" {
  rpm -q vmware-tools-esx || rpm -q open-vm-tools
}

@test "init script exists" {
  test -x /etc/init.d/vmware-tools-services || test -x /etc/init.d/vmtoolsd 
}
