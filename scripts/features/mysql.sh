#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/mysql ]; then
    echo "Mysql already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/mysql
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Stop MariDB service
service mariadb stop
# Remove old PPA
rm -f /etc/apt/sources.list.d/mariadb.list*
# Remove MariaDB
apt-get -o Dpkg::Options::="--force-confnew" remove -y --purge mariadb-server mariadb-client  mysql-common
apt-get autoremove -y
apt-get autoclean

rm -rf /var/lib/mysql/*
rm -rf /var/log/mysql
rm -rf /etc/mysql
rm -r /home/$WSL_USER_NAME/.homestead-features/mariadb

# Install MySQL
echo "mysql-server mysql-server/root_password password secret" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password secret" | debconf-set-selections
apt-get install -y mysql-server

# Configure MySQL 8 Remote Access and Native Pluggable Authentication
mkdir -p /etc/mysql/conf.d
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

unset MYSQL_PWD