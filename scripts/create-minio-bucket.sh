#!/usr/bin/env bash

if [[ -d /usr/local/share/minio/$1 ]]; then
    echo "Bucket already exists, skipping..."
    exit
fi

mc mb /usr/local/share/minio/$1
mc anonymous set $2 /usr/local/share/minio/$1
# Minio CLI Makes Buckets Under Root For Some Reason
sudo chown minio-user:minio-user /usr/local/share/minio/*
