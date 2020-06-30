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
service apparmor stop
service apparmor teardown
update-rc.d -f apparmor remove

# Remove MySQL
apt-get remove -y --purge mysql-server mysql-client mysql-common
apt-get autoremove -y
apt-get autoclean

rm -rf /var/log/mysql
rm -rf /etc/mysql

# Add Maria PPA
curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

# Set The Automated Root Password
debconf-set-selections <<< "mariadb-server mysql-server/data-dir select ''"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password secret"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password secret"

# Install MariaDB
apt-get install -y mariadb-server mariadb-client

# Configure Maria Remote Access and ignore db dirs
sed -i "s/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

cat > /etc/mysql/mariadb.conf.d/50-server.cnf << EOF
[mysqld]
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
