#!/usr/bin/env bash

read -p "Do you need a Musicbed database import? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "Adding mysqldump.sql.gz to ~/Homestead"
	curl -o ~/Homestead/mysqldump.sql.gz https://s3.amazonaws.com/mb-engineering-onboarding/musicbed/mysqldump.sql.gz

	if grep -q "AccessDenied" ~/Homestead/mysqldump.sql.gz; then
		echo "File not downloaded. Access Denied. Please make sure you are connected to VPN."
		echo "Cleaning up..."
		rm -f ~/Homestead/mysqldump.sql.gz
		exit 1
	fi
fi