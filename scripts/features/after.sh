#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
#
# If you have user-specific configurations you would like
# to apply, you may also create user-customizations.sh,
# which will be run after this script.

# php memory limit
sudo sed -i "s/memory_limit\ =\ .*/memory_limit\ =\ 4096M/" /etc/php/${1}/fpm/php.ini
sudo sed -i "s/memory_limit\ =\ .*/memory_limit\ =\ 4096M/" /etc/php/${1}/cli/php.ini

# fpm www pool
sudo sed -i "s/pm\.max_children\ =\ .*/pm\.max_children\ =\ 20/" /etc/php/${1}/fpm/pool.d/www.conf
sudo sed -i "s/pm\.start_servers\ =\ .*/pm\.start_servers\ =\ 10/" /etc/php/${1}/fpm/pool.d/www.conf
sudo sed -i "s/pm\.min_spare_servers\ =\ .*/pm\.min_spare_servers\ =\ 5/" /etc/php/${1}/fpm/pool.d/www.conf
sudo sed -i "s/pm\.max_spare_servers\ =\ .*/pm\.max_spare_servers\ =\ 10/" /etc/php/${1}/fpm/pool.d/www.conf

# xdebug port
sudo sed -i "s/xdebug.remote_port\ =\ .*/xdebug.remote_port\ =\ 9009/" /etc/php/${1}/mods-available/xdebug.ini
