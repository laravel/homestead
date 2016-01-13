#!/usr/bin/env bash

echo "127.0.0.1		$1		$1.localhost" >> /etc/hosts

if 
block="<VirtualHost *:$3>
		ServerAdmin vagrant@localhost

		ServerName $1
		DocumentRoot $2

		<Directory $2>
			AllowOverride All
			Order allow,deny
			allow from all
			Require all granted
		</Directory>

		ErrorLog \${APACHE_LOG_DIR}/error_$1.log
		CustomLog \${APACHE_LOG_DIR}/access_$1.log combined

	</VirtualHost>

	<VirtualHost *:$4>
		ServerAdmin vagrant@localhost

		ServerName $1:$4
		DocumentRoot $2

		<Directory $2>
			AllowOverride All
			Order allow,deny
			allow from all
			Require all granted
		</Directory>

		ErrorLog \${APACHE_LOG_DIR}/error_$1.log
		CustomLog \${APACHE_LOG_DIR}/access_$1.log combined

		SSLEngine on
		SSLCertificateFile /etc/apache2/ssl/apache.crt
		SSLCertificateKeyFile /etc/apache2/ssl/apache.key

	</VirtualHost>
"

echo "$block" > "/etc/apache2/sites-available/$1.conf"
a2ensite $1.conf
service apache2 reload