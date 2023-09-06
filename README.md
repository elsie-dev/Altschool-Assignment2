# VAGRANT PROJECT
DEveloping a Bash Script for automated deployment


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
