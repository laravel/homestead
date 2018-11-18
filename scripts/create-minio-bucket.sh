#!/usr/bin/env bash

mc mb homestead/$1
mc policy $2 homestead/$1
