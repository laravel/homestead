#!/usr/bin/env bash

# Clear The Old Environment Variables

sed -i '/# Set Homestead Environment Variable/,+1d' /home/vagrant/.profile
sed -i '/env\[.*/,+1d' /etc/php/7.1/fpm/pool.d/www.conf
sed -i '/env\[.*/,+1d' /etc/php/7.2/fpm/pool.d/www.conf
