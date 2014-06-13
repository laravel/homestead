#!/usr/bin/env bash
echo ">>> Creating MySQL Database $1"
mysql -u root -p$4 -e "CREATE DATABASE $1"
mysql -u root -p$4 -e "CREATE USER '$2'@'localhost' IDENTIFIED BY '$3'"
mysql -u root -p$4 -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, ALTER, DROP, CREATE TEMPORARY TABLES, LOCK TABLES ON $1.* TO '$2'@'localhost'"
mysql -u root -p$4 -e "FLUSH PRIVILEGES"
