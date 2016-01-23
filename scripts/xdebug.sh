#!/usr/bin/env bash

TEMP_DIR="~/temp"
XDEBUG_LINK="http://xdebug.org/files/xdebug-2.4.0rc3.tgz"
XDEBUG_VERSION="xdebug-2.4.0RC3"
XDEBUG_LOAD_LINE="[xdebug]
zend_extension = /usr/lib/php/20151012/xdebug.so
"

mkdir $TEMP_DIR
wget $XDEBUG_LINK -O $TEMP_DIR"/xdebug.tgz"
cd $TEMP_DIR
tar -xvzf xdebug.tgz
cd $XDEBUG_VERSION
phpize
./configure
make
sudo cp modules/xdebug.so /usr/lib/php/20151012
echo "$XDEBUG_LOAD_LINE" > "/etc/php/7.0/fpm/php.ini"

service nginx restart
service php7.0-fpm restart
