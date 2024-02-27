<p align="center"><img src="/art/logo.svg" alt="Laravel Homestead Logo"></p>

<p align="center"><span style="font-size: 24px; font-weight: bold;"> WSL - Windows Subsystem for Linux </span></p>


- [Introduction](#introduction)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Installing Homestead](#installing-homestead)
  - [Provision Homestead on WSL Distro](#provision-homestead-on-wsl-distro)
  - [Installing Optional Features](#installing-optional-features)
  - [Installing Databases](#installing-databases)
  - [Configuring Nginx Sites](#configuring-nginx-sites)
  - [Configuring Shared Folders](#configuring-shared-folders)
    - [WSL network path for sharing folders](#wsl-network-path-for-sharing-folders)
- [Aliases](#aliases)
- [Applications and Features](#applications-and-features)
  -  [Included Software](#included-software)
  -  [Optional Software](#optional-software)


## Introduction

Welcome to the _"Initial Draft"_ documentation for using Homestead to provision WSL Distro for your local Laravel development.

## Requirements

**WSL Version**: WSL2

Homestead for WSL is currently tested only with WSL version 2 (WSL2), though it can also work with WSL version 1.

**WSL Distro**: Ubuntu 20.04 or Ubuntu 22.04

Ensure that you have either Ubuntu 20.04 or Ubuntu 22.04 distributions installed. Homestead only supports these two distributions.

To verify open a Powershell Terminal and use following command:

```powershell
> wsl -l -v

  NAME            STATE           VERSION
* Ubuntu          Running         2
* Ubuntu-20.04    Running         2
```
The **'NAME'** column represents the distribution name, and the **'VERSION'** column identifies the WSL version.


If you don't have any distribution installed, use the following command to list all available WSL distributions:
```powershell
> wsl -l --online
The following is a list of valid distributions that can be installed.
Install using 'wsl.exe --install <Distro>'.

NAME                                   FRIENDLY NAME
Ubuntu                                 Ubuntu
Debian                                 Debian GNU/Linux
kali-linux                             Kali Linux Rolling
Ubuntu-18.04                           Ubuntu 18.04 LTS
Ubuntu-20.04                           Ubuntu 20.04 LTS
Ubuntu-22.04                           Ubuntu 22.04 LTS
...
```

To install a distribution, use the following command:
```powershell
> wsl --install Ubuntu-22.04
```

After finishing up the download and/or installation of the distro, it will ask for username and password.
Can give any username but recommend using __vagrant__ (_vagrant_ is default user created while using Homestead with other Providers)

To remove a distribution from WSL, use the following command:
```powershell
> wsl --unregister Ubuntu-22.04
```

## Installation

### Installing Homestead
Login to your WSL Distro e.g. Ubuntu-22.04, and clone the Homestead repository into your Windows host. The recommended folder location to install Homestead is `/home/<wsl_username>/Homestead`.

```bash
git clone https://github.com/laravel/homestead.git ~/Homestead
```

Next, navigate to the Homestead directory. You need to run all wsl provisioning commands from inside ~/Homestead folder (relative paths from other directories won't work).
```bash
cd ~/Homestead
```

> To access `Homestead.yaml` file from Windows go to `\\wsl$\Ubuntu-22.04\home\<wsl_username>\Homestead` folder.

### Provision Homestead on WSL Distro
```
cd ~/Homestead
sudo ./bin/wsl-init.sh
```
This will prompt you for the WSL username and the user's group name. Provide the username that you selected at the time of distro installation, and provide the user's group name (generally the same as the username).

```
wsl:
    - user_name: vagrant
      user_group: vagrant
```
-->

This process will take several minutes to provision your WSL Distro, so grab a cup of coffee and relax. This step needs to be done only once.

### Installing Optional Features

After enabling optional features in the **features:** configuration in Homestead.yaml, run the following command to install those features.

Refer Laravel Homestead official documentation to get more information about [Installing Optional Features](https://laravel.com/docs/homestead#installing-optional-features).

```bash
cd ~/Homestead
sudo ./bin/homestead wsl:features
```

### Installing Databases

If you want to automatically create databases, add the **databases:** configuration in Homestead.yaml.

```yaml
databases:
    - homestead
    - myoltpdb
    - myolapdb
```

After adding the databases, run the following command to create them in the installed MySQL or MariaDB.

```bash
cd ~/Homestead
sudo ./bin/homestead wsl:databases
```

### Configuring Nginx Sites

To add websites in Nginx, update the website details in the **sites:** configuration section in Homestead.yaml.
```
sites:
    - map: homestead.test
      to: /home/vagrant/project1/public
```

Now, run the following command to configure these websites in Nginx on WSL. You can run this command every time you want to add new sites.
For more information about [Configuring Nginx Sites](https://laravel.com/docs/master/homestead#configuring-nginx-sites), refer to the Laravel Homestead official documentation.
```
cd ~/Homestead
sudo ./bin/homestead wsl:sites
```

> Please be aware that executing the aforementioned command will result in the removal of all existing Nginx configurations. Any manual adjustments made to the configurations will be removed.

### Configuring Shared Folders

The **folders:** property of the Homestead.yaml file lists all the folders you wish to share with your WSL distro from Windows Host.

Refer Homestead official documentation to get more information about [Configuring Shared Folders](https://laravel.com/docs/master/homestead#configuring-shared-folders).

```
folders:
    - map: /mnt/c/code/project1
      to: /home/vagrant/code/project1
    - map: /mnt/c/code/project2
      to: /home/vagrant/code/project2
```
Once the mapping is provided, run the following command to configure symbolic links in the WSL Distro. Run this command every time you want to update the mapping.
```
cd ~/Homestead
sudo ./bin/homestead wsl:folders
```

You can use this method to share your code between the Windows host and WSL distro. However, note that it may not be the most performant option, as WSL2 uses the 9P (Plan9 protocol) to share files from Windows to WSL2 Distro. Nevertheless, this approach ensures that your code folder remains intact in Windows even if something happens to the WSL2 Distro.

#### WSL network path for shared folder
An alternative method for sharing folders between Windows and the Windows Subsystem for Linux (WSL) is to use the `\\wsl$` network path.

`\\wsl$` is a special network path used in the Windows Subsystem for Linux (WSL) to access the Linux file system from within Windows. By typing `\\wsl$` in the address bar of Windows Explorer, you can view the WSL Distributions and their file systems directly.

This method provides a convenient way to interact with files and directories in your WSL Distro from the familiar Windows Explorer interface. It allows you to seamlessly transfer files between Windows and your WSL environment with ease. 

Now you can have your code in Linux file system and that way your web application loading is way more efficient, this method significantly improves page load times, making them up to nearly 1000 times faster compared to storing files in a Windows directory and accessing them from WSL.

You can create a code directory in `/home/<wsl_username>/project1` in the WSL Distro, and it will be accessible in Windows at `\\wsl$\Ubuntu-22.04\home\<wsl_username>\project1`. You can open the code from this location in your favorite IDE.

>WARNING: Please note that using this method to share your code files in the \\wsl$\Ubuntu-20.04\home\<wsl_username>\project1 folder will result in data loss if the distro is uninstalled for any reason.

## Aliases
After completing the WSL Init process, all the aliases available in Homestead will remain accessible. However, to immediately use these aliases after wsl init, you'll need to execute `source /home/vagrant/.bash_aliases`. Additionally, you can append custom aliases directly to the `/home/vagrant/.bash_aliases` file. Remember to source the .bash_aliases file after any modifications to apply changes to the current session. Otherwise, changes will take effect only after logging out and logging back in.

## Applications and Features

Currently, not all application features mentioned in the Laravel Homestead documentation are available in the WSL installation. To prevent overloading WSL Distros, we have streamlined the default software inclusion. However, we will provide the missed software as optional features, allowing users to install them based on their requirements.

### Included Software
The following software features are installed by default with wsl-init:
- Git
- PHP 8.3
- Nginx
- MySQL 8.0
- Sqlite3
- Composer
- Node (Without Yarn, Bower, Grunt, and Gulp)
- Redis
- Memcached
- avahi
- Xdebug

Following softwares are not installed in WSL by default unlike Homestead Vagrant install, but few of these can be installed as optional feature
- PHP 8.2
- PHP 8.1
- PHP 8.0
- PHP 7.4
- PHP 7.3
- PHP 7.2
- PHP 7.1
- PHP 7.0
- PHP 5.6
- PostgreSQL 15
- Beanstalkd *
- Docker *
- Mailpit *
- ngrok *
- XHProf / Tideways / XHGui *
- wp-cli *
- lmm *
- Apache *

* - (Not available as optional feature, need to install manually)

### Optional Software
The following software features can be installed as optional features using the wsl:features command after updating the Homestead.yaml file:
- Blackfire
- Cassandra
- Chronograf
- CouchDB
- Crystal & Lucky Framework
- DragonflyDB
- Elasticsearch
- EventStoreDB
- Flyway
- Gearman
- GoLang
- Grafana
- Heroku
- InfluxDB
- Logstash
- MariaDB
- Meilisearch
- MinIO
- MongoDB
- Neo4j
- Oh My Zsh
- Open Resty
- PM2
- Python
- R
- RabbitMQ
- Rust
- RVM (Ruby Version Manager)
- Solr
- TimescaleDB
- Trader (PHP extension)
- Webdriver & Laravel Dusk Utilities
- PHP 8.2
- PHP 8.1
- PHP 8.0
- PHP 7.4
- PHP 7.3
- PHP 7.2
- PHP 7.1
- PHP 7.0
- PHP 5.6
- PostgreSQL 15

## Upcoming features
1. Our next primary goal is to ensure that all software available by default in Homestead Vagrant and not available as feature in Homestead WSL is accessible as optional features for installation later through wsl:features.
- Beanstalkd *
- Docker *
- Mailpit *
- ngrok *
- XHProf / Tideways / XHGui *
- wp-cli *
- lmm *
- Apache *

 2. To be able to configure schedule:run cron job from Homestead.yaml file