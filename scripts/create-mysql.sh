#!/usr/bin/env bash

DB=$1;
mysql -uhomestead -psecret -e "CREATE DATABASE IF NOT EXISTS $DB";
