#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

# Downgrade to PHP 5.5
sudo apt-get update
yes | sudo apt-get install php5.5 php5.5-dev php5.5-mysql php5.5-fpm php5.5-curl
sudo sed -i 's/php7\.0/php5\.5/g' local.portal.shineon.com

sudo service nginx restart
sudo service php5.5-fpm restart

echo "Changing to portal.shineon.com Directory"
cd ~/portal.shineon.com
composer dump-autoload
php artisan clear-compiled
php artisan migrate