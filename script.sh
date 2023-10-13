y#!/bin/bash

# Determine the current directory
CURRENT_DIR=$(pwd)

# Bring up the VMs using Vagrant
vagrant up

# Get the IP address of the Slave node
server2_ip=$(vagrant ssh-config server2 | grep HostName | awk '{print $2}')

# SSH into master node , create user altschool with sudo priviledges
vagrant ssh server1 -c '
 
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
vagrant ssh server1 -c "ssh-copy-id -i ~/.ssh/id_rsa altschool@$server2_ip"

# SSH into Slave node (server2) again and revert SSH configuration
vagrant ssh server2 -c '
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
vagrant ssh server1 -c "ssh altschool@$server2_ip 'mkdir -p /mnt/altschool/slave && scp -r /mnt/altschool/* /mnt/altschool/slave/'"


# Display an overview of Linux process on Master
vagrant ssh server1 -c 'ps aux'

# Create a PHP info file
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/test.php
