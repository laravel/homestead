#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
   WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
   WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
   WSL_USER_NAME=vagrant
   WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/php82 ]
then
   echo "PHP 8.2 already installed."
   exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/php82
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# PHP 8.2
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --allow-change-held-packages \
php8.2 php8.2-bcmath php8.2-bz2 php8.2-cgi php8.2-cli php8.2-common php8.2-curl php8.2-dba php8.2-dev \
php8.2-enchant php8.2-fpm php8.2-gd php8.2-gmp php8.2-imap php8.2-interbase php8.2-intl php8.2-ldap \
php8.2-mbstring php8.2-mysql php8.2-odbc php8.2-opcache php8.2-pgsql php8.2-phpdbg php8.2-pspell php8.2-readline \
php8.2-snmp php8.2-soap php8.2-sqlite3 php8.2-sybase php8.2-tidy php8.2-xml php8.2-xsl \
php8.2-zip php8.2-imagick php8.2-memcached php8.2-redis php8.2-xmlrpc php8.2-xdebug

# Configure php.ini for CLI
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.2/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.2/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.2/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.2/cli/php.ini

# Configure Xdebug
echo "xdebug.mode = debug" >> /etc/php/8.2/mods-available/xdebug.ini
echo "xdebug.discover_client_host = true" >> /etc/php/8.2/mods-available/xdebug.ini
echo "xdebug.client_port = 9003" >> /etc/php/8.2/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/8.2/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/8.2/mods-available/opcache.ini

# Configure php.ini for FPM
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.2/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.2/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.2/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.2/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.2/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.2/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.2/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/8.2/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.2/fpm/php.ini
printf "[curl]\n" | tee -a /etc/php/8.2/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.2/fpm/php.ini

# Configure FPM
sed -i "s/user = www-data/user = vagrant/" /etc/php/8.2/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = vagrant/" /etc/php/8.2/fpm/pool.d/www.conf
sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/8.2/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/8.2/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.2/fpm/pool.d/www.conf
