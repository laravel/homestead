#!/usr/bin/env bash

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run with wsl:apply-features.

# Remove unused php version
for version in 5.6 7.0 7.1 7.2 7.3 7.4
do
sudo update-alternatives --remove php /usr/bin/php$version
sudo update-alternatives --remove php-config /usr/bin/php-config$version
sudo update-alternatives --remove phpize /usr/bin/phpize$version
sudo apt purge -y "php${version}*"
sudo systemctl disable "php${version}-fpm.service"
done

# php memory limit
sudo sed -i "s/memory_limit\ =\ .*/memory_limit\ =\ 2080M/" /etc/php/${1}/fpm/php.ini
sudo sed -i "s/memory_limit\ =\ .*/memory_limit\ =\ 2080M/" /etc/php/${1}/cli/php.ini

# fpm www pool
sudo sed -i "s/pm\.max_children\ =\ .*/pm\.max_children\ =\ 20/" /etc/php/${1}/fpm/pool.d/www.conf
sudo sed -i "s/pm\.start_servers\ =\ .*/pm\.start_servers\ =\ 10/" /etc/php/${1}/fpm/pool.d/www.conf
sudo sed -i "s/pm\.min_spare_servers\ =\ .*/pm\.min_spare_servers\ =\ 5/" /etc/php/${1}/fpm/pool.d/www.conf
sudo sed -i "s/pm\.max_spare_servers\ =\ .*/pm\.max_spare_servers\ =\ 10/" /etc/php/${1}/fpm/pool.d/www.conf

# fix open-ssh
sudo apt-get remove -y openssh-server
sudo apt-get install -y openssh-server
sudo sed -i "s/PasswordAuthentication\ no/PasswordAuthentication\ yes/" /etc/ssh/sshd_config

# disable for octane
sudo systemctl disable php${1}-fpm.service
# restart services
sudo systemctl restart nginx.service
sudo systemctl restart ssh.service
