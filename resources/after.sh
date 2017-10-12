#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

sudo apt-get update
sudo apt-get autoremove
sudo apt-get --assume-yes install mcrypt php7.1-mcrypt php-imagick
sudo apt-get upgrade -y

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
echo "local.fulfillment.shineon.com $ composer dump-autoload"
echo "---------------------------------------------------------------------------------"
composer dump-autoload -d ~/fulfillment.shineon.com/\


echo "---------------------------------------------------------------------------------"
echo "local.fulfillment.shineon.com"
echo "php artisan clear-compiled && php artisan migrate && php artisan passport:install"
echo "---------------------------------------------------------------------------------"
php ~/fulfillment.shineon.com/artisan clear-compiled
php ~/fulfillment.shineon.com/artisan migrate --force
php ~/fulfillment.shineon.com/artisan passport:install --force
