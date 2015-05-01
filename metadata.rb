maintainer 'Eric G. Wolfe'
maintainer_email 'wolfe21@marshall.edu'
license 'Apache 2.0'
description 'Installs and configures VMWare yum repositories.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.1.1'
depends 'yum'
depends 'yum-epel'
name 'yum-vmware-tools'

%w(redhat centos scientific amazon oracle).each do |os|
  supports os, '>= 5.0'
end
