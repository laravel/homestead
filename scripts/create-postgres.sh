#!/usr/bin/env bash

DB=$1;
su postgres -c "dropdb homestead --if-exists"
su postgres -c "createdb -O homestead '$DB'"
