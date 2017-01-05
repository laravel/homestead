#!/usr/bin/env bash
apt-get update
apt-get install -y apache2 libapache2-mod-php7.1
sed -i "s/www-data/vagrant/" /etc/apache2/envvars

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

        <Directory $2>
            AllowOverride All
            Require all granted
        </Directory>

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

blockssl="<IfModule mod_ssl.c>
  <VirtualHost *:443>

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

    #   SSL Engine Switch:
    #   Enable/Disable SSL for this virtual host.
    SSLEngine on

    #   A self-signed (snakeoil) certificate can be created by installing
    #   the ssl-cert package. See
    #   /usr/share/doc/apache2/README.Debian.gz for more info.
    #   If both key and certificate are stored in the same file, only the
    #   SSLCertificateFile directive is needed.
    #SSLCertificateFile  /etc/ssl/certs/ssl-cert-snakeoil.pem
    #SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

    SSLCertificateFile      $PATH_CRT
    SSLCertificateKeyFile $PATH_KEY

    #   Server Certificate Chain:
    #   Point SSLCertificateChainFile at a file containing the
    #   concatenation of PEM encoded CA certificates which form the
    #   certificate chain for the server certificate. Alternatively
    #   the referenced file can be the same as SSLCertificateFile
    #   when the CA certificates are directly appended to the server
    #   certificate for convinience.
    #SSLCertificateChainFile /etc/apache2/ssl.crt/server-ca.crt

    #   Certificate Authority (CA):
    #   Set the CA certificate verification path where to find CA
    #   certificates for client authentication or alternatively one
    #   huge file containing all of them (file must be PEM encoded)
    #   Note: Inside SSLCACertificatePath you need hash symlinks
    #    to point to the certificate files. Use the provided
    #    Makefile to update the hash symlinks after changes.
    #SSLCACertificatePath /etc/ssl/certs/
    #SSLCACertificateFile /etc/apache2/ssl.crt/ca-bundle.crt

    #   Certificate Revocation Lists (CRL):
    #   Set the CA revocation path where to find CA CRLs for client
    #   authentication or alternatively one huge file containing all
    #   of them (file must be PEM encoded)
    #   Note: Inside SSLCARevocationPath you need hash symlinks
    #    to point to the certificate files. Use the provided
    #    Makefile to update the hash symlinks after changes.
    #SSLCARevocationPath /etc/apache2/ssl.crl/
    #SSLCARevocationFile /etc/apache2/ssl.crl/ca-bundle.crl


    #SSLVerifyClient require
    #SSLVerifyDepth  10


    <FilesMatch \"\.(cgi|shtml|phtml|php)$\">
        SSLOptions +StdEnvVars
    </FilesMatch>
    <Directory /usr/lib/cgi-bin>
        SSLOptions +StdEnvVars
    </Directory>

    BrowserMatch \"MSIE [2-6]\" \
        nokeepalive ssl-unclean-shutdown \
        downgrade-1.0 force-response-1.0
    # MSIE 7 and newer should be able to use keepalive
    BrowserMatch \"MSIE [17-9]\" ssl-unclean-shutdown

  </VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
"

if [ -f $PATH_KEY ] && [ -f $PATH_CSR ] && [ -f $PATH_CRT ]
then
  echo "$blockssl" > "/etc/apache2/sites-available/$1-ssl.conf"
  ln -fs "/etc/apache2/sites-available/$1-ssl.conf" "/etc/apache2/sites-enabled/$1-ssl.conf"
fi

a2dissite 000-default
service apache2 reload
