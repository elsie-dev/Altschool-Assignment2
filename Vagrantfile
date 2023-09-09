# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/focal64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessable to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "1024"
     vb.cpus = "2"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
   #config.vm.provision "shell", inline: <<-SHELL
     #apt-get update
     #apt-get install -y apache2
  #SHELL
  config.vm.define "server1" do |subconfig|
    subconfig.vm.hostname = "server1"
    subconfig.vm.network :private_network, type: "dhcp"
  
    subconfig.vm.provision "shell", inline: <<-SHELL
      # Update package list and install Apache, MySQL, and PHP
      sudo apt-get update
      sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql
      #Ensure APache runs on boot
      sudo systemctl enable apache2
      sudo systemctl start apache2

     # Secure MYSQL installation and initialize
      sudo mysql_secure_installation <<EOF

    #Answering Y for the requirements 
      y
      y
      y
      y
      y

      # Set a default MySQL user and password (Change these values as needed)
      mysql -u root -p -e "CREATE USER 'your_username'@'localhost' IDENTIFIED BY 'your_password';"
      mysql -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO 'your_username'@'localhost' WITH GRANT OPTION;"
      mysql -u root -p -e "FLUSH PRIVILEGES;"
      EOF
   SHELL 
 end


  config.vm.define "server2" do |subconfig|
    subconfig.vm.hostname = "server2"
    subconfig.vm.network :private_network, type: "dhcp"

    subconfig.vm.provision "shell", inline: <<-SHELL

    # install Apache, MySQL and PHP on server2
    sudo apt-get update
    sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql
    sudo systemctl enable apache2
    sudo systemctl start apache2

    #Secure MySQL installation,initialize and setting user and password
    sudo mysql_secure_installation <<EOF
    y
    y
    y
    y
    y
    mysql -u root -p -e "CREATE USER 'your_username'@'localhost' IDENTIFIED BY 'your_password';"
    mysql -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO 'your_username'@'localhost' WITH GRANT OPTION;"
    mysql -u root -p -e "FLUSH PRIVILEGES;"
    EOF
  SHELL
    
  end

  # Allows the different nodes have different ip addresses
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get -y install net-tools 
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get install -y avahi-daemon libnss-mdns
  SHELL

end 
