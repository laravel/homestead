#!/usr/bin/env bash

declare -A headers=$9      # Create an associative array

headersTXT=""
if [ -n "$9" ]; then
   for element in "${!headers[@]}"
   do
      headersTXT="${headersTXT}
      add_header ${element} ${headers[$element]};"
   done
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name $1;
    root \"$2\";

    index index.html;

    charset utf-8;

    $rewritesTXT

    location / {
        try_files \$uri \$uri/ /index.html;
        $headersTXT
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/nginx/ssl/$1.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
