<p align="center"><img src="https://laravel.com/assets/img/components/logo-homestead.svg"></p>

<p align="center">
<a href="https://travis-ci.org/laravel/homestead"><img src="https://travis-ci.org/laravel/homestead.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/homestead"><img src="https://poser.pugx.org/laravel/homestead/d/total.svg" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/homestead"><img src="https://poser.pugx.org/laravel/homestead/v/stable.svg" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/homestead"><img src="https://poser.pugx.org/laravel/homestead/license.svg" alt="License"></a>
</p>

## Introduction

Laravel Homestead is an official, pre-packaged Vagrant box that provides you a wonderful development environment without requiring you to install PHP, a web server, and any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

Homestead runs on any Windows, Mac, or Linux system, and includes the Nginx web server, PHP 7.1, MySQL, Postgres, Redis, Memcached, Node, and all of the other goodies you need to develop amazing Laravel applications.

Official documentation [is located here](http://laravel.com/docs/homestead).

## Changes in this fork.

### Post-provision shell script

The `/src/stubs/after.sh` has been modified to switch environment to PHP 5.6. This file is copied to `~/.homestead/` when you run `bash init.sh` and executes when you `vagrant up --provision`.

---

#### Changes in `after.sh`:

* Install mcrypt
* Dump autoload
* Run migrations
* NPM install

### Abbreviated first-time setup for `local.portal.shineon.com`

#### Some installers

1. [Virtual Box 5.1 or higher](https://www.virtualbox.org/)
1. [Vagrant 1.9 or higher](https://www.vagrantup.com/)
1. [NPM, the LTS is fine.](https://nodejs.org/en/)

#### Install composer and gulp globally

```
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/bin
npm install --global gulp-cli
```

#### Add your ssh key to Github. On your Mac (not in Vagrant)

1. `ssh-keygen`
1. `cat ~/.ssh/id_rsa.pub`
1. Add your new public key to your github.

#### Pull down the `Seller-Portal` repo.

1. `git clone https://github.com/ShineOnCom/Seller-Portal.git ~/portal.shineon.com`
1. `cd ~/portal.shineon.com`
1. `composer install`
1. `sudo chmod -R 777 storage`
1. `sudo chmod -R 777 bootstrap/cache`
1. You're not done, you still need to setup your vagrant environment.

#### Pull down the `shopify-app` repo.

1. `git clone https://github.com/ShineOnCom/shopify-app.git ~/shopify-app`
1. `cd ~/shopify-app`
1. `composer install`
1. `sudo chmod -R 777 storage`
1. `sudo chmod -R 777 bootstrap/cache`
1. You're not done, you still need to setup your vagrant environment.

#### Pull down the ShineOn Homestead repo.

1. `git clone https://github.com/ShineOnCom/homestead.git ~/AppHomestead`
1. `cd ~/AppHomestead`
1. `bash init.sh`
1. Note: 
1. `vagrant up --provision`
1. `vagrant ssh`
1. `cd ~/portal.shineon.com` or `cd `~/shopify-app`

#### Update your hosts file

  * ##### MAC
    1. `sudo nano /private/etc/hosts`
    1. Add the following:
    1. `local.portal.shineon.com 		192.168.10.10`
    1. `local.shopify-app.shineon.com 	192.168.10.10`

  * ##### LINUX
    1. `sudo nano /etc/hosts`
    1. Add the following:
    1. `192.168.10.10 local.portal.shineon.com`
    1. `192.168.10.10 local.shopify-app.shineon.com`

#### Add a ENV files.

1. `touch ~/portal.shineon.com/.env`
1. `sudo nano ~/portal.shineon.com/.env`
1. See [wiki](https://github.com/ShineOnCom/Seller-Portal/wiki/ENV)
1. `touch ~/shopify-app/.env`
1. `sudo nano ~/shopify-app/.env`
1. See [wiki](https://github.com/ShineOnCom/shopify-app/wiki/ENV-(local))
1. See [shopify-app](https://github.com/ShineOnCom/shopify-app) "Additional Setup"

```
Ask one of your peers to share this file with you.
```

#### Test the waters.

1. The last item in the provisioning processed should have been your migrations for Laravel.
1. Visit [local.portal.shineon.com](http://local.portal.shineon.com)
1. Visit [local.shopify-app.shineon.com](http://local.shopify-app.shineon.com)
1. See [shopify-app](https://github.com/ShineOnCom/shopify-app) "Additional Setup"

#### Test the DB

1. Host: `192.168.10.10`
1. Username: `homestead`
1. Password: `secret`
1. Database: `shineon` or `shopify-app`

#### Test Vagrant SSH

`vagrant ssh`

#### Vagrant Ubuntu 16.04 Box Issues

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