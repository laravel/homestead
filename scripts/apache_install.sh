#!/usr/bin/env bash

# stop nginx
service nginx stop

# only install apache2 if not present yet
if ! [ -f /etc/apache2/apache2.conf ]
then
	# update
	apt-get update

	# install apache
	apt-get install -y apache2 libapache2-mod-php7.0 libapache2-mod-auth-mysql

else
	service apache2 start

fi

# set ServerName and enable conf
echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf
a2enconf fqdn

# set default charset to UTF-8
cp /etc/apache2/conf-available/charset.conf /etc/apache2/conf-available/charset.conf.orig
echo AddDefaultCharset UTF-8 >> /etc/apache2/conf-available/charset.conf

# enable mod_rewrite
a2enmod rewrite

# enable ssl
a2enmod ssl

# restart apache
service apache2 restart

# make back-up copy of /etc/hosts
cp /etc/hosts /etc/hosts.orig