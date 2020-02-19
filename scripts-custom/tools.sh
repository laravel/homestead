#!/bin/sh

echo 'Installing required tooling...'

export DEBIAN_FRONTEND=noninteractive
apt-get -yq install git tmux vim curl wget zip unzip htop nano build-essential
