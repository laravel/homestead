#!/usr/bin/env bash

sudo service nginx stop

if [ -d /etc/apache2 ]
then
    sudo service apache2 stop
fi