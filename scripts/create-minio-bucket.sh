#!/usr/bin/env bash

mc mb /usr/local/share/minio/$1
mc policy set $2 /usr/local/share/minio/$1
