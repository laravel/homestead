#!/usr/bin/env bash

# post homestead files

if [ ! -d ~/Homestead/post ]; then
	echo "Generating post homestead files"

	mkdir ~/Homestead/post

	if [ ! -f ~/Homestead/post/Homestead.json ]; then
		echo "Generating Homestead.json file"
		cp -i resources/post/Homestead.json post/Homestead.json
	fi

	if [ ! -f ~/Homestead/post/after.sh ]; then
		echo "Generating after.sh file"
		cp -i resources/post/after.sh post/after.sh
	fi

	if [ ! -f ~/Homestead/post/aliases ]; then
		echo "Generating aliases file"
		cp -i resources/post/aliases post/aliases
	fi
fi

echo "Starting Post Repository cloning"

if [ ! -d ~/Code/musicbed/post-api-admin ]; then
    mkdir -p ~/Code/musicbed/post-api-admin
	git clone https://github.com/musicbed/post-api-admin.git ~/Code/musicbed/post-api-admin
fi

if [ ! -d ~/Code/musicbed/post ]; then
    mkdir -p ~/Code/musicbed/post
	git clone https://github.com/musicbed/post.git ~/Code/musicbed/post
fi