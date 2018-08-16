#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
# Check If Maria Has Been Installed

if [ -f /home/vagrant/.maria ]
then
    echo "MariaDB already installed."
    exit 0
fi

touch /home/vagrant/.maria

# Disable Apparmor
# See https://github.com/laravel/homestead/issues/629#issue-247524528

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

# Add Maria PPA

sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.osuosl.org/pub/mariadb/repo/10.3/ubuntu bionic main'
apt-get update

# Set The Automated Root Password

export DEBIAN_FRONTEND=noninteractive

debconf-set-selections <<< "mariadb-server-10.3 mysql-server/data-dir select ''"
debconf-set-selections <<< "mariadb-server-10.3 mysql-server/root_password password secret"
debconf-set-selections <<< "mariadb-server-10.3 mysql-server/root_password_again password secret"

# Install MariaDB

apt-get install -y mariadb-server-10.3

# Configure Maria Remote Access

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
service mysql restart

mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
service mysql restart
