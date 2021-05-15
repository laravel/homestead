#!/usr/bin/env bash

mc mb /usr/local/share/minio/$1
mc policy set $2 /usr/local/share/minio/$1
# Minio CLI Makes Buckets Under Root For Some Reason
sudo chown minio-user:minio-user /usr/local/share/minio/*
