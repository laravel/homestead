#!/usr/bin/env bash

mongosh $1 --eval "db.test.insertOne({name:'db creation'})"
