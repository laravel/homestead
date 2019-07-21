#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/golang ]
then
    echo "Golang already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/golang
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install Golang

golangVersion="1.12.7"
wget https://dl.google.com/go/go${golangVersion}.linux-amd64.tar.gz -O golang.tar.gz
tar -C /usr/local -xzf golang.tar.gz go
printf "\nPATH=\"/usr/local/go/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile
rm -rf golang.tar.gz
