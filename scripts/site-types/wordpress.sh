#!/usr/bin/env bash

declare -A params=$6       # Create an associative array
declare -A headers=${9}    # Create an associative array
declare -A rewrites=${10}  # Create an associative array
paramsTXT=""
if [ -n "$6" ]; then
   for element in "${!params[@]}"
   do
      paramsTXT="${paramsTXT}
      fastcgi_param ${element} ${params[$element]};"
   done
fi
headersTXT=""
if [ -n "${9}" ]; then
   for element in "${!headers[@]}"
   do
      headersTXT="${headersTXT}
      add_header ${element} ${headers[$element]};"
   done
fi
rewritesTXT=""
if [ -n "${10}" ]; then
   for element in "${!rewrites[@]}"
   do
      rewritesTXT="${rewritesTXT}
      location ~ ${element} { if (!-f \$request_filename) { return 301 ${rewrites[$element]}; } }"
   done
fi

if [ "$7" = "true" ]
then configureXhgui="
location /xhgui {
        try_files \$uri \$uri/ /xhgui/index.php?\$args;
}
"
else configureXhgui=""
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name .$1;
    root \"$2\";

    index index.php index.html index.htm;

    charset utf-8;
    client_max_body_size 100M;

    $rewritesTXT

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { allow all; access_log off; log_not_found off; }

    location ~*/wp-content/uploads {
        log_not_found off;
        try_files \$uri @prod_site;
    }

    location @prod_site {
        rewrite ^/(.*)$ https://${11}/$1 redirect;
    }

    location ~ /.*\.(jpg|jpeg|png|js|css)$ {
        try_files \$uri =404;
    }

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    if (!-e \$request_filename) {
        # Add trailing slash to */wp-admin requests.
        rewrite /wp-admin$ \$scheme://\$host\$uri/ permanent;

        # WordPress in a subdirectory rewrite rules
        rewrite ^/([_0-9a-zA-Z-]+/)?(wp-.*|xmlrpc.php) /wp/\$2 break;
    }

    location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include fastcgi_params;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_pass unix:/var/run/php/php$5-fpm.sock;
        fastcgi_intercept_errors on;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
    }

    $configureXhgui

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;

    sendfile off;

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/ssl/certs/$1.crt;
    ssl_certificate_key /etc/ssl/certs/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"


# Additional constants to define in wp-config.php
wpConfigSearchStr="\$table_prefix = 'wp_';"
wpConfigReplaceStr="\$table_prefix = 'wp_';\\n\
\\n\
// Define the default HOME/SITEURL constants and set them to our root domain\\n\
if ( ! defined( 'WP_HOME' ) ) {\\n\
	define( 'WP_HOME', 'http://$1' );\\n\
}\\n\
if ( ! defined( 'WP_SITEURL' ) ) {\\n\
	define( 'WP_SITEURL', WP_HOME );\\n\
}\\n\
\\n\
if ( ! defined( 'WP_CONTENT_DIR' ) ) {\\n\
	define( 'WP_CONTENT_DIR', __DIR__ . '/wp-content' );\\n\
}\\n\
if ( ! defined( 'WP_CONTENT_URL' ) ) {\\n\
	define( 'WP_CONTENT_URL', WP_HOME . '/wp-content' );\\n\
}\\n\
\\n\
define( 'WP_DEBUG', true ); \\n\
"


# If wp-cli is installed, try and update it
if [ -f /usr/local/bin/wp ]
then
    wp cli update --stable --yes
fi

# If WP is not installed then download it
if [ -d "$2/wp" ]
then
    echo "WordPress is already installed."
else
    sudo -i -u vagrant -- mkdir "$2/wp"
    sudo -i -u vagrant -- wp core download --path="$2/wp" --version=latest
    sudo -i -u vagrant -- cp -R $2/wp/wp-content $2/wp-content
    sudo -i -u vagrant -- cp $2/wp/index.php $2/index.php
    sudo -i -u vagrant -- sed -i "s|/wp-blog-header|/wp/wp-blog-header|g" $2/index.php
    sudo -i -u vagrant -- echo "path: $2/wp/" > $2/wp-cli.yml
    sudo -i -u vagrant -- wp config create --path=$2/wp/ --dbname=${1/./_} --dbuser=homestead --dbpass=secret --dbcollate=utf8_general_ci
    sudo -i -u vagrant -- mv $2/wp/wp-config.php $2/wp-config.php
    sudo -i -u vagrant -- sed -i 's|'"$wpConfigSearchStr"'|'"$wpConfigReplaceStr"'|g' $2/wp-config.php
    sudo -i -u vagrant -- sed -i "s|define( 'ABSPATH', dirname( __FILE__ ) . '/' );|define( 'ABSPATH', __DIR__ . '/wp/' );|g" $2/wp-config.php

    echo "WordPress has been downloaded and config file has been generated, install it manually."
fi
