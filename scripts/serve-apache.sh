#!/usr/bin/env bash

mkdir /etc/apache2/ssl 2>/dev/null

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

block="<VirtualHost *:80>
       # The ServerName directive sets the request scheme, hostname and port that
       # the server uses to identify itself. This is used when creating
       # redirection URLs. In the context of virtual hosts, the ServerName
       # specifies what hostname must appear in the request's Host: header to
       # match this virtual host. For the default virtual host (this file) this
       # value is not decisive as it is used as a last resort host regardless.
       # However, you must set it for any further virtual host explicitly.
       #ServerName www.example.com

       ServerAdmin webmaster@localhost
       ServerName $1
       ServerAlias www.$1
       DocumentRoot $2

       # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
       # error, crit, alert, emerg.
       # It is also possible to configure the loglevel for particular
       # modules, e.g.
       #LogLevel info ssl:warn

       ErrorLog ${APACHE_LOG_DIR}/error.log
       CustomLog ${APACHE_LOG_DIR}/access.log combined

       # For most configuration files from conf-available/, which are
       # enabled or disabled at a global level, it is possible to
       # include a line for only one particular virtual host. For example the
       # following line enables the CGI configuration for this host only
       # after it has been globally disabled with "a2disconf".
       #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
"

echo "$block" > "/etc/apache2/sites-available/$1.conf"
ln -fs "/etc/apache2/sites-available/$1.conf" "/etc/apache2/sites-enabled/$1.conf"
