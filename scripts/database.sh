#!/usr/bin/env bash

# variables
name=$1
type=$2

if [[ $type == "MySQL" ]]; then
    mysql -u root -psecret -e "CREATE DATABASE IF NOT EXISTS $name;"
fi

if [[ $type == "Postgres" ]]; then
    echo 'implement Postgress'
fi