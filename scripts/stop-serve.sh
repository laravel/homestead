#!/usr/bin/env bash

if [ -f "/etc/nginx/sites-available/$1" ];
then
	rm "/etc/nginx/sites-enabled/$1"
	rm "/etc/nginx/sites-available/$1"

	service nginx restart
	service php5-fpm restart
	service hhvm restart
fi