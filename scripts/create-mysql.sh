#!/usr/bin/env bash

DB=$1;
mysql -uhomestead -psecret -e "DROP DATABASE IF EXISTS $DB";
mysql -uhomestead -psecret -e "CREATE DATABASE $DB";
