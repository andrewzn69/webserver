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
apt install -y nginx php php-cli php-curl php-zip php-dom php-gd certbot python3-certbot-nginx unzip

# install composer
sudo -u $user curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# install grav
sudo -u $user git clone -b master https://github.com/getgrav/grav.git
cd grav
sudo -u $user composer install --no-dev -o
sudo -u $user bin/grav install

# ufw configuration
ufw allow 'Nginx HTTP'
ufw allow 'OpenSSH'
ufw allow 22

# creating template nginx config
cat > /etc/nginx/sites-available/template <<EOF
server {
    listen 80;
    server_name {DOMAIN};

    root {ROOT};
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;  # Adjust the PHP-FPM socket path as needed
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PHP_ADMIN_VALUE "open_basedir=/path/to/grav/folder:/tmp";
    }

    location ~* \.(?:css|js)$ {
        expires 1y;
        access_log off;
        add_header Cache-Control "public";
    }

    location ~* \.(?:jpg|jpeg|gif|png|ico|svg)$ {
        expires 1y;
        access_log off;
        add_header Cache-Control "public";
    }
}
EOF

# symlink it to sites-enabled
ln -s "$nginx_config_file" "/etc/nginx/sites-enabled/grav.conf"

# start and enable nginx
systemctl start nginx
systemctl enable nginx
