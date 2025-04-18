#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras enable docker
sudo yum install docker -y

sudo service docker start
sudo systemctl enable docker
sudo usermod -aG docker $USER
