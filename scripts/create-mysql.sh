#!/usr/bin/env bash

cat > /home/vagrant/.my.cnf << EOF
[client]
user = homestead
password = secret
host = localhost
EOF

DB=$1;

mysql --connect-expired-password -e "SET PASSWORD = PASSWORD('secret');";
mysql --connect-expired-password -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";
