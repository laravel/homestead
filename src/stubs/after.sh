#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

# Install other tools required for local development
apt-get install -y ant

# Fill in missing XDebug config
echo "xdebug.idekey="phpstorm"
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.max_nesting_level=300
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1" >> /etc/php/7.0/mods-available/xdebug.ini

# Reload Nginx and PHPFPM as final steps
service php7.0-fpm reload
service nginx reload
