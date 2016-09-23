#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

# Uninstall PHP 7.0
echo "--------------------------------------------------"
echo "uninstalling php7"
echo "--------------------------------------------------"
echo "y" | sudo apt-get purge php7.0-common
echo "y" | sudo apt-get purge blackfire-php

echo "--------------------------------------------------"
echo "installing php5.6"
echo "--------------------------------------------------"
# Downgrade to PHP 5.6
sudo apt-get update
yes | sudo apt-get install php5.6-fpm php5.6 php5.6-dev php5.6-mysql php5.6-curl php5.6-xml php5-dev pkg-config php-pear make php5-memcached memcached libmemcached-tools libmemcached-dev
sudo sed -i 's/php7\.0/php5\.6/g' /etc/nginx/sites-available/local.portal.shineon.com

# Symlink our new 5.6 install
sudo ln -sf /usr/bin/php5.6 /etc/alternatives/php
sudo ln -sf /usr/bin/php-config5.6 /etc/alternatives/php-config

# Restart PHP
sudo service php5.6-fpm restart
sudo service nginx restart

# Setup Memcached
echo "--------------------------------------------------"
echo "installing memcached" 
echo "--------------------------------------------------"
#wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz --directory-prefix=/tmp
#tar xvf /tmp/libmemcached-1.0.18.tar.gz -C /tmp
#/tmp/libmemcached-1.0.18/configure --prefix=/tmp/libmemcached-1.0.18
#make && make install
echo "/usr" | sudo pecl install memcached

sudo cp /usr/share/doc/php5-memcached/memcached.ini /etc/php/5.6/mods-available/
sudo sh -c 'echo "extension=memcached.so" >> /etc/php/5.6/fpm/php.ini'
sudo sh -c 'echo "extension=memcached.so" >> /etc/php/5.6/cli/php.ini'
sudo ln -s /etc/php/5.6/mods-available/memcached.ini /etc/php/5.6/fpm/conf.d/25-memcached.ini
sudo ln -s /etc/php/5.6/mods-available/memcached.ini /etc/php/5.6/cli/conf.d/25-memcached.ini

sudo service php5.6-fpm restart
sudo service nginx restart

# sudo sed -i '/ssl_certificate/d' /etc/nginx/sites-available/local.portal.shineon.com
# sudo sed -i '/listen 443/d' /etc/nginx/sites-available/local.portal.shineon.com
# sudo sed -i 's/listen.*80/listen 127.0.0.1:81/' /etc/nginx/sites-available/local.portal.shineon.com

# sudo bash -c 'echo "upstream cluster {
#         server 127.0.0.1:81;
# }
# server {
#   listen 80;
#   listen 443 ssl;
  
#   ssl_certificate     /etc/nginx/ssl/local.portal.shineon.com.crt;
#   ssl_certificate_key /etc/nginx/ssl/local.portal.shineon.com.key;


#   location / {
#     proxy_set_header Host $host;
#     proxy_set_header X-Real-IP $remote_addr;
#     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#     proxy_set_header X-Queue-Start "t=${msec}000";
#     proxy_pass  http://cluster;
#   }
# }" > /etc/nginx/sites-available/local.portal.loadbalancer'

# sudo service nginx stop
# sudo service php5.5-fpm stop

# sudo ln -sf /etc/nginx/sites-available/local.portal.loadbalancer /etc/nginx/sites-enabled/local.portal.loadbalancer

echo "--------------------------------------------------"
echo "composer dump-autoload"
echo "--------------------------------------------------"
composer dump-autoload -d ~/portal.shineon.com/\


echo "--------------------------------------------------"
echo "php artisan clear-compiled && php artisan migrate"
echo "--------------------------------------------------"
php ~/portal.shineon.com/artisan clear-compiled
php ~/portal.shineon.com/artisan migrate

echo "--------------------------------------------------"
echo "npm install"
echo "--------------------------------------------------"
npm --prefix ~/portal.shineon.com install ~/portal.shineon.com/
