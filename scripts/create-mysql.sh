#!/usr/bin/env bash

cat > /root/.my.cnf << EOF
[client]
user = homestead
password = secret
host = localhost
EOF

cp /root/.my.cnf /home/vagrant/.my.cnf

DB=$1;

mysql=$(pidof mysqld)
mariadb=$(pidof mariadbd)

if [ -z "$mysql" ]
then
      # Skip Creating MySQL database
      echo "We didn't find a PID for mysqld, skipping \$DB creation"
else
      mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
fi

if [ -z "$mariadb" ]
then
      # Skip Creating MariaDB database
      echo "We didn't find a PID for mariadb, skipping \$DB creation"
else
      mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
fi
