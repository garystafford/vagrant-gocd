INTERNET_INTERFACE = `
    route get 8.8.8.8 | grep interface | head -1 | awk -F' '  '{print $2}'
`.freeze

Vagrant.configure(2) do |config|
  config.vm.box = 'jhcook/fedora24'
  config.vm.hostname = 'go-server'
  config.vm.network 'forwarded_port', guest: 8153, host: 8153
  config.vm.network 'forwarded_port', guest: 8154, host: 8154
  config.vm.provision 'shell', path: 'bootstrap.sh'
  config.vm.provider :virtualbox do |vb|
    vb.name = 'go-server'
    vb.customize ['modifyvm', :id, '--name', 'go-server']
    vb.memory = 2048
  end
end
