#!/usr/bin/env bash

FILENAME="$1"

if [[ $1 == *"*"* ]]
then
    HASH=`echo $1 | md5sum | cut -f1 -d" "`
    FILENAME="${1/\*/$HASH}"
fi

mkdir /etc/nginx/ssl 2>/dev/null
openssl genrsa -out "/etc/nginx/ssl/$FILENAME.key" 1024 2>/dev/null
openssl req -new -key /etc/nginx/ssl/$FILENAME.key -out /etc/nginx/ssl/$FILENAME.csr -subj "/CN=$1/O=Vagrant/C=UK" 2>/dev/null
openssl x509 -req -days 365 -in /etc/nginx/ssl/$FILENAME.csr -signkey /etc/nginx/ssl/$FILENAME.key -out /etc/nginx/ssl/$FILENAME.crt 2>/dev/null

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl;
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
    error_log  /var/log/nginx/$FILENAME-error.log error;

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

    ssl_certificate     /etc/nginx/ssl/$FILENAME.crt;
    ssl_certificate_key /etc/nginx/ssl/$FILENAME.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$FILENAME"
ln -fs "/etc/nginx/sites-available/$FILENAME" "/etc/nginx/sites-enabled/$FILENAME"
service nginx restart
service php5-fpm restart
service hhvm restart
