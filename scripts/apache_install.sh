#!/usr/bin/env bash

# stop nginx
service nginx stop

# update
apt-get update

# install apache
apt-get install -y apache2 libapache2-mod-php7.0 libapache2-mod-auth-mysql

# set ServerName and enable conf
echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf
a2enconf fqdn

# set default charset to UTF-8
echo AddDefaultCharset UTF-8 >> /etc/apache2/conf-available/charset.conf

# enable mod_rewrite
a2enmod rewrite
a2enmod ssl

# prepare dir for SSL certs
mkdir /etc/apache2/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt

# restart apache
service apache2 restart