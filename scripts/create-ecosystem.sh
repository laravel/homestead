#!/usr/bin/env bash

mkdir /home/vagrant/ecosystem 2>/dev/null

PATH_ECOSYSTEM="/home/vagrant/ecosystem"

rm -rf /home/vagrant/ecosystem/*

PATH_JSON="${PATH_ECOSYSTEM}/${1}.json"

# variables
# 1 = name
# 2 = script
# 3 = args
# 4 = path

BASE_ECO='
{
  "name": "'$1'",
  "script": "'$2'",
  "args": "'$3'",
  "cwd": "'$4'"
}
'

# Only generate a ecosystem if there isn't one already there.
if [ ! -f $PATH_JSON ]
then
    echo "$BASE_ECO" > $PATH_JSON
fi
