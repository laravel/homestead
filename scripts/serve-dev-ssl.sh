#!/usr/bin/env bash

block="

# HTTP 80
server {
    listen 80;
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
    error_log  /var/log/nginx/$1-error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
    }

    location ~ /\.ht {
        deny all;
    }
}

# HTTPS 443 SSL
server {
    listen 443 ssl;
    server_name $1;
    root \"$2\";

    ssl_certificate /etc/nginx/ssl/$1.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
    }

    location ~ /\.ht {
        deny all;
    }
}
"

# A blank passphrase
PASSPHRASE=""

# Set our CSR variables
SUBJ="
C=BR
ST=Goias
O=
localityName=Laravel
commonName=$DOMAIN
organizationalUnitName=
emailAddress=
"

# SSL directory
sudo mkdir -p /etc/nginx/ssl

# private key
sudo openssl genrsa -out "/etc/nginx/ssl/$1.key" 2048

# generate the Certificate Signing Request
sudo openssl req -new -key "/etc/[webserver]/ssl/$1.key" \
                 -out "/etc/[webserver]/ssl/$1.csr"

# Generate our Private Key, CSR and Certificate
sudo openssl genrsa -out "/etc/nginx/ssl/$1.key" 2048
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "/etc/nginx/ssl/$1.key" -out "/etc/nginx/ssl/$1.csr" -passin pass:$PASSPHRASE
sudo openssl x509 -req -days 365 -in "/etc/nginx/ssl/$1.csr" -signkey "/etc/nginx/ssl/$1.key" -out "/etc/nginx/ssl/$1.crt"

# create site
echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
service php5-fpm restart
