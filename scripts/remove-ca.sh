#!/usr/bin/env bash
#

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
PATH_CA_SHARE="../.ca"

cd $SCRIPTPATH/$PATH_CA_SHARE

for ca in `ls *.crt`
do
    if hash trust 2>/dev/null
    then
        sudo trust anchor --remove ./$ca
        echo "Removed CA: $ca"
    fi
done