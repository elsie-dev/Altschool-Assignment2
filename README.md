# VAGRANT PROJECT
Develop a bash script to orchestrate the automated deployment of two Vagrant-based Ubuntu systems, 
designated as 'Master' and 'Slave', 

## Objectives:
  - [x] A bash script encapsulating the entire deployment process adhering to the specifications mentioned above.
  - [x] Documentation accompanying the script, elucidating the steps and procedures for execution.
  - A test PHP page validating the LAMP setup on both nodes 
  - A Load balancer using nginx to allow for traffic to the LAMP using the master and the slave nodes.
    
## Requirements:
Oracle Virtual Machine Installed
Vagrant Installed

STEPS:
1. Make a directory and cd into that directory
2. Run Vagrant init command to generate a Vagrantfile
     - Since its a multi creation of both slave and master. All these are added to the same file.
     - Ensure the ip address of both the slave and master are different (run ipconfig command to confirm in each server)
4.  Create a Bash script that will automate the process

**Vagrantfile** - This file contains multinode setup with two nodes master and slave. 
I configured both in the same file.
I added __private_network__ configuration in the DHCP which assigns different ip addresses.

Also included: LAMP Setup in the Vagrantfile instead of the Bash script to avoid complexity.


In the bash script l included a final step to generate a PHP test file to validate PHP functionality. 
The command l used in the bash scipt :

```
# Create a PHP test file
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/test.php
```

## Issues experienced: Troubleshooting 

 **SSH Permission Denied** - Turns out by default if you try to authenticate it fails if password authentication is not enabled on the server node 
 **Solution:** - SSH into server B and allow password 
 
 ```
vagrant ssh slave
sudo nano /etc/ssh/ssh_config
password authentication to be changed from no to yes
sudo systemctl restart ssh
```

Then copy the key from master using ```ssh-copy-id -i vagrant@ipaddressofslave```

## SETTING UP THE SAME PROJECT WITH ANSIBLE
Created a folder **Ansible** for configuation management

1. Created a virtual environment and activated it 
```
python -m venv myenv
source myenv/bin/activate
```

2. The playbook.yml contains tasks from the assignment setting up master and slave nodes

3. Ansible_hosts file contains the ip addresses

To run the playbook:
``` ansible-playbook -i playbook.yml```
