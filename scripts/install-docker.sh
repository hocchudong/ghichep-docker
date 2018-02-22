#!/bin/bash

echo "Cai dat docker"
sleep 3
curl -sSL https://get.docker.com/| sudo sh
sudo usermod -aG docker `whoami`
systemctl start docker.service
systemctl enable docker.service

echo "Cai dat docker compose"
sleep 3
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sleep 3
echo "Kiem tra phien ban docker va docker compose"
docker version 
docker-compose --version
##############
echo "IMOK"
