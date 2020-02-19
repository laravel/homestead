#!/bin/sh

echo 'Installing Node.js 10.x...'

apt -y remove --purge nodejs

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt-get install -y nodejs

sudo apt-get update

DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" install -yq yarn
