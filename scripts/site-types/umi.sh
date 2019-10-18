#!/usr/bin/env bash

declare -A params=$6     # Create an associative array
declare -A headers=$9    # Create an associative array
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
if [ -n "$9" ]; then
   for element in "${!headers[@]}"
   do
      headersTXT="${headersTXT}
      add_header ${element} ${headers[$element]};"
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
    server_name .$1;
    root \"$2\";

    index index.html index.htm index.php;

    charset utf-8;

    $rewritesTXT

    location ~* ^\/(classes|errors\/logs|sys\-temp|cache|xmldb|static|packages) {
      deny all;
    }

    location ~* (\/for_del_connector\.php|\.ini|\.conf)\$ {
      deny all;
    }

    location ~* ^(\/files\/|\/images\/|\/yml\/) {
      try_files \$uri =404;
    }

    location ~* ^\/images\/autothumbs\/ {
      try_files \$uri @autothumbs =404;
    }

    location @autothumbs {
      rewrite ^\/images\/autothumbs\/(.*)\$ /autothumbs.php?img=\$1\$query_string last;
    }

    location @clean_url {
      rewrite ^/(.*)\$ /index.php?path=\$1 last;
    }

    location @dynamic {
      try_files \$uri @clean_url;
    }

    location \/yml\/files\/ {
      try_files \$uri =404;
    }

    location / {
      rewrite ^\/robots\.txt /sbots_custom.php?path=\$1 last;
      rewrite ^\/sitemap\.xml /sitemap.php last;
      rewrite ^\/\~\/([0-9]+)\$ /tinyurl.php?id=\$1 last;
      rewrite ^\/(udata|upage|uobject|ufs|usel|ulang|utype|umess|uhttp):?(\/\/)?(.*)? /releaseStreams.php?scheme=\$1&path=\$3 last;
      rewrite ^\/(.*)\.xml\$ /index.php?xmlMode=force&path=\$1 last;
      rewrite ^(.*)\.json\$ /index.php?jsonMode=force&path=\$1 last;

      $headersTXT

      if (\$cookie_umicms_session) {
        error_page 412 = @dynamic;
        return 412;
      }

      if (\$request_method = 'POST') {
        error_page 412 = @dynamic;
        return 412;
      }

      index index.php;
      try_files \$uri @dynamic;
    }

    location ~* \.js\$ {
      rewrite ^\/(udata|upage|uobject|ufs|usel|ulang|utype|umess|uhttp):?(\/\/)?(.*)? /releaseStreams.php?scheme=\$1&path=\$3 last;
      try_files \$uri =404;
    }

    location ~* \.(ico|jpg|jpeg|png|gif|swf|css|ttf)\$ {
      try_files \$uri =404;
      access_log off;
      expires 24h;
    }

    $configureZray

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/\$1-error.log error;

    sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/var/run/php/php$5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

        $paramsTXT

        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/nginx/ssl/$1.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
