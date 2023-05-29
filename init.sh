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
apt install -y nginx php php-cli certbot python3-certbot-nginx unzip

# install composer
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# install grav
git clone -b master https://github.com/getgrav/grav.git
cd grav
composer install --no-dev -o
bin/grav install


# start and enable nginx
systemctl start nginx
systemctl enable nginx

# ufw configuration
ufw allow 'Nginx HTTP'
ufw allow 'OpenSSH'
ufw allow 22

