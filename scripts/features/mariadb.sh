#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/mariadb ]
then
    echo "MariaDB already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/mariadb
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Disable Apparmor
# See https://github.com/laravel/homestead/issues/629#issue-247524528
service apparmor stop
update-rc.d -f apparmor remove

# Remove MySQL
apt-get -o Dpkg::Options::="--force-confnew" remove -y --purge mysql-server mysql-client
apt-get autoremove -y
apt-get autoclean

rm -rf /var/lib/mysql/*
rm -rf /var/log/mysql
rm -rf /etc/mysql

# Add Maria PPA
curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

debconf-set-selections <<< "mariadb-server mysql-server/data-dir select ''"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password secret"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password secret"
mkdir  /etc/mysql
touch /etc/mysql/debian.cnf

# Install MariaDB
apt-get -o Dpkg::Options::="--force-confnew" install -y mariadb-server mariadb-client mysql-common

# Configure Maria Remote Access and ignore db dirs
sed -i "s/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
cat > /etc/mysql/mariadb.conf.d/50-server.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
ignore-db-dir = lost+found
#general_log
#general_log_file=/var/log/mysql/mariadb.log
EOF

export MYSQL_PWD=secret

mysql --user="root" --password="secret" -h localhost -e "GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -h localhost -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
service mysql restart

mysql --user="root" --password="secret" -h localhost -e "CREATE USER IF NOT EXISTS 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -h localhost -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -h localhost -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -h localhost -e "FLUSH PRIVILEGES;"
service mysql restart

mysql_upgrade --user="root" --verbose --force
service mysql restart

unset MYSQL_PWD
