#!/bin/bash

# BEFORE INSTALLING

# have a debian or ubuntu server with static ip and dns records
# use a ufw

# NOTE WHILE INSTALLING

# todo

# AFTER INSTALLING

# todo

# update system packages
apt update
apt upgrade -y

# install necessary packages
apt install -y nginx php certbot python3-certbot-nginx

# start and enable nginx
systemctl start nginx
systemctl enable nginx

# ufw configuration
ufw allow 'Nginx HTTP'
ufw allow 'OpenSSH'
ufw allow 22


