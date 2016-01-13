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

# restart apache
service apache2 restart