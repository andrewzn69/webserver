#!/bin/bash

# prompt for username
read -p "Enter the username:" USERNAME

# set variables
DOMAIN="domain.com"
SUBDOMAIN="$USERNAME.$DOMAIN"
STRAPI_DIR="/home/$USERNAME"

# create a new user
adduser $USERNAME

# create a subdomain in nginx
NGINX_CONFIG="/etc/nginx/sites-available/$SUBDOMAIN.conf"
cp /etc/nginx/sites-available/template.conf $NGINX_CONFIG
sed -i "s/template/$SUBDOMAIN/g" $NGINX_CONFIG
ln -s $NGINX_CONFIG /etc/nginx/sites-enabled

# reload nginx config
service nginx reload

