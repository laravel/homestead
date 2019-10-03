#!/usr/bin/env bash

# Check if vagrant box has been added, if not, prompot user to add

read -p "Run vagrant box add? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "adding vagrant box laravel/homestead"
	vagrant box add laravel/homestead
fi