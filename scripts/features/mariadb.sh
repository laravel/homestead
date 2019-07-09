#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
# Check If Maria Has Been Installed

if [ -f /home/vagrant/.homestead-features/mariadb ]
then
    echo "MariaDB already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/mariadb
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Disable Apparmor
# See https://github.com/laravel/homestead/issues/629#issue-247524528

sudo service apparmor stop
sudo service apparmor teardown
sudo update-rc.d -f apparmor remove

# Remove MySQL

apt-get remove -y --purge mysql-server mysql-client mysql-common
apt-get autoremove -y
apt-get autoclean

rm -rf /var/log/mysql
rm -rf /etc/mysql

# Add Maria PPA

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,ppc64el] http://ftp.osuosl.org/pub/mariadb/repo/10.4/ubuntu bionic main'
apt-get update

# Set The Automated Root Password

export DEBIAN_FRONTEND=noninteractive

debconf-set-selections <<< "mariadb-server mysql-server/data-dir select ''"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password secret"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password secret"

# Install MariaDB

apt-get install -y mariadb-server

# Configure Maria Remote Access and ignore db dirs
cat > /etc/mysql/conf.d/mysql.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
ignore-db-dir = lost+found
EOF

export MYSQL_PWD=secret

mysql --user="root" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
service mysql restart

mysql --user="root" -e "CREATE USER IF NOT EXISTS 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" -e "FLUSH PRIVILEGES;"
service mysql restart

mysql_upgrade --user="root" --verbose --force
service mysql restart

unset MYSQL_PWD
