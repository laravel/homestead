#!/usr/bin/env bash

block="map \$http_upgrade \$connection_upgrade {
        default upgrade;
        ''      close;
    }
server {
    listen ${3:-80};
    listen ${4:-443} ssl http2;
    server_name   $1;
    location / {
        proxy_pass         http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade \$http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
    ssl_certificate     /etc/nginx/ssl/$1.crt;
    ssl_certificate_key /etc/nginx/ssl/$1.key;
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"

kestrel="[Unit]
Description=$1

[Service]
WorkingDirectory=$2
ExecStart=/usr/bin/dotnet $2/$8
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
SyslogIdentifier=$1
User=vagrant
Environment=ASPNETCORE_ENVIRONMENT=Development
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
"

echo "$kestrel" > "/etc/systemd/system/kestrel-$1.service"

systemctl enable "kestrel-$1.service"
