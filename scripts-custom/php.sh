#!/bin/sh

echo 'Installing any PHP extensions and configuring...'

# xdebug Customization.

cp -rf /vagrant/scripts-custom/configs/xdebug.ini /etc/php/*/mods-available/
chown root:root /etc/php/*/mods-available/xdebug.ini && chmod 644 /etc/php/*/mods-available/xdebug.ini

# Restart all FPM daemons.

systemctl restart php5.6-fpm php7.0-fpm php7.1-fpm php7.2-fpm php7.3-fpm php7.4-fpm

# Add phpdbg wrapper for 10x faster code coverage generation vs PHPUnit, until
# popular IDEs support it natively.

cp /vagrant/scripts-custom/resources/phpdbg-proxy.sh /home/vagrant/
chown vagrant:vagrant /home/vagrant/phpdbg-proxy.sh
chmod 755 /home/vagrant/phpdbg-proxy.sh
