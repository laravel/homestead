#!/usr/bin/env bash

influx bucket create --token="homestead_secret" --name="$1" --org="homestead"
