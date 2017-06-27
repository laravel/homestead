<p align="center"><img src="https://laravel.com/assets/img/components/logo-homestead.svg"></p>

<p align="center">
<a href="https://travis-ci.org/laravel/homestead"><img src="https://travis-ci.org/laravel/homestead.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/homestead"><img src="https://poser.pugx.org/laravel/homestead/d/total.svg" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/homestead"><img src="https://poser.pugx.org/laravel/homestead/v/stable.svg" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/homestead"><img src="https://poser.pugx.org/laravel/homestead/license.svg" alt="License"></a>
</p>

# Homestead guide

## What is it?

The official documentation says:
> Laravel Homestead is an official, pre-packaged Vagrant box that provides you a wonderful development environment without requiring you to install PHP, a web server, and any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

The official Homestead documentation is available here [https://laravel.com/docs/5.4/homestead](https://laravel.com/docs/5.4/homestead)

## Guest Vs Host

* a **Host** is hosting virtual machines (guests). It is basically your computer.

* a **Guest** is virtual machine (VM) running on your computer.

## Prerequisites

In order to run Homestead, you will need to have the following installed on your host machine:

* VirtualBox: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

* Vagrant: [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

* Some coffee ;)

## How does it work?

### Provisioning

All the files in the `resources/custom` folder will be provisioned in `/tmp` in the VM.
If you need to move them somewhere else, you'll need to update `resources/after.sh` script.

### `After.sh` script

This script runs just after the VM is up and running. This is where we:
* Install missing dependencies
* Install other packages
* Manipulate custom provisioned files
* ...

## Installation

### Main Homestead setup

First step: Clone this repository.

***Organize the codebase***
 
We suggest you to put all of your cloned repositories in a main folder somewhere such as: `~/path/to/my/main-repositories-folder`
This way it will be easier to share all your projects with the virtual machine.

#### Share your code with the Virtual Machine

Using a main folder for all your POD Point repositories allows you to map all your projects in one go by updating `resources/Homestead.yaml` file, changing `folders.map` to your folder hosting your code:
```yaml
folders:
    - map: ~/path/to/my/main-repositories-folder
      to: /home/vagrant/code
      type: "nfs"
```

This way, a repository called `my-great-project` will be accessible under `/home/vagrant/code/my-great-project` in the VM.
The NFS mount will allow you to update files from both guest and host sides.

## Start the work on a new project

### Adding a site in Homestead configuration

Homestead is using Nginx as a web server to serve files. In order to access your project, you'll have to add a new site in the Homestead configuration file.

Simply update the `sites` key of the `Homestead.yaml` file as follows (replace `<my-repository>` with the repository folder name):

 ```yaml
sites:
    - map: my-great-project.dev
      to: /home/vagrant/code/<my-repository>/public
```

after this change, remember to re-provision the vagrant box (see [Applying a configuration change](#box-provisioning) section) 

### Accessing it from the host

Now we need to plug our host to the guest's IP to link a development DNS to the one served by Homestead.
So open the hosts file:

```bash
sudo vim /etc/hosts
```

and now add the needed map (where `<homesteadIP>` is the virtual machine's IP address. By default it is set to `192.168.10.10`):

```bash
##
# Homestead
#
<homesteadIP>  my-great-project.dev
```

> NOTE: You can find the `homesteadIP` value in VagrantFile file.

Now your project is accessible from your host on the following URL: http://my-great-project.dev

## Running the development environment

### Provisioning it 

To re-provision the Virtual Machine (whenever a configuration file changed or a file needs to be re-provisioned in the VM),
just run the following command from the folder where you cloned this repository:

```bash
./init.sh && homestead <up/reload> --provision && homestead ssh
```

### Running it on a day to day basis

If no provisioning if needed, just run the following command from anywhere:

```bash
homestead reload && homestead ssh
```
 
 > NOTE: If you changed anything in the `resources` folder, you'll need to run the "first time" command ;)

## Some nice stuff

### Using Homestead from any folder

Add the following script to your bash profile (or any other one you're using). For instance:

* bash -> `~/.bashrc`
* zsh -> `~/.zshrc`


```bash
function homestead() {
    ( cd /path/to/Homestead/folder && vagrant $* )
}
```

> NOTE: `/path/to/Homestead/folder` is the folder where you cloned this repository.

After that, remember to `source` the profile file in order to make it available:

```bash
source ~/.bashrc
```

Now you can run any vagrant command from any path! For instance: `homestead up` will start the vagrant box.

## Reminder

### Starting the Guest box

You can start vagrant box by issuing the following command:
`homestead up`

### Connecting to the Guest box

You can connect to the vagrant box by issuing the following command:
`homestead ssh`

### Applying a configuration change <a id="box-provisioning"></a>

Always re-provision you vagrant box in order to apply configuration changes.
`homestead reload --provision`

### Database credentials
 
Homestead default credentials are as follows:

* host: `127.0.0.1`
* user: `homestead`
* password: `secret`

## Our stack

TODO

## Troubleshooting

### 

If you see something like:
```text
A VirtualBox machine with the name '<someName>' already exists.
Please use another name or delete the machine with the existing name, and try again.
```

then you'll need to destroy your previous homestead box before running this one.
