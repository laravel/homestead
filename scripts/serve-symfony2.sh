#!/usr/bin/env bash

mkdir /etc/nginx/ssl 2>/dev/null
openssl genrsa -out "/etc/nginx/ssl/$5.key" 2048 2>/dev/null
openssl req -new -key /etc/nginx/ssl/$5.key -out /etc/nginx/ssl/$5.csr -subj "/CN=$5/O=Vagrant/C=UK" 2>/dev/null
openssl x509 -req -days 365 -in /etc/nginx/ssl/$5.csr -signkey /etc/nginx/ssl/$5.key -out /etc/nginx/ssl/$5.crt 2>/dev/null

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
    error_log  /var/log/nginx/$5-ssl-error.log error;

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

    ssl_certificate     /etc/nginx/ssl/$5.crt;
    ssl_certificate_key /etc/nginx/ssl/$5.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$5"
ln -fs "/etc/nginx/sites-available/$5" "/etc/nginx/sites-enabled/$5"
