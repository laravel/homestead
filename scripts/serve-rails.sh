#!/usr/bin/env bash

#block="server {
#    listen ${3:-80};
#    listen ${4:-443} ssl http2;
#    server_name .$1;
#
#    # Tell Nginx and Passenger where your app's 'public' directory is
#    root \"$2\";
#
#    # Turn on Passenger
#    passenger_enabled on;
#    passenger_ruby /usr/bin/ruby2.5;
#
#    ssl_certificate     /etc/nginx/ssl/$1.crt;
#    ssl_certificate_key /etc/nginx/ssl/$1.key;
#}
#"
#
#echo "$block" > "/etc/nginx/sites-available/$1"
#ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
