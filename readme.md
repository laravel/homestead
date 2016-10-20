# Laravel Homestead

The official Laravel local development environment.

Official documentation [is located here](http://laravel.com/docs/homestead).

## Changes in this fork.

### Post-provision shell script

The `/src/stubs/after.sh` has been modified to switch environment to PHP 5.6. This file is copied to `~/.homestead/` when you run `bash init.sh` and executes when you `vagrant up --provision`.

---

#### *ShineOn* Changes in `after.sh`:

* Switch environment from PHP 7.0 to PHP 5.6 (when production has been updated, we can switch this back)
* ~~Load balancer setup similar to production~~
* ~~Https setup similar to production~~
* Memcached setup
* Dump autoload file for composer
* Run migrations
* NPM install

### Abbreviated first-time setup for `local.portal.shineon.com`

#### Some installers

1. [Virtual Box](https://www.virtualbox.org/)
1. [Vagrant](https://www.vagrantup.com/)
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

#### Pull down the Seller Portal repo.

1. `git clone https://github.com/ShineOnCom/Seller-Portal.git ~/portal.shineon.com`
1. `cd ~/portal.shineon.com`
1. `composer install`
1. `sudo chmod -R 777 storage`
1. `sudo chmod -R 777 bootstrap/cache`
1. You're not done, you still need to setup your vagrant environment.

#### Pull down the ShineOn Homestead repo.

1. `git clone https://github.com/ShineOnCom/homestead.git ~/ShineOnHomestead`
1. `cd ~/ShineOnHomestead`
1. `bash init.sh`
1. Note: if you need to tweak your environment. There will now be files in `~/.homestead`. Just be aware whatever you change has to play nice with the `after.sh` script.
1. `vagrant up --provision`
1. `vagrant ssh`
1. `cd ~/portal.shineon.com`
1. `php artisan migrate`
1. `npm install`

#### Update your hosts file

1. `sudo nano /private/etc/hosts`
1. Add the following:
1. `local.portal.shineon.com 		192.168.10.10`

#### Add a ENV file.

1. `touch ~/portal.shineon.com/.env`
1. `sudo nano ~/portal.shineon.com/.env`
1. See [wiki](https://github.com/ShineOnCom/Seller-Portal/wiki/ENV)

```
Ask one of your peers to share this file with you.
```

#### Test the waters.

1. The last item in the provisioning processed should have been your migrations for Laravel.
1. Visit [local.portal.shineon.com](http://local.portal.shineon.com)

#### Test the DB

1. Host: 192.168.10.10
1. Username: homestead
1. Password: secret
1. Database: shineon

#### Test Vagrant SSH

`vagrant ssh`