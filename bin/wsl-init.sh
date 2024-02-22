#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo "Changing current working directory to Homestead directory..."
cd "$(dirname "$0")/.."
echo "Script is now running in ${pwd}"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."

    exit 1
fi

UNAME=$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed 's/\"//g')
if [[ "$UNAME" != "Ubuntu" ]]; then
    echo "WSL Homestead only supports Ubuntu 20.04 and 22.04."

    exit 1
fi

if [[ -f /root/.homestead-provisioned ]]; then
    echo "This server has already been provisioned by Laravel Homestead."
    echo "If you need to re-provision, you may remove the /root/.homestead-provisioned file and try again."

    exit 1
fi

echo "What is your WSL user name? [vagrant]"
read WSL_USER_NAME

echo "What is your WSL user group? (Same as username if you're unsure) [vagrant]"
read WSL_USER_GROUP

# Set default
if [ -z "${WSL_USER_NAME}" ]; then
    WSL_USER_NAME=vagrant
fi
if [ -z "${WSL_USER_GROUP}" ]; then
    WSL_USER_GROUP=vagrant
fi

# Validate user and group
if ! id "$WSL_USER_NAME" &>/dev/null; then
    echo "User $WSL_USER_NAME does not exist."

    exit 1
fi
if ! getent group "$WSL_USER_GROUP" &>/dev/null; then
    echo "Group $WSL_USER_GROUP does not exist."

    exit 1
fi
if ! groups "$WSL_USER_NAME" | grep -q "\b$WSL_USER_GROUP\b"; then
    echo "User $WSL_USER_NAME is not a member of group $WSL_USER_GROUP."

    exit 1
fi

# Configure feature tracking path
mkdir -p ~/.homestead-features
echo $WSL_USER_NAME > ~/.homestead-features/wsl_user_name
echo $WSL_USER_GROUP > ~/.homestead-features/wsl_user_group

# Update Package List
apt-get update

# Update System Packages
apt-get upgrade -y

# Install software to deal with keyrings for PPAs
apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https \
ca-certificates

# Install Some PPAs
apt-add-repository ppa:ondrej/php -y

# Prepare keyrings directory
sudo mkdir -p /etc/apt/keyrings

# NodeJS
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_21.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Update Package Lists
apt-get update -y

# Install Some Basic Packages
apt-get install -y build-essential dos2unix gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony unzip make pv \
python3-pip re2c supervisor unattended-upgrades whois vim cifs-utils bash-completion zsh graphviz avahi-daemon tshark

# Install Generic PHP packages
apt-get install -y --allow-change-held-packages \
php-imagick php-memcached php-redis php-xdebug php-dev imagemagick mcrypt php-swoole

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
sed -i "s/user = www-data/user = ${WSL_USER_NAME}/" /etc/php/8.3/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = ${WSL_USER_GROUP}/" /etc/php/8.3/fpm/pool.d/www.conf
sed -i "s/listen\.owner.*/listen.owner = ${WSL_USER_NAME}/" /etc/php/8.3/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = ${WSL_USER_GROUP}/" /etc/php/8.3/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.3/fpm/pool.d/www.conf

# Disable XDebug On The CLI
phpdismod -s cli xdebug

touch /home/${WSL_USER_NAME}/.homestead-features/php83


# set default php to latest
update-alternatives --set php /usr/bin/php8.3
update-alternatives --set php-config /usr/bin/php-config8.3
update-alternatives --set phpize /usr/bin/phpize8.3

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
mkdir -p /home/${WSL_USER_NAME}/.config
chown -R ${WSL_USER_NAME}:${WSL_USER_GROUP} /home/${WSL_USER_NAME}/.config

# Add Composer Global Bin To Path
printf "\nPATH=\"$(sudo su - ${WSL_USER_NAME} -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/${WSL_USER_NAME}/.profile

# Install Global Packages
sudo su ${WSL_USER_NAME} <<EOF
/usr/local/bin/composer global require "laravel/envoy=^2.0"
/usr/local/bin/composer global require "laravel/installer=^5.0"
/usr/local/bin/composer global config --no-plugins allow-plugins.slince/composer-registry-manager true
/usr/local/bin/composer global require "slince/composer-registry-manager=^2.0"
EOF

# Install Nginx
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages nginx

rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

# Create a configuration file for Nginx overrides.
mkdir -p /home/${WSL_USER_NAME}/.config/nginx
chown -R ${WSL_USER_NAME}:${WSL_USER_GROUP} /home/${WSL_USER_NAME}
touch /home/${WSL_USER_NAME}/.config/nginx/nginx.conf
ln -sf /home/${WSL_USER_NAME}/.config/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

