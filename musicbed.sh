#!/usr/bin/env bash


## Prompts to make sure virtual box, vagrant and vpn are installed
read -p "Have you downloaded VirtualBox? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Please download VirtualBox first. https://www.virtualbox.org/wiki/Downloads"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

read -p "Have you downloaded Vagrant? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Please download Vagrant first. https://www.vagrantup.com/downloads.html"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

read -p "Are you connected to the musicbed VPN? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Please connect to the vpn first. https://tunnelblick.net/index.html"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi


# Database import
read -p "Do you need a database import? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
	. db.sh
fi

# Add homestead related files since bash.sh is no longer a thing

if [ ! -f ~/Homestead/Homestead.json ]; then
	echo "Generating Homestead.json file"
	cp -i resources/Homestead.json Homestead.json
fi

if [ ! -f ~/Homestead/after.sh ]; then
	echo "Generating after.sh file"
	cp -i resources/after.sh after.sh
fi

if [ ! -f ~/Homestead/aliases ]; then
	echo "Generating aliases file"
	cp -i resources/aliases aliases
fi

# Check if vagrant box has been added, if not, prompot user to add

read -p "Run vagrant box add? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "adding vagrant box laravel/homestead"
	vagrant box add laravel/homestead
fi

# Start cloning repositories and adding .env to each repo


echo "Starting Repository cloning"
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
		[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
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
		[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
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
		[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
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
		[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
	fi
fi

# add sites to /etc/hosts

if ! grep -q "# Musicbed" "/etc/hosts"; then
	echo "Adding sites to /etc/hosts"
  	echo -e '\n\n##\n# Musicbed\n#' | sudo tee -a /etc/hosts > /dev/null
fi

if ! grep -q "127.0.0.1   musicbed.test" "/etc/hosts"; then
	echo '127.0.0.1   musicbed.test' | sudo tee -a /etc/hosts > /dev/null
fi

if ! grep -q "10.1.1.33   api3.musicbed.test" "/etc/hosts"; then
	echo '10.1.1.33   api3.musicbed.test' | sudo tee -a /etc/hosts > /dev/null
fi


if ! grep -q "10.1.1.33   admin.musicbed.test" "/etc/hosts"; then
	echo '10.1.1.33   admin.musicbed.test' | sudo tee -a /etc/hosts > /dev/null
fi

if ! grep -q "10.1.1.33   sabre.test" "/etc/hosts"; then
	echo '10.1.1.33   sabre.test' | sudo tee -a /etc/hosts > /dev/null
fi

vagrant up

echo "Musicbed Homestead initialized!"