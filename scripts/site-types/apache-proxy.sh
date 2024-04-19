#!/usr/bin/env bash

declare -A params=$6     # Create an associative array
declare -A headers=${9}  # Create an associative array
paramsTXT=""
if [ -n "$6" ]; then
    for element in "${!params[@]}"
    do
        paramsTXT="${paramsTXT}
        SetEnv ${element} \"${params[$element]}\""
    done
fi
headersTXT=""
if [ -n "${9}" ]; then
   for element in "${!headers[@]}"
   do
      headersTXT="${headersTXT}
      Header always set ${element} \"${headers[$element]}\""
   done
fi

if [ -n "$2" ]
then
    if ! [[ "$2" =~ ^[0-9]+$ ]]
    then
        if ! [[ "$2" =~ ^https: ]]
        then
            socket=$(echo "$2" | sed -E "s/^http(s?):\/\//ws:\/\//g")
        else
            socket=$(echo "$2" | sed -E "s/^http(s?):\/\//wss:\/\//g")
        fi

        proxyPass="
        RewriteEngine On
        RewriteCond %{HTTP:Upgrade} =websocket [NC]
        RewriteRule /(.*) $socket/ [P,L]

        ProxyPass / ${2}/
        ProxyPassReverse / ${2}/
        "
    else proxyPass="
        RewriteEngine On
        RewriteCond %{HTTP:Upgrade} =websocket [NC]
        RewriteRule /(.*) ws://127.0.0.1:$2/ [P,L]

        ProxyPass / http://127.0.0.1:$2/
        ProxyPassReverse / http://127.0.0.1:$2/
        "
    fi
else proxyPass="
RewriteEngine On
RewriteCond %{HTTP:Upgrade} =websocket [NC]
RewriteRule /(.*) ws://127.0.0.1/ [P,L]

ProxyPass / http://127.0.0.1/
ProxyPassReverse / http://127.0.0.1/
"
fi

export DEBIAN_FRONTEND=noninteractive

sudo service nginx stop
sudo systemctl disable nginx
sudo systemctl enable apache2

sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_ajp
sudo a2enmod rewrite
sudo a2enmod deflate
sudo a2enmod headers
sudo a2enmod proxy_balancer
sudo a2enmod proxy_connect
sudo a2enmod proxy_html

block="<VirtualHost *:$3>
    ServerAdmin webmaster@localhost
    ServerName $1
    ServerAlias www.$1

    ProxyPreserveHost On
    RequestHeader set X-Real-IP %{REMOTE_ADDR}s
    RequestHeader set Upgrade websocket
    RequestHeader set Connection Upgrade

    $paramsTXT
    $headersTXT

    $proxyPass
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
"

echo "$block" > "/etc/apache2/sites-available/$1.conf"
ln -fs "/etc/apache2/sites-available/$1.conf" "/etc/apache2/sites-enabled/$1.conf"

blockssl="<IfModule mod_ssl.c>
    <VirtualHost *:$4>
        ServerAdmin webmaster@localhost
        ServerName $1
        ServerAlias www.$1

        ProxyPreserveHost On
        RequestHeader set X-Real-IP %{REMOTE_ADDR}s
        RequestHeader set Upgrade websocket
        RequestHeader set Connection Upgrade

        $paramsTXT
        $headersTXT

        SSLEngine on

		SSLCertificateFile      /etc/ssl/certs/$1.crt
        SSLCertificateKeyFile   /etc/ssl/certs/$1.key

		$proxyPass
    </VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
"

echo "$blockssl" > "/etc/apache2/sites-available/$1-ssl.conf"
ln -fs "/etc/apache2/sites-available/$1-ssl.conf" "/etc/apache2/sites-enabled/$1-ssl.conf"

ps auxw | grep apache2 | grep -v grep > /dev/null

service apache2 restart

if [ $? == 0 ]
then
    service apache2 reload
fi
