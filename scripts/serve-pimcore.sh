#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y php"$5"-bz2

if [ "$7" = "true" ] && [ "$5" = "7.2" ]
then configureZray="
location /ZendServer {
        try_files \$uri \$uri/ /ZendServer/index.php?\$args;
}
"
else configureZray=""
fi

block="# mime types are covered in nginx.conf by:
# http {
#   include       mime.types;
# }

upstream php-pimcore5 {
    server unix:/var/run/php/php$5-fpm.sock;
}

server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name $1;
    root \"$2\";

    index index.php;

    access_log off;
    error_log  /var/log/nginx/$1-ssl-error.log error;

    # Pimcore Head-Link Cache-Busting
    rewrite ^/cache-buster-(?:\d+)/(.*) /\$1 last;

    # Stay secure
    #
    # a) don't allow PHP in folders allowing file uploads
    location ~* /var/assets/*\.php(/|\$) {
        return 404;
    }
    # b) Prevent clients from accessing hidden files (starting with a dot)
    # Access to `/.well-known/` is allowed.
    # https://www.mnot.net/blog/2010/04/07/well-known
    # https://tools.ietf.org/html/rfc5785
    location ~* /\.(?!well-known/) {
        deny all;
        log_not_found off;
        access_log off;
    }
    # c) Prevent clients from accessing to backup/config/source files
    location ~* (?:\.(?:bak|conf(ig)?|dist|fla|in[ci]|log|psd|sh|sql|sw[op])|~)\$ {
        deny all;
    }

    # Some Admin Modules need this:
    # Database Admin, Server Info
    location ~* ^/admin/(adminer|external) {
        rewrite .* /app.php\$is_args\$args last;
    }

    # Thumbnails
    location ~* .*/(image|video)-thumb__\d+__.* {
        try_files /var/tmp/\$1-thumbnails\$uri /app.php;
        expires 2w;
        access_log off;
        add_header Cache-Control \"public\";
    }

    # Assets
    # Still use a whitelist approach to prevent each and every missing asset to go through the PHP Engine.
    location ~* (.+?)\.((?:css|js)(?:\.map)?|jpe?g|gif|png|svgz?|eps|exe|gz|zip|mp\d|ogg|ogv|webm|pdf|docx?|xlsx?|pptx?)\$ {
        try_files /var/assets\$uri \$uri =404;
        expires 2w;
        access_log off;
        log_not_found off;
        add_header Cache-Control \"public\";
    }

    # Installer
    # Remove this if you don't need the web installer (anymore)
    if (-f \$document_root/install.php) {
        rewrite ^/install(/?.*) /install.php last;
    }

    location / {
        error_page 404 /meta/404;
        add_header \"X-UA-Compatible\" \"IE=edge\";
        try_files \$uri /app.php\$is_args\$args;
    }

    # Use this location when the installer has to be run
    # location ~ /(app|install)\.php(/|\$) {
    #
    # Use this after initial install is done:
    location ~ /(app|install)\.php(/|\$) {
        send_timeout 1800;
        fastcgi_read_timeout 1800;
        # regex to split \$uri to \$fastcgi_script_name and \$fastcgi_path
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        # Check that the PHP script exists before passing it
        try_files \$fastcgi_script_name =404;
        include fastcgi.conf;
        # Bypass the fact that try_files resets \$fastcgi_path_info
        # see: http://trac.nginx.org/nginx/ticket/321
        set \$path_info \$fastcgi_path_info;
        fastcgi_param PATH_INFO \$path_info;

        # Activate these, if using Symlinks and opcache
        # fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        # fastcgi_param DOCUMENT_ROOT \$realpath_root;

        fastcgi_pass php-pimcore5;
        # Prevents URIs that include the front controller. This will 404:
        # http://domain.tld/app.php/some-path
        # Remove the internal directive to allow URIs like this
        internal;
    }

    # PHP-FPM Status and Ping
    location /fpm- {
        access_log off;
        include fastcgi_params;
        location /fpm-status {
            allow 127.0.0.1;
            # add additional IP's or Ranges
            deny all;
            fastcgi_pass php-pimcore5;
        }
        location /fpm-ping {
            fastcgi_pass php-pimcore5;
        }
    }
    # nginx Status
    # see: https://nginx.org/en/docs/http/ngx_http_stub_status_module.html
    location /nginx-status {
        allow 127.0.0.1;
        deny all;
        access_log off;
        stub_status;
    }

    ssl_certificate     /etc/nginx/ssl/$1.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"

sudo service nginx restart
