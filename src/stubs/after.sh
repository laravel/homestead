#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

# Downgrade to PHP 5.5
sudo apt-get update
yes | sudo apt-get install php5.5 php5.5-dev php5.5-mysql php5.5-fpm php5.5-curl php5.5-memcached

sudo sed -i 's/php7\.0/php5\.5/g' /etc/nginx/sites-available/local.portal.shineon.com
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

sudo ln -sf /usr/bin/php5.5 /etc/alternatives/php

sudo service php5.5-fpm restart
sudo service nginx restart

echo "composer dump-autoload"
composer dump-autoload -d ~/portal.shineon.com/

echo "php artisan clear-compiled"
php ~/portal.shineon.com/artisan clear-compiled

echo "php artisan migrate"
php ~/portal.shineon.com/artisan migrate

echo "npm install"
npm --prefix ~/portal.shineon.com install ~/portal.shineon.com/
