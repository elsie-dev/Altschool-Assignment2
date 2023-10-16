#!/bin/bash

# Determine the current directory
CURRENT_DIR=$(pwd)

# Bring up the VMs using Vagrant
vagrant up

# Get the IP address of the Slave node
slave_ip=$(vagrant ssh-config slave | grep HostName | awk '{print $2}')

# SSH into master node , create user altschool with sudo priviledges
vagrant ssh master -c '
 
  sudo adduser altschool
  sudo usermod -aG sudo altschool
  echo "altschool ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/altschool

  exit
'

#SSH into slave node to allow passwod authentication in SSH

  vagrant ssh server2 
  sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

  # Restart the SSH service
  sudo systemctl restart sshd

  # Exit the SSH session
  exit
'

# SSH into server1 and copy SSH key to server2
vagrant ssh master -c "ssh-copy-id -i ~/.ssh/id_rsa altschool@$slave_ip"

# SSH into Slave node (server2) again and revert SSH configuration
vagrant ssh slave -c '
  # Revert SSH configuration to disable password authentication
  sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

  # Restart the SSH service
  sudo systemctl restart sshd

  # Exit the SSH session
  logout
'

# SSH into server1 and then SSH into altschool@server2
#vagrant ssh server1 -c "ssh altschool@$server2_ip"

# SSH into server1 as altschool user, create the destination directory, and copy the contents
vagrant ssh master -c "ssh altschool@$slave_ip 'mkdir -p /mnt/altschool/slave && scp -r /mnt/altschool/* /mnt/altschool/slave/'"


# Display an overview of Linux process on Master
vagrant ssh master -c 'ps aux'

# Create a PHP info file
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/test.php

Get IP address ofthe slave node
server2_ip=$(vagrant ssh-config slave | grep HostName | awk '{print $2}')

# Install LAMP stack on both nodes
vagrant ssh master -c '
  sudo apt-get update
  sudo apt-get install -y apache2 mysql-server php libapache2-mod-php
  sudo systemctl enable apache2
  sudo systemctl start apache2
  sudo mysql_secure_installation
  echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/test.php
  exit
'

vagrant ssh slave -c '
  sudo apt-get update
  sudo apt-get install -y apache2 mysql-server php libapache2-mod-php
  sudo systemctl enable apache2
  sudo systemctl start apache2
  sudo mysql_secure_installation
  exit
'
