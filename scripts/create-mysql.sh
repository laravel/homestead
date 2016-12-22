#!/usr/bin/env bash

cat > /home/vagrant/.my.cnf << EOF
[client]
user = homestead
password = secret
host = localhost
EOF

DB=$1;

mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET UTF8mb4 DEFAULT COLLATE utf8mb4_bin";
