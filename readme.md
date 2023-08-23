<p align="center"><img src="/art/logo.svg"></p>

<p align="center">
    <a href="https://github.com/laravel/homestead/actions">
        <img src="https://github.com/laravel/homestead/workflows/tests/badge.svg" alt="Build Status">
    </a>
    <a href="https://packagist.org/packages/laravel/homestead">
        <img src="https://img.shields.io/packagist/dt/laravel/homestead" alt="Total Downloads">
    </a>
    <a href="https://packagist.org/packages/laravel/homestead">
        <img src="https://img.shields.io/packagist/v/laravel/homestead" alt="Latest Stable Version">
    </a>
    <a href="https://packagist.org/packages/laravel/homestead">
        <img src="https://img.shields.io/packagist/l/laravel/homestead" alt="License">
    </a>
</p>

## Introduction

Laravel Homestead is an official, pre-packaged Vagrant box that provides you a wonderful development environment without requiring you to install PHP, a web server, and any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

Homestead runs on any Windows, Mac, or Linux system, and includes the Nginx web server, PHP 8.2, MySQL, Postgres, Redis, Memcached, Node, and all of the other goodies you need to develop amazing Laravel applications.

Official documentation [is located here](https://laravel.com/docs/homestead).

#### Components

Homestead is made up of 2 different projects. The first is this repo which is the *Homestead application* itself. The application is a wrapper around Vagrant which is an API consumer of a virtualization hypervisor, or provider such as Virtualbox, Hyper-V, VMware, Or Parallels. The second part of Homestead is *Settler*, which is essentially JSON & Bash scripts to turn a minimalistic Ubuntu OS into what we call *Homestead base box*. Homestead and Settler (AKA *Homestead Base / Base Box*) combined give you the Homestead development environment.

> When you run `vagrant up` for the first time Vagrant will download the large base box from Vagrant cloud. The base box is the output from Settler. The base box will be stored at `~/.vagrant.d/` and copied to the folder you ran vagrant up command from in a hidden folder named `.vagrant`. This is what allows vagrant to create a VM and destroy it quickly and without having to download the large base box again.

##### Current versions
| Ubuntu LTS | Settler Version | Homestead Version | Branch      | Status
| -----------|-----------------|-------------------| ----------- | -----------
| 20.04      | 13.x            | 14.x              | `main`      | Development/Unstable
| 20.04      | 13.x            | 14.x              | `release`   | Stable

## Developing Homestead

To keep any in-development changes separate from other Homestead installations, create a new project and install
Homestead from composer, forcing it to use a git checkout.

```
$ mkdir homestead && \
    cd homestead && \
    composer require --prefer-source laravel/homestead:dev-main
```

After it's complete, `vendor/laravel/homestead` will be a git checkout and can be used normally.
