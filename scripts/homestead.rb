class Homestead
  def Homestead.configure(config, settings)
    # Configure The Box
    config.vm.box = "laravel/homestead"
    config.vm.hostname = "homestead"

    # Configure A Private Network IP
    config.vm.network :private_network, ip: "192.168.33.10"

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Configure Port Forwarding To The Box
    config.vm.network "forwarded_port", guest: 80, host: 8000
    config.vm.network "forwarded_port", guest: 3306, host: 33060
    config.vm.network "forwarded_port", guest: 5432, host: 54320

    # Generate An SSH Key For The Box
    config.vm.provision "shell" do |s|
      s.inline = "sudo -u vagrant ssh-keygen -f /home/vagrant/.ssh/id_rsa -t rsa -N ''"
    end

    # Configure The Public Key For SSH Access
    config.vm.provision "shell" do |s|
      s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
      s.args = [File.read(settings["key"])]
    end

    # Register All Of The Configured Shared Folders
    settings["folders"].each do |folder|
      config.vm.synced_folder folder["map"], folder["to"]
    end

    # Install All The Configured Nginx Sites
    settings["sites"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/serve.sh $1 $2"
          s.args = [site["map"], site["to"]]
      end
    end
  end
end