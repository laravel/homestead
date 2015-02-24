#!/usr/bin/env bash

DB=$1;

mysql -uhomestead -psecret -e "DROP DATABASE IF EXISTS \`$DB\`";
mysql -uhomestead -psecret -e "CREATE DATABASE \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";
