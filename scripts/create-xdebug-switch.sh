#!/bin/bash

mkdir /home/vagrant/.xdebug-switch

echo "zend_extension = xdebug.so
xdebug.remote_enable=1
xdebug.remote_host=10.20.1.1
xdebug.remote_autostart=1" > /home/vagrant/.xdebug-switch/xdebug-autostart.sh

echo "zend_extension = xdebug.so
xdebug.remote_enable=1
xdebug.remote_host=10.20.1.1" > /home/vagrant/.xdebug-switch/xdebug-on.sh

echo "zend_extension = xdebug.so" > /home/vagrant/.xdebug-switch/xdebug-off.sh


echo "#!/usr/bin/env bash

function xdebug-autostart {
    sudo cp /home/vagrant/.xdebug-switch/xdebug-autostart.sh /etc/php/7.1/fpm/conf.d/xdebug.ini
    sudo service php7.1-fpm restart
    echo \"xdebug is on - autostarting\"
}

function xdebug-on {
    sudo cp /home/vagrant/.xdebug-switch/xdebug-on.sh /etc/php/7.1/fpm/conf.d/xdebug.ini
    sudo service php7.1-fpm restart
    echo \"xdebug is on\"
}

function xdebug-off {
   sudo cp /home/vagrant/.xdebug-switch/xdebug-off.sh /etc/php/7.1/fpm/conf.d/xdebug.ini
   sudo service php7.1-fpm restart
   echo \"xdebug is off\"
}

function xdebug-autostart-cli {
    sudo cp /home/vagrant/.xdebug-switch/xdebug-autostart.sh /etc/php/7.1/cli/conf.d/xdebug.ini
    echo \"xdebug (for cli) is on - autostarting\"
}

function xdebug-on-cli {
    sudo cp /home/vagrant/.xdebug-switch/xdebug-on.sh /etc/php/7.1/cli/conf.d/xdebug.ini
    echo \"xdebug (for cli) is on\"
}

function xdebug-off-cli {
   sudo cp /home/vagrant/.xdebug-switch/xdebug-off.sh /etc/php/7.1/cli/conf.d/xdebug.ini
   echo \"xdebug (for cli) is off\"
}


" > tee /etc/profile.d/xdebug.sh

sudo service php7.1-fpm start

