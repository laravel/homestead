#!/usr/bin/env bash

echo "127.0.0.1		$1		$1.localhost" >> /etc/hosts

PATH_SSL="/etc/apache2/ssl"
PATH_KEY="${PATH_SSL}/${1}.key"
PATH_CSR="${PATH_SSL}/${1}.csr"
PATH_CRT="${PATH_SSL}/${1}.crt"

if [ ! -f $PATH_KEY ] || [ ! -f $PATH_CSR ] || [ ! -f $PATH_CRT ]
then
  openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
  openssl req -new -key "$PATH_KEY" -out "$PATH_CSR" -subj "/CN=$1/O=Vagrant/C=UK" 2>/dev/null
  openssl x509 -req -days 365 -in "$PATH_CSR" -signkey "$PATH_KEY" -out "$PATH_CRT" 2>/dev/null
fi

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
		SSLCertificateFile $PATH_CRT
		SSLCertificateKeyFile $PATH_KEY

	</VirtualHost>
"

echo "$block" > "/etc/apache2/sites-available/$1.conf"
a2ensite $1.conf
service apache2 reload