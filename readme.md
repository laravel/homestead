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

## Getting started

First and only step: Clone this repository.

Update `rsources/Homestead.yaml` file, changing `folders.map` to your folder hosting your code:
```yaml
folders:
    - map: ~/Documents/Development/pod-point
      to: /home/vagrant/code
      type: "nfs"
```

**Running it for the first time**

To start the Virtual Machine, just run the following command from the folder where you cloned this repository:

```bash
./init.sh && homestead <up/reload> --provision && homestead ssh
```

**Running it on a day to day basis**

To start the Virtual Machine, just run the following command from anywhere:

```bash
homestead reload && homestead ssh
```

> NOTE: If you changed anything in the `resources` folder, you'll need to run the "first time" command ;) 

Enjoy!

## Our stack

TODO
