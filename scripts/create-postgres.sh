#!/usr/bin/env bash

DB=$1;
USER=$2;
PASS=$3;

# su postgres -c "dropdb $DB --if-exists"
su postgres -c "createdb -O homestead '$DB' || true"
su postgres -c "create user \"$USER\" with password '$PASS';"
su postgres -c "grant all on schema '$DB' to '$USER';"
