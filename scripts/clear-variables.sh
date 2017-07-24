#!/usr/bin/env bash

# Clear The Old Environment Variables

sed -i '/# Set Homestead Environment Variable/,+1d' /home/vagrant/.profile
sed -i '/env\[.*/,+1d' /etc/php/5.6/fpm/php-fpm.conf
sed -i '/env\[.*/,+1d' /etc/php/7.0/fpm/php-fpm.conf
sed -i '/env\[.*/,+1d' /etc/php/7.1/fpm/php-fpm.conf
