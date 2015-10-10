# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  config.vm.box = "hansode/fedora-21-server-x86_64"
  config.vm.hostname = "go-server"
  config.vm.network "forwarded_port", guest: 8153, host: 8153
  config.vm.network "private_network", ip: "192.168.33.10", bridge: "eno1"
  config.vm.provision "shell", path: "bootstrap.sh"
  config.vm.provider :virtualbox do |vb|
 	vb.customize ["modifyvm", :id, "--name", "go-server"]
  end
end
