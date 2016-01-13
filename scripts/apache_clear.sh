#!/usr/bin/env bash

# only run if apache2 is present
if [ -f /etc/apache2/apache2.conf ]
then
	# remove fqdn
	a2disconf fqdn
	rm /etc/apache2/conf-available/fqdn.conf

	# restore charset
	rm /etc/apache2/conf-available/charset.conf
	mv /etc/apache2/conf-available/charset.conf.orig /etc/apache2/conf-available/charset.conf

	# disable mod_rewrite
	a2dismod rewrite

	# disable ssl
	a2dismod ssl

	# restore /etc/hosts
	rm /etc/hosts
	mv /etc/hosts.orig /etc/hosts

	# clear all sites (except for defaults)
	cd /etc/apache2/sites-available/

	for f in *.conf
	do
		if ! [ $(echo $f | grep default) ];
		then
			a2dissite $f
			rm $f
		fi
	done

	# remove ssl 
	rm -R /etc/apache2/ssl

	# not removing apache, just stopping it
	service apache2 stop

fi

# start NginX
service nginx restart