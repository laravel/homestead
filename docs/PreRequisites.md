# PreRequisites
This section will present general knowledge and tools to have before diving into Homestead installation & use. 

***

**Table of Content**

* [What is It?](#what-is-it)

* [Guest Vs Host](#guest-vs-host)

* [Needed Tools](#needed-tools)
  * [PHP Version](#needed-tools--php-version)
    * [Install Homebrew](#needed-tools--php-version--install-homebrew)
    * [Install PHP 7.1](#needed-tools--php-version--install-php71)
    * [Check](#needed-tools--php-version--check)

* [How Does It Work?](#how-does-it-work)

  * [Provisioning](#provisioning)
  
  * [`after.sh` Script](#after-script)

***

<a id="what-is-it"></a>
# What is It?

The official documentation says:
> Laravel Homestead is an official, pre-packaged Vagrant box that provides you a wonderful development environment without requiring you to install PHP, a web server, and any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

The official Homestead documentation is available here [https://laravel.com/docs/5.4/homestead](https://laravel.com/docs/5.4/homestead)

<a id="guest-vs-host"></a>
# Guest Vs Host

* a **Host** is hosting virtual machines (guests). It is basically your computer.

* a **Guest** is virtual machine (VM) running on your computer.

<a id="needed-tools"></a>
# Needed Tools

In order to run Homestead, you will need to have the following installed on your host machine:

* VirtualBox: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

* Vagrant: [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

* Have PHP7+ installed on your machine

* Some coffee ;)

<a id="needed-tools--php-version"></a>
## Upgrading PHP Version
Some of our needed dependencies will need PHP7+, so make sure you have PHP7 installed on your machine.

```bash
php -v
```

Sample output:
```text
PHP 7.1.5 (cli) (built: May 13 2017 13:30:32) ( NTS )
Copyright (c) 1997-2017 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2017 Zend Technologies
```

If you don't have it, simply upgrade your version as described below.

<a id="needed-tools--php-version--install-homebrew"></a>
### Install Homebrew
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

<a id="needed-tools--php-version--install-php7"></a>
### Install PHP 7.1
```bash
brew update && brew upgrade
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
brew unlink php56
brew install php71
```

<a id="needed-tools--php-version--check"></a>
### Check

The output of `php -v` should now echo the version 7.

<a id="how-does-it-work"></a>
# How Does It Work?

<a id="provisioning"></a>
## Provisioning

All the files in the `resources/custom` folder will be provisioned in `/tmp` in the VM.
If you need to move them somewhere else, you'll need to update `resources/after.sh` script.

<a id="after-script"></a>
## `After.sh` Script

This script runs just after the VM is up and running. This is where we:
* Install missing dependencies
* Install other packages
* Manipulate custom provisioned files
* and more!
