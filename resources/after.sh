#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

sudo apt-get update
sudo apt-get --assume-yes install mcrypt php7.1-mcrypt
sudo apt-get upgrade

sudo service php7.1-fpm restart
sudo service nginx restart

echo "---------------------------------------------------------------------------------"
echo "local.portal.shineon.com $ composer dump-autoload"
echo "---------------------------------------------------------------------------------"
composer dump-autoload -d ~/portal.shineon.com/\


echo "---------------------------------------------------------------------------------"
echo "local.portal.shineon.com $ php artisan clear-compiled && php artisan migrate"
echo "---------------------------------------------------------------------------------"
php ~/portal.shineon.com/artisan clear-compiled
php ~/portal.shineon.com/artisan migrate --force

echo "---------------------------------------------------------------------------------"
echo "local.portal.shineon.com $ npm install"
echo "---------------------------------------------------------------------------------"
npm --prefix ~/portal.shineon.com install ~/portal.shineon.com/


echo "---------------------------------------------------------------------------------"
echo "local.shopify-app.shineon.com $ composer dump-autoload"
echo "---------------------------------------------------------------------------------"
composer dump-autoload -d ~/shopify-app/\


echo "---------------------------------------------------------------------------------"
echo "local.shopify-app.shineon.com $ php artisan clear-compiled && php artisan migrate"
echo "---------------------------------------------------------------------------------"
php ~/shopify-app/artisan clear-compiled
php ~/shopify-app/artisan migrate --force
