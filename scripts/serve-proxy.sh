#!/usr/bin/env bash

mkdir /etc/nginx/ssl 2>/dev/null

PATH_SSL="/etc/nginx/ssl"
PATH_KEY="${PATH_SSL}/${5}.key"
PATH_CSR="${PATH_SSL}/${5}.csr"
PATH_CRT="${PATH_SSL}/${5}.crt"

if [ ! -f $PATH_KEY ] || [ ! -f $PATH_CSR ] || [ ! -f $PATH_CRT ]
then
  openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
  openssl req -new -key "$PATH_KEY" -out "$PATH_CSR" -subj "/CN=$5/O=Vagrant/C=UK" 2>/dev/null
  openssl x509 -req -days 365 -in "$PATH_CSR" -signkey "$PATH_KEY" -out "$PATH_CRT" 2>/dev/null
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl;
    server_name $1;

    location / {
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header Host \$host;
      proxy_pass http://127.0.0.1:${2};
    }

    access_log off;
    error_log  /var/log/nginx/$5-error.log error;

    ssl_certificate     /etc/nginx/ssl/$5.crt;
    ssl_certificate_key /etc/nginx/ssl/$5.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$5"
ln -fs "/etc/nginx/sites-available/$5" "/etc/nginx/sites-enabled/$5"
