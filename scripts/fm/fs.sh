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