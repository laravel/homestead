#!/usr/bin/env bash

DB=$1;
# su postgres -c "dropdb $DB --if-exists"
su postgres -c "createdb -O homestead '$DB' || true"
