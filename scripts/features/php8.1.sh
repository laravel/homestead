#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
   WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
   WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
   WSL_USER_NAME=vagrant
   WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

SERVICE_STATUS=$(systemctl is-enabled php8.1-fpm.service)

if [ "$SERVICE_STATUS" == "disabled" ];
then
  systemctl enable php8.1-fpm
  service php8.1-fpm restart
fi

if [ -f /home/$WSL_USER_NAME/.homestead-features/php81 ]
then
   echo "PHP 8.1 already installed."
   exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/php81
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# PHP 8.1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --allow-change-held-packages \
php8.1 php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-cli php8.1-common php8.1-curl php8.1-dba php8.1-dev \
php8.1-enchant php8.1-fpm php8.1-gd php8.1-gmp php8.1-imap php8.1-interbase php8.1-intl php8.1-ldap \
php8.1-mbstring php8.1-mysql php8.1-odbc php8.1-opcache php8.1-pgsql php8.1-phpdbg php8.1-pspell php8.1-readline \
php8.1-snmp php8.1-soap php8.1-sqlite3 php8.1-sybase php8.1-tidy php8.1-xml php8.1-xsl \
php8.1-zip

# php8.1-xdebug php8.1-xmlrpc php8.1-memcached php8.1-redis

# Configure php.ini for CLI
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/cli/php.ini

# Configure Xdebug
# echo "xdebug.mode = debug" >> /etc/php/8.1/mods-available/xdebug.ini
# echo "xdebug.discover_client_host = true" >> /etc/php/8.1/mods-available/xdebug.ini
# echo "xdebug.client_port = 9003" >> /etc/php/8.1/mods-available/xdebug.ini
# echo "xdebug.max_nesting_level = 512" >> /etc/php/8.1/mods-available/xdebug.ini
# echo "opcache.revalidate_freq = 0" >> /etc/php/8.1/mods-available/opcache.ini

# Configure php.ini for FPM
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.1/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.1/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.1/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/8.1/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.1/fpm/php.ini
printf "[curl]\n" | tee -a /etc/php/8.1/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.1/fpm/php.ini

# Configure FPM
sed -i "s/user = www-data/user = vagrant/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = vagrant/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.1/fpm/pool.d/www.conf

systemctl enable php8.1-fpm
service php8.1-fpm restart
