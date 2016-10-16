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
    listen ${4:-443} ssl http2;
    server_name $1;
    root \"$2\";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/$5-error.log error;

    sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/nginx/ssl/$5.crt;
    ssl_certificate_key /etc/nginx/ssl/$5.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$5"
ln -fs "/etc/nginx/sites-available/$5" "/etc/nginx/sites-enabled/$5"
service hhvm restart
