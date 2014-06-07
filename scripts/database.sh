#!/usr/bin/env bash

# variables
name=$1
type=$2

if [[ $type == "MySQL" ]]; then
    mysql -u homestead -psecret -e "CREATE DATABASE IF NOT EXISTS $name;"
fi

if [[ $type == "Postgres" ]]; then
    export PGPASSWORD=secret
    createdb --host 127.0.0.1 --username homestead --no-password $name
    unset PGPASSWORD
fi