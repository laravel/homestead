#!/usr/bin/env bash


# musicbed homestead files

if [ ! -d ~/Homestead/musicbed ]; then
	echo "Generating musicbed homestead files"

	mkdir ~/Homestead/musicbed

	if [ ! -f ~/Homestead/musicbed/Homestead.json ]; then
		echo "Generating Homestead.json file"
		cp -i resources/musicbed/Homestead.json musicbed/Homestead.json
	fi

	if [ ! -f ~/Homestead/musicbed/after.sh ]; then
		echo "Generating after.sh file"
		cp -i resources/musicbed/after.sh musicbed/after.sh
	fi

	if [ ! -f ~/Homestead/musicbed/aliases ]; then
		echo "Generating aliases file"
		cp -i resources/musicbed/aliases musicbed/aliases
	fi
fi


# Start cloning repositories and adding .env to each repo


echo "Starting Musicbed Repository cloning"
if [ ! -d ~/Code/musicbed/musicbed ]; then
    mkdir -p ~/Code/musicbed/musicbed
	git clone https://github.com/musicbed/musicbed.git ~/Code/musicbed/musicbed
fi

if [ ! -f ~/Code/musicbed/musicbed/.env ]; then
	echo "Adding .env to musicbed"
	curl -o ~/Code/musicbed/musicbed/.env https://s3.amazonaws.com/mb-engineering-onboarding/musicbed/.env
	if grep -q "AccessDenied" ~/Code/musicbed/musicbed/.env; then
		echo "File not downloaded. Access Denied. Please make sure you are connected to VPN."
		echo "Cleaning up..."
		rm -f ~/Code/musicbed/musicbed/.env
		exit 1
	fi
fi

if [ ! -d ~/Code/musicbed/musicbed-api ]; then
	mkdir -p ~/Code/musicbed/musicbed-api
	git clone https://github.com/musicbed/musicbed-api.git ~/Code/musicbed/musicbed-api
fi

if [ ! -f ~/Code/musicbed/musicbed-api/.env ]; then
	echo "Adding .env to musicbed-api"
	curl -o ~/Code/musicbed/musicbed-api/.env https://s3.amazonaws.com/mb-engineering-onboarding/musicbed-api/.env
	if grep -q "AccessDenied" ~/Code/musicbed/musicbed-api/.env; then
		echo "File not downloaded. Access Denied. Please make sure you are connected to VPN."
		echo "Cleaning up..."
		rm -f ~/Code/musicbed/musicbed-api/.env
		exit 1
	fi
fi


if [ ! -d ~/Code/musicbed/musicbed-www ]; then
	mkdir -p ~/Code/musicbed/musicbed-www
	git clone https://github.com/musicbed/musicbed-www.git ~/Code/musicbed/musicbed-www
fi

if [ ! -f ~/Code/musicbed/musicbed-www/.env ]; then
	echo "Adding .env to musicbed-www"
	curl -o ~/Code/musicbed/musicbed-www/.env https://s3.amazonaws.com/mb-engineering-onboarding/www/.env
	if grep -q "AccessDenied" ~/Code/musicbed/musicbed-www/.env; then
		echo "File not downloaded. Access Denied. Please make sure you are connected to VPN."
		echo "Cleaning up..."
		rm -f ~/Code/musicbed/musicbed-www/.env
		exit 1
	fi
fi

read -p "Have you ran yarn on musicbed-www? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	cd ~/Code/musicbed/musicbed-www
	yarn
	cd ~/Homestead
fi

if [ ! -d ~/Code/musicbed/sabre ]; then
	mkdir -p ~/Code/musicbed/sabre
	git clone https://github.com/musicbed/sabre.git ~/Code/musicbed/sabre
fi

if [ ! -f ~/Code/musicbed/sabre/.env ]; then
	echo "Adding .env to sabre"
	curl -o ~/Code/musicbed/sabre/.env https://s3.amazonaws.com/mb-engineering-onboarding/sabre/.env
	if grep -q "AccessDenied" ~/Code/musicbed/sabre/.env; then
		echo "File not downloaded. Access Denied. Please make sure you are connected to VPN."
		echo "Cleaning up..."
		rm -f ~/Code/musicbed/sabre/.env
		exit 1
	fi
fi