#!/usr/bin/env bash

mongo $1 --eval "db.test.insert({name:'db creation'})"
