<p align="center"><img src="https://portal.shineon.com/images/shineon-logo.svg" width="150"></p>

# Homestead

## Introduction

Laravel Homestead is an official, pre-packaged Vagrant box that provides you a wonderful development environment without requiring you to install PHP, a web server, and any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

Homestead runs on any Windows, Mac, or Linux system, and includes the Nginx web server, PHP 7.1, MySQL, Postgres, Redis, Memcached, Node, and all of the other goodies you need to develop amazing Laravel applications.

Official documentation [is located here](http://laravel.com/docs/homestead).

## Changes in this fork.

### Modifications in `/resources` will be scaffolded in "Step 6":

* Install mcrypt
* Dump autoload
* Run migrations
* NPM install

## Abbreviated first-time setup

### Step 1: Some installers

1. [Virtual Box 5.1 or higher](https://www.virtualbox.org/)
1. [Vagrant 1.9 or higher](https://www.vagrantup.com/)

### Step 2: Install composer and gulp globally

```
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/bin
npm install --global gulp-cli
```

### Step 3: Add your ssh key to Github. On your Mac (not in Vagrant)

1. `ssh-keygen`
1. `cat ~/.ssh/id_rsa.pub`
1. Add your new public key to your github.

### Step 4: Pull down the `Seller-Portal` repo.

1. `git clone https://github.com/ShineOnCom/Seller-Portal.git ~/portal.shineon.com`
1. `cd ~/portal.shineon.com`
1. `composer install`
1. `sudo chmod -R 777 storage`
1. `sudo chmod -R 777 bootstrap/cache`
1. You're not done, you still need to setup your vagrant environment.

### Step 5: Pull down the `shopify-app` repo.

1. `git clone https://github.com/ShineOnCom/shopify-app.git ~/fulfillment.shineon.com`
1. `cd ~/fulfillment.shineon.com`
1. `composer install`
1. `sudo chmod -R 777 storage`
1. `sudo chmod -R 777 bootstrap/cache`
1. You're not done, you still need to setup your vagrant environment.

### Step 6: Pull down the ShineOn Homestead repo.

1. `git clone https://github.com/ShineOnCom/homestead.git ~/AppHomestead`
1. `cd ~/AppHomestead`
1. `bash init.sh`
1. Note: 
1. `vagrant up --provision`
1. `vagrant ssh`
1. `cd ~/portal.shineon.com` or `cd ~/fulfillment.shineon.com`

### Step 7: Update your hosts file

  * ##### MAC
    1. `sudo nano /private/etc/hosts`
    1. Add the following:
    1. `local.portal.shineon.com 		192.168.10.10`
    1. `local.fulfillment.shineon.com 	192.168.10.10`

  * ##### LINUX
    1. `sudo nano /etc/hosts`
    1. Add the following:
    1. `192.168.10.10 local.portal.shineon.com`
    1. `192.168.10.10 local.fulfillment.shineon.com`

### Step 8: Add a ENV files.

1. `touch ~/portal.shineon.com/.env`
1. `sudo nano ~/portal.shineon.com/.env`
1. See [wiki](https://github.com/ShineOnCom/Seller-Portal/wiki/ENV)
1. `touch ~/fulfillment.shineon.com/.env`
1. `sudo nano ~/fulfillment.shineon.com/.env`
1. See [wiki](https://github.com/ShineOnCom/shopify-app/wiki/ENV-(local))
1. See [shopify-app](https://github.com/ShineOnCom/shopify-app) "Additional Setup"

```
Ask one of your peers to share this file with you.
```

### Step 9: Test the waters.

1. The last item in the provisioning processed should have been your migrations for Laravel.
1. Visit [local.portal.shineon.com](http://local.portal.shineon.com)
1. Visit [local.fulfillment.shineon.com](http://local.shopify-app.shineon.com)
1. See [shopify-app](https://github.com/ShineOnCom/shopify-app) "Additional Setup"

### Step 10: Test the DB

1. Host: `192.168.10.10`
1. Username: `homestead`
1. Password: `secret`
1. Database: `portal` or `fulfillment`

### Step 11: Test Vagrant SSH

`vagrant ssh`

### Vagrant Ubuntu 16.04 Box Issues

Issue:

```shell
Ubuntu 16.04 - system boot waits saying “Raise network interfaces”
```

Solution:

```shell
Modify /etc/dhcp/dhclient.conf Timeout to 15 
```

Issue:

Vagrant setup of network adapters hangs

Solution:

```shell
Make sure that you have checked "Cable Connected" in Virtualbox Network Configuration (Homestead VM configuration)
````

## Asset compilation

The ShineOn homestead box installs 2 repos, `local.portal.shineon.com` and `local.fulfillment.shineon.com`. 

Portal uses Laravel 5.2, Node 4.~, NPM 2.~, and Gulp for asset compilation, `gulp` to be triggered from your mac. 

Fulfillment uses Laravel 5.4, NPM 6.~, NPM 3.~, and Webpack for asset compilation, `npm run dev` or `npm run watch` after you have `vagrant ssh` into your homestead environment. There is no need install / upgrade Node / NPM. It's recommended you add `--watch-poll` to your `npm run watch` command in your `package.json` file.

Before committing code or submitting pull requests on github, be sure you remember to `npm run production`. This will minify and concatenate assets.

