#!/bin/sh

echo 'Installing Laravel Echo...'

sudo npm install -g laravel-echo-server

cp -f /vagrant/scripts-custom/configs/laravel-echo-server.json "$1/"