# Set The Nginx & PHP-FPM User
sed -i "s/user www-data;/user ${WSL_USER_NAME};/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf
sed -i "s/sendfile on;/sendfile on; client_max_body_size 100M;/" /etc/nginx/nginx.conf

# Apply configuration changes, Restart Nginx and PHP FPM
nginx -t
service nginx restart
service php8.3-fpm restart

# Add ${WSL_USER_NAME} User To WWW-Data
usermod -a -G www-data ${WSL_USER_NAME}
id ${WSL_USER_NAME}
groups ${WSL_USER_GROUP}

# Install Node
apt-get install -y nodejs
/usr/bin/npm install -g npm

# Install SQLite
apt-get install -y sqlite3 libsqlite3-dev

# Install MySQL
echo "mysql-server mysql-server/root_password password secret" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password secret" | debconf-set-selections
apt-get install -y mysql-server

# Configure MySQL 8 Remote Access and Native Pluggable Authentication
cat > /etc/mysql/conf.d/mysqld.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
disable_log_bin
default_authentication_plugin = mysql_native_password
EOF

# Configure MySQL Password Lifetime
echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Configure MySQL Remote Access
sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

export MYSQL_PWD=secret

mysql --user="root" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
mysql --user="root" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" -e "CREATE USER 'homestead'@'%' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'0.0.0.0' WITH GRANT OPTION;"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' WITH GRANT OPTION;"
mysql --user="root" -e "FLUSH PRIVILEGES;"
mysql --user="root" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"

sudo tee /home/${WSL_USER_NAME}/.my.cnf <<EOL
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_bin
EOL

service mysql restart

touch /home/${WSL_USER_NAME}/.homestead-features/mysql

# Install Redis, Memcached
apt-get install -y redis-server memcached
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
systemctl enable redis-server
service redis-server start

# Configure Supervisor
systemctl enable supervisor.service
service supervisor start

# Update / Override motd
echo "export ENABLED=1"| tee -a /etc/default/motd-news
sed -i "s/motd.ubuntu.com/homestead.joeferguson.me/g" /etc/update-motd.d/50-motd-news
sed -i "s/motd.ubuntu.com/homestead.joeferguson.me/g" /etc/default/motd-news
rm -rf /var/cache/motd-news
rm -rf /etc/update-motd.d/10-help-text
rm -rf /etc/update-motd.d/50-landscape-sysinfo
rm -rf /etc/update-motd.d/99-bento
service motd-news restart
bash /etc/update-motd.d/50-motd-news --force

# One last upgrade check
apt-get upgrade -y

# Fix permissions
chown -R ${WSL_USER_NAME}:${WSL_USER_GROUP} /home/${WSL_USER_NAME}
chown -R ${WSL_USER_NAME}:${WSL_USER_GROUP} /usr/local/bin

# Perform some cleanup from chef/bento packer_templates/ubuntu/scripts/cleanup.sh
# Delete Linux source
dpkg --list \
| awk '{ print $2 }' \
| grep linux-source \
| xargs apt-get -y purge;

# delete docs packages
dpkg --list \
| awk '{ print $2 }' \
| grep -- '-doc$' \
| xargs apt-get -y purge;

# Delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf

# Delete oddities
apt-get -y purge popularity-contest command-not-found friendly-recovery laptop-detect

# Clean Up
apt-get -y autoremove;
apt-get -y clean;

# Remove docs
rm -rf /usr/share/doc/*

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;
# What are you doing Ubuntu?
# https://askubuntu.com/questions/1250974/user-root-cant-write-to-file-in-tmp-owned-by-someone-else-in-20-04-but-can-in
sysctl fs.protected_regular=0

# Enable Swap Memory
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

# Setup Homestead repo
su $WSL_USER_NAME -c 'composer install'
su $WSL_USER_NAME -c 'bash init.sh'

# Mark wsl homestead provisioning completed
touch /root/.homestead-provisioned

# Copy aliases to $WSL_UER_NAME
cp ./resources/aliases /home/${WSL_USER_NAME}/.bash_aliases && chown ${WSL_USER_NAME}:${WSL_USER_GROUP} /home/${WSL_USER_NAME}/.bash_aliases && source /home/${WSL_USER_NAME}/.bash_aliases

# Copy ssl root certificate to Homestead folder for installing it in windows certificate store easily
cp /etc/ssl/certs/ca.homestead.*.crt .
