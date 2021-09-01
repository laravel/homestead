#!/usr/bin/env bash

# php memory limit
sudo sed -i "s/memory_limit\ =\ .*/memory_limit\ =\ 2080M/" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/memory_limit\ =\ .*/memory_limit\ =\ 2080M/" /etc/php/8.0/cli/php.ini

# fpm www pool
sudo sed -i "s/pm\.max_children\ =\ .*/pm\.max_children\ =\ 20/" /etc/php/8.0/fpm/pool.d/www.conf
sudo sed -i "s/pm\.start_servers\ =\ .*/pm\.start_servers\ =\ 10/" /etc/php/8.0/fpm/pool.d/www.conf
sudo sed -i "s/pm\.min_spare_servers\ =\ .*/pm\.min_spare_servers\ =\ 5/" /etc/php/8.0/fpm/pool.d/www.conf
sudo sed -i "s/pm\.max_spare_servers\ =\ .*/pm\.max_spare_servers\ =\ 10/" /etc/php/8.0/fpm/pool.d/www.conf

# fix open-ssh
sudo apt-get remove -y openssh-server
sudo apt-get install -y openssh-server
sudo sed -i "s/PasswordAuthentication\ no/PasswordAuthentication\ yes/" /etc/ssh/sshd_config

# disable for octane
sudo systemctl disable php8.0-fpm.service
# restart services
sudo systemctl restart nginx.service
sudo systemctl restart ssh.service
