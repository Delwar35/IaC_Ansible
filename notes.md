# Ansible notes

## Vagrant file for controller, db and web VM

```
# -*- mode: ruby -*-
 # vi: set ft=ruby :

 # MULTI SERVER/VMs environment 
 #
 Vagrant.configure("2") do |config|
    # creating are Ansible controller
      config.vm.define "controller" do |controller|
        
       controller.vm.box = "bento/ubuntu-18.04"
       
       controller.vm.hostname = 'controller'
       
       controller.vm.network :private_network, ip: "192.168.33.12"
       
       # config.hostsupdater.aliases = ["development.controller"] 
       
      end 
    # creating first VM called web  
      config.vm.define "web" do |web|
        
        web.vm.box = "bento/ubuntu-18.04"
       # downloading ubuntu 18.04 image
    
        web.vm.hostname = 'web'
        # assigning host name to the VM
        
        web.vm.network :private_network, ip: "192.168.33.10"
        #   assigning private IP
        
        #config.hostsupdater.aliases = ["development.web"]
        # creating a link called development.web so we can access web page with this link instread of an IP   
            
      end
      
    # creating second VM called db
      config.vm.define "db" do |db|
        
        db.vm.box = "bento/ubuntu-18.04"
        
        db.vm.hostname = 'db'
        
        db.vm.network :private_network, ip: "192.168.33.11"
        
        #config.hostsupdater.aliases = ["development.db"]     
      end
    
    
    end
```
## Diagrams
### Overview

![image](https://user-images.githubusercontent.com/94615905/148100341-c588bb69-f950-4a06-9402-6182163585b5.png)

### Ansible

![image](https://user-images.githubusercontent.com/94615905/148101479-73b9d5ec-9fa6-4a55-8e4c-41469ba10639.png)

## Lanching VM using Vagrant files
### Step 1: cd to where the vagrant file is.
### Step 2: run `Vagrant up`

> This will create 3 VM (Controller, db, web)

### Update and upgrade each VM
ssh into each VM and run the following commands

```
sudo apt-get update -y
sudo apt-get upgrade -y

```
> `vagrant ssh controller` to ssh into controller VM
> `vagrant ssh db` to ssh into db VM
> `vagrant ssh web` to ssh into web VM

## Setting up  Ansible controller
### Step 1: ssh into controller VM
### Step 2: install dependences  

```
sudo apt-get update
sudo apt-get install software-properties-common 
``` 

### Step 3: Install Ansible

```
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```

## ssh into web and db VM from controller
Web VM - `ssh vagrant@192.168.33.10`
Db VM - `ssh vagrant@192.168.33.10`
Password for both VM is `vagrant`
> Format `ssh vagrant@<IP of VM>`


## Creating host file controller VM

### Step 1: install tree

`sudo apt-get install tree -y`

### Step 2: cd to ansible

`cd /etc/ansible`

### Step 3: remove current hosts file and create new hosts file

- remove current host file -` rm -rf hosts`
- create host file - `sudo nano hosts`

### Step 4: add code to host file

> The host file will be used to connect the controller VM to other VM

```
# add ip address/s of your agent nodes (VM)
[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
[db]
192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
```
## Adhoc commands 

### Ping

- `ansible all -m ping` - pings all VM listed in hosts file
- `ansible web -m ping`- pings web VM
- `ansible db -m ping` - pings db wm

### VM information

- `ansible all -a "uname -a"` - give basic information for all VM listed in hosts file
- `ansible web -a "uname -a"` - give basic information for db VM 
- `ansible db -a "uname -a"` - give basic information for db VM 

> `ansible all -a "<command>"` will run <command> on all the VM in the hosts file

- `ansible db -a "ls -a"` shows all files of each VM in the home dir



