#!/usr/bin/env bash

cat > /home/vagrant/.my.cnf << EOF
[client]
user = homestead
password = secret
host = localhost
EOF

DB=$1;

mysql --user="root" --password="secret" -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";
