#!/bin/sh

echo 'Installing any PHP extensions and configuring...'

# xdebug Customization.

cp -rf /vagrant/scripts-custom/configs/xdebug.ini /etc/php/*/mods-available/
chown root:root /etc/php/*/mods-available/xdebug.ini && chmod 644 /etc/php/*/mods-available/xdebug.ini

# Restart all FPM daemons.

systemctl restart php5.6-fpm php7.0-fpm php7.1-fpm php7.2-fpm php7.3-fpm php7.4-fpm
