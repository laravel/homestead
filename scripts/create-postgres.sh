#!/usr/bin/env bash

DB=$1;
# su postgres -c "dropdb $DB --if-exists"

if ! su postgres -c "psql $DB -c '\q' 2>/dev/null"; then
    su postgres -c "createdb -O homestead '$DB'"
fi
