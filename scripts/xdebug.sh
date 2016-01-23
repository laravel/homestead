#!/usr/bin/env bash

TEMP_DIR="/home/vagrant/temp"
XDEBUG_LINK="http://xdebug.org/files/xdebug-2.4.0rc3.tgz"
XDEBUG_VERSION="xdebug-2.4.0RC3"
XDEBUG_LOAD_LINE="[xdebug]
zend_extension = /usr/lib/php/20151012/xdebug.so

xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9000
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1
"
XDEBUG_INI_PATH="/etc/php/7.0/fpm/conf.d/20-xdebug.ini"
XDEBUG_CLI_INI_PATH="/etc/php/7.0/cli/conf.d/20-xdebug.ini"

mkdir $TEMP_DIR
wget $XDEBUG_LINK -O $TEMP_DIR"/xdebug.tgz" -q
cd $TEMP_DIR
tar -xzf xdebug.tgz
cd $XDEBUG_VERSION
phpize --silent
./configure --silent
make --silent
sudo cp modules/xdebug.so /usr/lib/php/20151012
sudo echo "$XDEBUG_LOAD_LINE" > "$XDEBUG_INI_PATH"
sudo ln -s $XDEBUG_INI_PATH $XDEBUG_CLI_INI_PATH

sudo service nginx restart
sudo service php7.0-fpm restart

sudo rm -rf $TEMP_DIR
