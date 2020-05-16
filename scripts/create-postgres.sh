#!/usr/bin/env bash

DB=$1;
postgres=$(pidof postgres)

if [ -z "$postgres" ]
then
      # Skip Creating postgres database
      echo "We didn't find a PID for postgres, skipping \$DB creation"
else
    if ! su postgres -c "psql $DB -c '\q' 2>/dev/null"; then
        su postgres -c "createdb -O homestead '$DB'"
    fi
fi
