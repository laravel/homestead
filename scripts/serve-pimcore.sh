#!/usr/bin/env bash

# install apache and bzip PHP extension
export DEBIAN_FRONTEND=noninteractive
sudo service nginx stop
apt-get update
apt-get install -y apache2 libapache2-mod-fastcgi
apt-get install -y php"$5"-bz2

block="<VirtualHost *:$3>
    ServerName $1
    ServerAlias *.$1

    DocumentRoot $2
    <Directory $2>
        AllowOverride All
        Require all granted
    </Directory>

    # Force Apache to pass the Authorization header to PHP:
    # required for "basic_auth" under PHP-FPM and FastCGI
    SetEnvIfNoCase ^Authorization\$ \"(.+)\" HTTP_AUTHORIZATION=\$1

    # Using SetHandler avoids issues with using ProxyPassMatch in combination
    # with mod_rewrite or mod_autoindex
    <FilesMatch \.php$>
        SetHandler \"proxy:unix:/var/run/php/php$5-fpm.sock|fcgi://localhost\"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/$1-error.log
    CustomLog \${APACHE_LOG_DIR}/$1-access.log combined
</VirtualHost>
"

blockssl="<IfModule mod_ssl.c>
    <VirtualHost *:$4>
        ServerName $1
        ServerAlias *.$1

        DocumentRoot $2
        <Directory $2>
            AllowOverride All
            Require all granted
        </Directory>

        # Force Apache to pass the Authorization header to PHP:
        # required for "basic_auth" under PHP-FPM and FastCGI
        SetEnvIfNoCase ^Authorization\$ \"(.+)\" HTTP_AUTHORIZATION=\$1

        # Using SetHandler avoids issues with using ProxyPassMatch in combination
        # with mod_rewrite or mod_autoindex
        <FilesMatch \.php$>
            SetHandler \"proxy:unix:/var/run/php/php$5-fpm.sock|fcgi://localhost\"
        </FilesMatch>

        ErrorLog \${APACHE_LOG_DIR}/$1-error.log
        CustomLog \${APACHE_LOG_DIR}/$1-access.log combined

        SSLEngine on
        SSLCertificateFile      /etc/nginx/ssl/$1.crt
        SSLCertificateKeyFile   /etc/nginx/ssl/$1.key

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
"

echo "$block" > "/etc/apache2/sites-available/$1.conf"
echo "$blockssl" > "/etc/apache2/sites-available/$1-ssl.conf"

sudo a2dissite 000-default
sudo a2ensite $1 $1-ssl

ps auxw | grep apache2 | grep -v grep > /dev/null

sudo a2enmod ssl rewrite proxy proxy_fcgi
service apache2 restart

if [ $? == 0 ]
then
    service apache2 reload
fi