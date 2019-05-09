#!/usr/bin/env bash

# Remove any Homestead entries from /etc/hosts and prepare for adding new ones.

sudo sed -i '/#### HOMESTEAD-SITES-BEGIN/,/#### HOMESTEAD-SITES-END/d' /etc/hosts

printf "#### HOMESTEAD-SITES-BEGIN\n#### HOMESTEAD-SITES-END" | sudo tee -a /etc/hosts > /dev/null
