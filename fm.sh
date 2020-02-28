#!/usr/bin/env bash


echo "Starting F+M Homestead initialization!"

# Prompt user to make sure pre-setup steps are completed
. ./scripts/fm/checks.sh

# Musicbed homestead, repo cloning, and .env
. ./scripts/fm/mb.sh

# Filmsupply homestead, repo cloning, and .env
. ./scripts/fm/fs.sh

# Add vagrant prompt
. ./scripts/fm/vagrant.sh

# Database Import Prompt
. ./scripts/fm/db.sh

# Add sites to hosts
. ./scripts/fm/hosts.sh

echo "F+M Homestead initialized!"