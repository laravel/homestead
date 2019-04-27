#!/usr/bin/env bash

# Install docker-ce
curl -fsSL https://get.docker.com | bash -s

# Enable vagrant user to run docker commands
usermod -aG docker vagrant
