# Laravel Homestead

Laravel local development environment with helper scripts.

Official documentation [is located here](http://laravel.com/docs/homestead?version=4.2).

## Additional Functionality

* Provides helper scripts for booting, destroying and editing the homestead environment.
* Sets up firewall rules on OS X to forward port 8000 to 80.
* Automatically adds virtual hosts from Homestead.yaml to /etc/hosts.
* Flushes firewall rules on destroy.
* Removes virtual hosts on destroy.
* Resets virtual hosts and provisions the virtual machine on configuration edit.

## Changes

* Added homestead configuration (Homestead-sample.yaml) as a template.
* Homestead configuration file is now excluded from Git.
* MySQL ports are set to default (3306, 5432).

## Installation

Make sure you have vagrant and virtualbox installed.
Navigate to the path you want the homestead to be installed.
Install as follows:
```
clone https://github.com/miagg/Homestead.git
cd Homestead
vagrant box add laravel/Homstead
```

Add the following aliases to your .bash_profile or .bash_aliases
```
alias vm='ssh vagrant@127.0.0.1 -p 2200'
alias vmup="pushd ~/Homestead >/dev/null && bash vmup.sh && popd >/dev/null"
alias vmdown="pushd ~/Homestead >/dev/null && bash vmdown.sh && popd >/dev/null"
alias vmedit="pushd ~/Homestead >/dev/null && bash vmedit.sh && popd >/dev/null"
```
Change `~/Homestead` to your instasllation path.

## Usage

### vm
SSH into the virtual machine

### vmup
1. Sets firewall rules to forward port 8000 to 80.
2. Adds virtual hosts to /etc/hosts.
3. Boots up homestead.

### vmdown
1. Flushes firewall rules.
2. Removes virtual hosts from /etc/hosts.
3. Destroys the homestead.

### vmedit
1. Opens up Homestead.yaml (configuration file) with the predefined editor (default: sublime)
2. If any changes are detected it resets virtual hosts to /etc/hosts and provisions the machine.

