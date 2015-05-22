# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

# --- this defines a box where eth0 is nat to internet
#     and eth1 is a static address specified below on the host-only network
#     with port 80 in the VM forwarded to port 8080 on the host
#
Vagrant.configure(2) do |config|

  # the base box came from https://github.com/holms/vagrant-jessie-box/releases/download/Jessie-v0.1/Debian-jessie-amd64-netboot.box
  # so do a 'vagrant box add <url_here> --name deb8' to save the base box first into your vagrant setup
  config.vm.box = "deb8"

  # forward localhost 8080 to 80 in the VM
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # eth1 is a static ip on the host-only network
  config.vm.network "private_network", ip: "192.168.56.8"

  # set the ram to a reasonable value
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
  end

  # run our provisioning script
  config.vm.provision :shell, path: "provision.sh"

end
