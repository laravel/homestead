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

    index index.html index.htm index.php app.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /app.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/$FILENAME-ssl-error.log error;

    sendfile off;

    client_max_body_size 100m;

    # DEV
    location ~ ^/(app_dev|config)\.php(/|\$) {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
    }

    # PROD
    location ~ ^/app\.php(/|$) {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        # Prevents URIs that include the front controller. This will 404:
        # http://domain.tld/app.php/some-path
        # Remove the internal directive to allow URIs like this
        internal;
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
