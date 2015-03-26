#!/usr/bin/env bash

sudo -u postgres createuser --superuser vagrant
sudo -u postgres psql -dtemplate1 -c "create database vagrant"

/usr/local/bin/composer config -g repositories.setupfocus vcs https://git.focus-sis.com/matthewa/setupfocus.git
/usr/local/bin/composer global require 'focus/setupfocus=dev-homestead'

#copy focus-common over


#copy phantom

#copy the index file
