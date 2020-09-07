Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  
Vagrant::Config.run do |config|
  config.vbguest.auto_update = true
end

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
  config.vm.provision "shell", path: "install-docker.sh"
  #config.vm.provision "shell", path: "install-awscli.sh"
end