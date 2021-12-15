#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/php80 ]
then
    echo "PHP 8.0 already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/php80
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# PHP 8.0
apt-get install -y --allow-change-held-packages \
php8.0 php8.0-bcmath php8.0-bz2 php8.0-cgi php8.0-cli php8.0-common php8.0-curl php8.0-dba php8.0-dev \
php8.0-enchant php8.0-fpm php8.0-gd php8.0-gmp php8.0-imap php8.0-interbase php8.0-intl php8.0-ldap \
php8.0-mbstring php8.0-mysql php8.0-odbc php8.0-opcache php8.0-pgsql php8.0-phpdbg php8.0-pspell php8.0-readline \
php8.0-snmp php8.0-soap php8.0-sqlite3 php8.0-sybase php8.0-tidy php8.0-xdebug php8.0-xml php8.0-xmlrpc php8.0-xsl \
php8.0-zip php8.0-memcached php8.0-redis

# Configure php.ini for CLI
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.0/cli/php.ini

# Configure Xdebug
echo "xdebug.mode = debug" >> /etc/php/8.0/mods-available/xdebug.ini
echo "xdebug.discover_client_host = true" >> /etc/php/8.0/mods-available/xdebug.ini
echo "xdebug.client_port = 9003" >> /etc/php/8.0/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/8.0/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/8.0/mods-available/opcache.ini

# Configure php.ini for FPM
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.0/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.0/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.0/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.0/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/8.0/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.0/fpm/php.ini
printf "[curl]\n" | tee -a /etc/php/8.0/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.0/fpm/php.ini

# Configure FPM
sed -i "s/user = www-data/user = vagrant/" /etc/php/8.0/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = vagrant/" /etc/php/8.0/fpm/pool.d/www.conf
sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/8.0/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/8.0/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.0/fpm/pool.d/www.conf

systemctl enable php8.0-fpm
service php8.0-fpm restart
