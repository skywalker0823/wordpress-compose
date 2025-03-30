#!/bin/bash

# ----- Install docker ----- #

echo "install docker"

sudo yum update -y sudo yum install -y yum-utils 
 
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# start & enable docker.service

sudo systemctl start docker.service
sudo systemctl enable docker.service 

# ----- Install docker-compose ----- #

echo "install docker-compose"

# get latest docker compose released tag

COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Output compose version

docker-compose --version

exit 0
