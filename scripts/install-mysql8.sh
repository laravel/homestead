#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
# Check If MySQL 8 Has Been Installed

if [ -f /home/vagrant/.mysql8 ]
then
    echo "MySQL 8 already installed."
    exit 0
fi

touch /home/vagrant/.mysql8

# Disable Apparmor
## See https://github.com/laravel/homestead/issues/629#issue-247524528

sudo service apparmor stop
sudo service apparmor teardown
sudo update-rc.d -f apparmor remove

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
apt-get update
apt-get install -y mysql-server

# Set The Automated Root Password

debconf-set-selections <<< "mysql-server mysql-server/data-dir select ''"
debconf-set-selections <<< "mysql-server mysql-server/root_password password secret"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password secret"

# Configure MySQL 8 Remote Access
echo "bind-address = 0.0.0.0" | tee -a /etc/mysql/conf.d/mysql.cnf

# Use Native Pluggable Authentication
echo -e "[mysqld]\ndefault_authentication_plugin = mysql_native_password" | tee -a /etc/mysql/conf.d/mysql.cnf
service mysql restart

mysql --user="root" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'%' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'0.0.0.0' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
service mysql restart
