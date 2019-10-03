#!/usr/bin/env bash

## Prompts to make sure virtual box, vagrant and vpn are installed
read -p "Have you downloaded VirtualBox? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Please download VirtualBox first. https://www.virtualbox.org/wiki/Downloads"
    exit 1
fi

read -p "Have you downloaded Vagrant? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Please download Vagrant first. https://www.vagrantup.com/downloads.html"
    exit 1
fi

read -p "Are you connected to the musicbed VPN? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Please connect to the vpn first. https://tunnelblick.net/index.html"
    exit 1
fi