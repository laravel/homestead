#!/usr/bin/env bash

# Clear The Old Environment Variables

sed -i '/# Set Homestead Environment Variable/,+1d' /home/vagrant/.profile

if [ -f /etc/php/5.6/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/5.6/fpm/pool.d/www.conf
fi

if [ -f /etc/php/7.0/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/7.0/fpm/pool.d/www.conf
fi

if [ -f /etc/php/7.1/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/7.1/fpm/pool.d/www.conf
fi

if [ -f /etc/php/7.2/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/7.2/fpm/pool.d/www.conf
fi

if [ -f /etc/php/7.3/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/7.3/fpm/pool.d/www.conf
fi

if [ -f /etc/php/7.4/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/7.4/fpm/pool.d/www.conf
fi

if [ -f /etc/php/8.0/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/8.0/fpm/pool.d/www.conf
fi

if [ -f /etc/php/8.1/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/8.1/fpm/pool.d/www.conf
fi

if [ -f /etc/php/8.2/fpm/pool.d/www.conf ]; then
    sed -i '/env\[.*/,+1d' /etc/php/8.2/fpm/pool.d/www.conf
fi
