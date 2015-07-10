#!/usr/bin/env bash

# Clear out old environment variables
printf "Clear environment variables...\n"
sed '/#Set Homestead environment variable/,+2 d' /home/vagrant/.profile > tmpfile ; mv tmpfile /home/vagrant/.profile
sed '/env\[/,+1 d' /etc/php5/fpm/php-fpm.conf > tmpfile ; mv tmpfile /etc/php5/fpm/php-fpm.conf

printf "Clear old nginx sites...\n"
rm /etc/nginx/sites-enabled/*
rm /etc/nginx/sites-available/*
