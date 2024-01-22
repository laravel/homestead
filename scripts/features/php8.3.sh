#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/php83 ]
then
    echo "PHP 8.3 already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/php83
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# PHP 8.3
apt-get install -y --allow-change-held-packages \
php8.3 php8.3-bcmath php8.3-bz2 php8.3-cgi php8.3-cli php8.3-common php8.3-curl php8.3-dba php8.3-dev \
php8.3-enchant php8.3-fpm php8.3-gd php8.3-gmp php8.3-imap php8.3-interbase php8.3-intl php8.3-ldap \
php8.3-mbstring php8.3-mysql php8.3-odbc php8.3-opcache php8.3-pgsql php8.3-phpdbg php8.3-pspell php8.3-readline \
php8.3-snmp php8.3-soap php8.3-sqlite3 php8.3-sybase php8.3-tidy php8.3-xml php8.3-xsl \
php8.3-zip php8.3-imagick php8.3-memcached php8.3-redis php8.3-xmlrpc php8.3-xdebug

# Configure php.ini for CLI
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.3/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.3/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.3/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.3/cli/php.ini

# Configure Xdebug
echo "xdebug.mode = debug" >> /etc/php/8.3/mods-available/xdebug.ini
echo "xdebug.discover_client_host = true" >> /etc/php/8.3/mods-available/xdebug.ini
echo "xdebug.client_port = 9003" >> /etc/php/8.3/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/8.3/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/8.3/mods-available/opcache.ini

# Configure php.ini for FPM
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.3/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.3/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.3/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.3/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.3/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.3/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.3/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/8.3/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.3/fpm/php.ini
printf "[curl]\n" | tee -a /etc/php/8.3/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.3/fpm/php.ini

# Configure FPM
sed -i "s/user = www-data/user = vagrant/" /etc/php/8.3/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = vagrant/" /etc/php/8.3/fpm/pool.d/www.conf
sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/8.3/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/8.3/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.3/fpm/pool.d/www.conf
