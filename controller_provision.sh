#!/bin/bash

# Dependences
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install software-properties-common

# Install Ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible

sudo apt-get install tree -y

rm -rf /etc/ansible/hosts
sudo cp /hosts_config/hosts  /etc/ansible/hosts
