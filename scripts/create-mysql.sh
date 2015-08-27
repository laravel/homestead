#!/usr/bin/env bash

DB=$1;
USER=$2;
PASS=$3;

mysql -uhomestead -psecret -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";
mysql -uhomestead -psecret -e "GRANT ALL PRIVILEGES ON \`$DB\`.* TO '\`$USER\`'@'localhost' IDENTIFIED BY '\`$PASS\`'; FLUSH PRIVILEGES;";
