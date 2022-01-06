# Ansible  playbook notes

## Creating a playbook to install nginx for web node

### Step 1: cd into `/etc/ansible`

### Step 2: Create a yaml file 

`sudo nano install_nginx.yml`

### Step 3: add code to yaml file

```
# This file is to configure and install nginx in web agent
---
# which host do we need to install nginx in
- hosts: web
  gather_facts: true

# what facts do we want to see while installing

# do we need admin access? yes
  become: true

# what task do we want to perform in this yml file
  tasks:
  - name: Install Nginx in web Agent Node
    apt: pkg=nginx state=present
    become_user: root

  - name: Setting reverse proxy
    shell: |
      sudo rm -rf /etc/nginx/sites-available/default
      cp ./awsFileTransfer/default /etc/nginx/sites-available/default
    become_user: root

  - name: Restart Ngnix
    shell: |
      sudo systemctl restart nginx
    become_user: root

```

Step 4: create playbook

`ansible-playbook install_ngnix.yml`

> you may need to ssh into the web agent to create a fingerprint

step 5: check nginx status

`ansible web -a "systemctl status nginx"`


## Creating a playbook to install nodejs for web node

### Step 1: cd into `/etc/ansible`

### Step 2: Create a yaml file 

`sudo nano install_nodejs.yml`

### Step 3: add code to yaml file

```
---
# which host do we need to install nginx in
- hosts: web
  gather_facts: true

# what facts do we want to see while installing

# do we need admin access? yes
  become: true

# what task do we want to perform in this yml file
  tasks:
  - name: Install Nodejs in web Agent Node
    shell: |
      curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && sudo apt-get install nodejs -y

  - name: Install npm and pm2
    shell: |
      sudo apt install npm -y
      sudo npm install pm2 -g
      
  - name: env variable
     shell: |
       echo 'export DB_HOST="mongodb://192.168.33.11:27017/posts"' >> .bashrc
    become_user: root
    
  - name: Seed and run app
    shell: |
      cd awsFileTransfer/
      cd app/
      npm install
      node seeds/seed.js
      #pm2 kill
      #pm2 start app.js

    become_user: root

  


# what is the end goal for this task


```

Step 4: create playbook

`ansible-playbook install_nodejs.yml`

> you may need to ssh into the web agent to create a fingerprint

step 5: check if nodejs installed

`ansible web -a "nodejs --version"`


## Creating a playbook to install mongodb for db node

### Step 1: cd into `/etc/ansible`

### Step 2: Create a yaml file 

`sudo nano install_mongodb.yml`

### Step 3: add code to yaml file

```
# Installing mongo in db VM
---
# host name
- hosts: db
  gather_facts: yes

# gather facts for installation

# we need admin access
  become: true

# The actual task is to install mongodb in db VM

  tasks:
  - name: Installing mongodb in db VM
    apt: pkg=mongodb state=present

  - name: restarting db and chnaging conf file
    shell: |
      rm -rf /etc/mongod.conf
      cp ./mongod.conf /etc/mongod.conf
      sudo systemctl restart mongodb
      sudo systemctl enable mongodb
    become_user: root

```

Step 4: create playbook

`ansible-playbook install_mongodb.yml`

> you may need to ssh into the web agent to create a fingerprint

step 5: check if mongodb installed

`ansible db -a "sudo systemctl status mongodb"`


