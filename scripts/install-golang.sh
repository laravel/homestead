#!/usr/bin/env bash

# Install Golang

golangVersion="1.12.4"
wget https://dl.google.com/go/go${golangVersion}.linux-amd64.tar.gz -O golang.tar.gz
tar -C /usr/local -xzf golang.tar.gz go
printf "\nPATH=\"/usr/local/go/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile
rm -rf golang.tar.gz
