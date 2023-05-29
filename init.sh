#!/bin/bash

# BEFORE INSTALLING

# have a debian or ubuntu server with static ip and dns records
# use a ufw

# NOTE WHILE INSTALLING

# todo

# AFTER INSTALLING

# todo

# this is for running some commands as a normal user
if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    user=$SUDO_USER
else
    user=$(whoami)
fi

# update system packages
apt update
apt upgrade -y

# install necessary packages
apt install -y nginx php php-cli certbot python3-certbot-nginx unzip

# install composer
sudo -u $user curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo -u $user HASH=`curl -sS https://composer.github.io/installer.sig`
sudo -u $user php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# install grav
sudo -u $user git clone -b master https://github.com/getgrav/grav.git
cd grav
sudo -u $user composer install --no-dev -o
sudo -u $user bin/grav install


# start and enable nginx
systemctl start nginx
systemctl enable nginx

# ufw configuration
ufw allow 'Nginx HTTP'
ufw allow 'OpenSSH'
ufw allow 22

