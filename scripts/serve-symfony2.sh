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
    listen ${4:-443} ssl http2;
    server_name $1;
    root \"$2\";

    index index.html index.htm index.php app_dev.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /app_dev.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/$1-ssl-error.log error;

    sendfile off;

    client_max_body_size 100m;

    # DEV
    location ~ ^/(app_dev|app_test|config)\.php(/|\$) {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
    }

    # PROD
    location ~ ^/app\.php(/|$) {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        internal;
    }

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/nginx/ssl/$1-bundle.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
