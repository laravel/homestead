#!/usr/bin/env bash

# Check If MySQL 8 Has Been Installed
if [[ -f /home/vagrant/.homestead-features/mysql8 ]]; then
    echo "MySQL 8 already installed."
    exit 0
fi

export DEBIAN_FRONTEND=noninteractive

touch /home/vagrant/.homestead-features/mysql8
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Disable Apparmor
## See https://github.com/laravel/homestead/issues/629#issue-247524528
service apparmor stop
service apparmor teardown
update-rc.d -f apparmor remove

# Remove MySQL
apt-get remove -y --purge mysql-server mysql-client mysql-common
apt-get autoremove -y
apt-get autoclean

rm -rf /var/lib/mysql
rm -rf /var/log/mysql
rm -rf /etc/mysql

# Add MySQL PPA
wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
dpkg -i mysql-apt-config_0.8.12-1_all.deb
sed -i 's/mysql-5.7/mysql-8.0/g' /etc/apt/sources.list.d/mysql.list
rm -rf mysql-apt-config_0.8.12-1_all.deb
apt-key adv --keyserver keys.gnupg.net --recv-keys 8C718D3B5072E1F5
apt-get update

# Set The Automated Root Password
debconf-set-selections <<< "mysql-server mysql-server/data-dir select ''"
debconf-set-selections <<< "mysql-server mysql-server/root_password password secret"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password secret"

# Install MySQL 8
apt-get install -y mysql-server

# Configure MySQL 8 Remote Access and Native Pluggable Authentication
cat > /etc/mysql/conf.d/mysqld.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
default_authentication_plugin = mysql_native_password
EOF

service mysql restart

export MYSQL_PWD=secret

mysql --user="root" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
mysql --user="root" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" -e "CREATE USER 'homestead'@'%' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'0.0.0.0' WITH GRANT OPTION;"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' WITH GRANT OPTION;"
mysql --user="root" -e "FLUSH PRIVILEGES;"
service mysql restart

unset MYSQL_PWD
unset DEBIAN_FRONTEND
