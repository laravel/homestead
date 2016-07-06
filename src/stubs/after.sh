#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

# Downgrade to PHP 5.5
sudo apt-get update
yes | sudo apt-get install php5.5 php5.5-dev php5.5-mysql php5.5-fpm php5.5-curl
sudo sed -i 's/php7\.0/php5\.5/g' local.portal.shineon.com
sudo sed -i '/ssl_certificate/d' local.portal.shineon.com
sudo sed -i '/listen 443/d' local.portal.shineon.com
sudo sed -i 's/listen.*80/listen 127.0.0.1:81/' local.portal.shineon.com

block_lb="upstream cluster {
        server 127.0.0.1:81;
}
server {
  listen 80;
  listen 443 ssl;
  
  ssl_certificate     /etc/nginx/ssl/local.portal.shineon.com.crt;
  ssl_certificate_key /etc/nginx/ssl/local.portal.shineon.com.key;


  location / {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Queue-Start "t=${msec}000";
    proxy_pass  http://cluster;
  }
}"

echo "$block_lb" > "/etc/nginx/sites-available/local.portal.loadbalancer"
ln -sf /etc/nginx/sites-available/local.portal.loadbalancer /etc/nginx/sites-enabled/local.portal.loadbalancer

sudo service nginx restart
sudo service php5.5-fpm restart

echo "Changing to portal.shineon.com Directory"
cd ~/portal.shineon.com
composer dump-autoload
php artisan clear-compiled
php artisan migrate