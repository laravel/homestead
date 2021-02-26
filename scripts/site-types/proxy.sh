#!/usr/bin/env bash

declare -A params=$6       # Create an associative array
declare -A headers=$9      # Create an associative array
paramsTXT=""
if [ -n "$6" ]; then
   for element in "${!params[@]}"
   do
      paramsTXT="${paramsTXT}
        ${element} ${params[$element]};"
   done
fi
headersTXT=""
if [ -n "$9" ]; then
   for element in "${!headers[@]}"
   do
      headersTXT="${headersTXT}
        add_header ${element} ${headers[$element]};"
   done
fi

if [ -n "$2" ]
then
    if ! [[ "$2" =~ ^[0-9]+$ ]]
    then
        proxyPass="
        proxy_pass ${2};
        "
    else proxyPass="
        proxy_pass http://127.0.0.1:$2;
        "
    fi
else proxyPass="
proxy_pass http://127.0.0.1;
"
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl;
    server_name .$1;

    location / {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        $proxyPass
        $headersTXT
        $paramsTXT
    }

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;

    ssl_certificate     /etc/ssl/certs/$1.crt;
    ssl_certificate_key /etc/ssl/certs/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
