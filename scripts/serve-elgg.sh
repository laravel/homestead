#!/usr/bin/env bash
declare -A params=$6     # Create an associative array
paramsTXT=""
if [ -n "$6" ]; then
   for element in "${!params[@]}"
   do
      paramsTXT="${paramsTXT}
      fastcgi_param ${element} ${params[$element]};"
   done
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name $1;

    root $2;
    index index.php index.html index.htm;

    error_log /var/log/nginx/$1-error.log error;
    access_log off;

    gzip on;
    gzip_types
        # text/html is always compressed by HttpGzipModule
        text/css
        text/javascript
        text/xml
        text/plain
        text/x-component
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/rss+xml
        font/truetype
        font/opentype
        application/vnd.ms-fontobject
        image/svg+xml;

    # Max post size
    client_max_body_size 8M;

    location ~ /.well-known {
        allow all;
    }

    location ~ (^\.|/\.) {
        deny all;
    }

    location = /rewrite.php {
        rewrite ^(.*)$ /install.php;
    }

    location / {
        try_files \$uri \$uri/ @elgg;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    location ~ \.php$ {
        try_files \$uri @elgg;
        fastcgi_index index.php;
        fastcgi_pass unix:/var/run/php/php$5-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include /etc/nginx/fastcgi_params;
    }

    location @elgg {
        fastcgi_pass unix:/var/run/php/php$5-fpm.sock;

        include /etc/nginx/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root/index.php;
        fastcgi_param SCRIPT_NAME     /index.php;
        fastcgi_param QUERY_STRING    __elgg_uri=\$uri&\$args;
    }
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"