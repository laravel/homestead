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

if [ "$7" = "true" ] && [ "$5" = "7.2" ]
then configureZray="
location /ZendServer {
        try_files \$uri \$uri/ /ZendServer/index.php?\$args;
}
"
else configureZray=""
fi

block="server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name $1;
    root \"$2\";

    charset utf-8;

    if (\$http_x_forwarded_host) {
        return 400;
    }

    location / {
        try_files \$uri /index.php?url=\$uri&\$query_string;
    }

    error_page 404 /assets/error-404.html;
    error_page 500 /assets/error-500.html;

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;
    sendfile off;

    location ^~ /assets/ {
        location ~ /\. {
            deny all;
        }
        try_files \$uri /index.php?url=\$uri&\$query_string;
    }

    location ~ /framework/.*(main|rpc|tiny_mce_gzip)\.php$ {
        fastcgi_keep_conn on;
        fastcgi_pass   unix:/var/run/php/php$5-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
        $paramsTXT
    }

    location ~ /(mysite|framework|cms)/.*\.(php|php3|php4|php5|phtml|inc)$ {
        deny all;
    }

    location ~ /\.. {
        deny all;
    }

    location ~ \.ss$ {
        satisfy any;
        allow 127.0.0.1;
        deny all;
    }

    location ~ web\.config$ {
        deny all;
    }

    location ~ \.ya?ml$ {
        deny all;
    }

    location ^~ /vendor/ {
        deny all;
    }

    location ~* /silverstripe-cache/ {
        deny all;
    }

    location ~* composer\.(json|lock)$ {
        deny all;
    }

    location ~* /(cms|framework)/silverstripe_version$ {
        deny all;
    }

    location ~ \.php$ {
        fastcgi_keep_conn on;
        fastcgi_pass   unix:/var/run/php/php$5-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
        fastcgi_buffer_size 32k;
        fastcgi_busy_buffers_size 64k;
        fastcgi_buffers 4 32k;
        $paramsTXT
    }

    $configureZray

    ssl_certificate     /etc/nginx/ssl/$1.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
