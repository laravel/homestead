#!/usr/bin/env bash

# Check If MySQL 8 Has Been Installed
if [[ -f /home/vagrant/.homestead-features/mysql8 ]]; then
    echo "MySQL 8 already installed."
    exit 0
fi

export DEBIAN_FRONTEND=noninteractive

touch /home/vagrant/.homestead-features/mysql8
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Remove MySQL
apt-get remove -y --purge mysql-server mysql-client mysql-common
apt-get autoremove -y
apt-get autoclean

rm -rf /homestead-vg/master/*
rm -rf /var/log/mysql
rm -rf /etc/mysql

# Add MySQL PPA
wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb
dpkg -i mysql-apt-config_0.8.14-1_all.deb
rm -rf mysql-apt-config_0.8.14-1_all.deb
apt-get update

# Set The Automated Root Password
debconf-set-selections <<< "mysql-server mysql-server/data-dir select ''"
debconf-set-selections <<< "mysql-server mysql-server/root_password password secret"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password secret"

echo '/homestead-vg/ r,' >> /etc/apparmor.d/local/usr.sbin.mysqld
echo '/homestead-vg/** rwk,' >> /etc/apparmor.d/local/usr.sbin.mysqld
systemctl restart apparmor

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
