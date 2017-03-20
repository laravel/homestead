#!/usr/bin/env bash

mkdir /etc/nginx/ssl 2>/dev/null

PATH_CA="/vagrant"
PATH_CA_KEY="${PATH_CA}/ca.key"
PATH_CA_CRT="${PATH_CA}/ca.crt"

if [ ! -f $PATH_CA_KEY ] || [ ! -f $PATH_CA_CRT ]
then
    openssl genrsa -out "$PATH_CA_KEY" 2048 2>/dev/null
    openssl req -new -x509 -days 365 -key "$PATH_CA_KEY" -out "$PATH_CA_CRT" -subj "/CN=homestead/O=Vagrant/C=UK" 2>/dev/null
fi

PATH_SSL="/etc/nginx/ssl"
PATH_KEY="${PATH_SSL}/${1}.key"
PATH_CSR="${PATH_SSL}/${1}.csr"
PATH_CRT="${PATH_SSL}/${1}.crt"
PATH_BUNDLE="${PATH_SSL}/${1}-bundle.crt"

if [ ! -f $PATH_KEY ] || [ ! -f $PATH_CSR ] || [ ! -f $PATH_CRT ] || [ ! -f $PATH_BUNDLE ]
then
  openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
  openssl req -new -key "$PATH_KEY" -out "$PATH_CSR" -subj "/CN=$1/O=Vagrant/C=UK" 2>/dev/null
  openssl x509 -req -days 365 -in "$PATH_CSR" -CA "$PATH_CA_CRT" -CAkey "$PATH_CA_KEY" -set_serial 01 -out "$PATH_CRT" 2>/dev/null
  cat "$PATH_CRT" "$PATH_CA_CRT" > "$PATH_BUNDLE"
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl;
    server_name $1;

    location / {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_pass http://127.0.0.1:${2};
    }

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;

    ssl_certificate     /etc/nginx/ssl/$1-bundle.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
