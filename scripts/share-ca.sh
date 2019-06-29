#!/usr/bin/env bash
#

PATH_SSL="/etc/nginx/ssl"
PATH_CA_SHARE="/vagrant/.ca"

# Path to the custom Homestead $(hostname) Root CA certificate.
PATH_ROOT_CNF="${PATH_SSL}/ca.homestead.$(hostname).cnf"
PATH_ROOT_CRT="${PATH_SSL}/ca.homestead.$(hostname).crt"
PATH_ROOT_KEY="${PATH_SSL}/ca.homestead.$(hostname).key"

if [ -d "$PATH_SSL" ]
then
    if [ ! -d "PATH_CA_SHARE" ]
    then
        mkdir $PATH_CA_SHARE 2>/dev/null
    fi
    rm -rf "$PATH_CA_SHARE/*"

    cp -p $PATH_ROOT_CRT $PATH_CA_SHARE
    cp -p $PATH_ROOT_KEY $PATH_CA_SHARE
    cp -p $PATH_ROOT_CNF $PATH_CA_SHARE
fi