#!/usr/bin/env bash

# filmsupply homestead files

if [ ! -d ~/Homestead/filmsupply ]; then
	echo "Generating filmsupply homestead files"

	mkdir ~/Homestead/filmsupply

	if [ ! -f ~/Homestead/filmsupply/Homestead.json ]; then
		echo "Generating Homestead.json file"
		cp -i resources/filmsupply/Homestead.json filmsupply/Homestead.json
	fi

	if [ ! -f ~/Homestead/filmsupply/after.sh ]; then
		echo "Generating after.sh file"
		cp -i resources/filmsupply/after.sh filmsupply/after.sh
	fi

	if [ ! -f ~/Homestead/filmsupply/aliases ]; then
		echo "Generating aliases file"
		cp -i resources/filmsupply/aliases filmsupply/aliases
	fi
fi

echo "Starting Filmsupply Repository cloning"

if [ ! -d ~/Code/musicbed/filmsupply ]; then
    mkdir -p ~/Code/musicbed/filmsupply
	git clone https://github.com/musicbed/filmsupply.git ~/Code/musicbed/filmsupply
fi

if [ ! -f ~/Code/musicbed/filmsupply/.env ]; then
	echo "Adding .env to filmsupply"
	curl -o ~/Code/musicbed/filmsupply/.env https://s3.amazonaws.com/mb-engineering-onboarding/filmsupply/.env
	if grep -q "AccessDenied" ~/Code/musicbed/filmsupply/.env; then
		echo "File not downloaded. Access Denied. Please make sure you are connected to VPN."
		echo "Cleaning up..."
		rm -f ~/Code/musicbed/filmsupply/.env
		exit 1
	fi
fi

read -p "Have you ran yarn on filmsupply? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	cd ~/Code/musicbed/filmsupply
	yarn
	cd ~/Homestead
fi

read -p "Have you ran yarn gulp imagemin on filmsupply? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	cd ~/Code/musicbed/musicbed-www
	yarn gulp imagemin
	cd ~/Homestead
fi