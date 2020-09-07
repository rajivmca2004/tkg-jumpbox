Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  # Optional - enlarge disk (will also convert the format from VMDK to VDI):
  # config.disksize.size = "50GB"
  
Vagrant::Config.run do |config|
  # set auto_update to false, if do NOT want to check the correct additions
  # version when booting this machine
  config.vbguest.auto_update = true
end

  #config.vbguest.auto_update = true
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.name = "tkg_jumpbox"
    vb.gui = true
    vb.memory = 2048
    vb.cpus = 2
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
  end
  config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.provision "shell", inline: <<-SCRIPT
  #   echo "inline script"
  # SCRIPT


  config.vm.provision "shell", path: "install-desktop.sh"
  config.vm.provision "shell", path: "install-chrome.sh"
  #config.vm.provision "shell", path: "install-ide.sh"
  #config.vm.provision "shell", path: "install-java-eclipse.sh"

  config.vm.provision "shell", path: "install-docker.sh"
  #config.vm.provision "shell", path: "install-node.sh"
  #config.vm.provision "shell", path: "install-apache-php.sh"

  #config.vm.provision "file", source: "etc_mongod.conf.no-auth", destination: "/tmp/mongod.conf.no-auth"
  #config.vm.provision "file", source: "etc_mongod.conf.auth",    destination: "/tmp/mongod.conf.auth"
  #config.vm.provision "shell", path: "install-mongodb.sh"

  #config.vm.provision "shell", path: "install-mysql.sh"
  #config.vm.provision "shell", path: "install-memcached.sh"

  #config.vm.provision "shell", path: "install-awscli.sh"
end