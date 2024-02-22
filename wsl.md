<p align="center"><img src="/art/logo.svg" alt="Laravel Homestead Logo"></p>

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

Welcome to the _"Initial Draft"_ documentation for using Homestead to provision WSL Distro for your local Laravel development.

#### Requirements

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

##### Installing Homestead:
Login to your WSL Distro e.g. Ubuntu-22.04, and clone the Homestead repository into your Windows host. The recommended folder location to install Homestead is `/home/<username>/homestead`.

```bash
git clone https://github.com/laravel/homestead.git ~/Homestead
```
<!-- TODO: Will be required to do init.sh in future, leaving the doc here for now
Next, navigate to the Homestead directory and run the bash init.sh command. This will generate the Homestead.yaml configuration file, where you can customize all the settings for your Homestead installation. The Homestead.yaml file will be created in the Homestead directory.
```bash
cd ~/Homestead
bash init.sh
```
-->
Next, navigate to the Homestead directory. You need to run all wsl provisioning commands from inside ~/Homestead folder (relative paths from other directories won't work).
```bash
cd ~/Homestead
```

> To access `Homestead.yaml` file from Windows go to `\\wsl$\Ubuntu-22.04\home\<username>\Homestead` folder

##### Provision Homestead on WSL Distro:
```
cd ~/homestead
sudo ./bin/wsl-init.sh
```
This will prompt you for the WSL username and the user's group name. Provide the username that you selected at the time of distro installation, and provide the user's group name (generally the same as the username).

<!-- TODO: Will try thi in future
Alternatively, you can add a new configuration section **wsl:** in Homestead.yaml file as following before running the above command.

```
wsl:
    - user_name: vagrant
      user_group: vagrant
```
-->

This process will take several minutes to provision your WSL Distro, so grab a cup of coffee and relax. This step needs to be done only once.

##### Installing Optional Features:

After enabling optional features in the **features:** configuration in Homestead.yaml, run the following command to install those features.

Refer Laravel Homestead official documentation to get more information about [Configuring Optional Features](https://laravel.com/docs/master/homestead#installing-optional-features).

```bash
cd ~/homestead
sudo ./bin/homestead wsl:features
```

##### Installing databases:

If you want to automatically create databases, add the **databases:** configuration in Homestead.yaml.

```yaml
databases:
    - homestead
    - myoltpdb
    - myolapdb
```

After adding the databases, run the following command to create them in the installed MySQL or MariaDB.

```bash
cd ~/homestead
sudo ./bin/homestead wsl:databases
```

##### Configuring Nginx Sites:

To add websites in Nginx, update the website details in the **sites:** configuration section in Homestead.yaml.
```
sites:
    - map: homestead.test
      to: /home/vagrant/project1/public
```

Now, run the following command to configure these websites in Nginx on WSL. You can run this command every time you want to add new sites.
For more information about [Configuring Nginx Sites](https://laravel.com/docs/master/homestead#configuring-nginx-sites), refer to the Laravel Homestead official documentation.
```
cd ~/homestead
sudo ./bin/homestead wsl:sites
```

> Please be aware that executing the aforementioned command will result in the removal of all existing Nginx configurations. Any manual adjustments made to the configurations will be removed.

##### Configuring Shared Folders:

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
cd ~/homestead
sudo ./bin/homestead wsl:folders
```

You can use this method to share your code between the Windows host and WSL distro. However, note that it may not be the most performant option, as WSL2 uses the 9P (Plan9 protocol) to share files from Windows to WSL2 Distro. Nevertheless, this approach ensures that your code folder remains intact in Windows even if something happens to the WSL2 Distro.

###### Using \\wsl$ network path for shared folder
An alternative to the above folder sharing method is to utilize the \\wsl$ network path.

`\\wsl$` is a special network path used in the Windows Subsystem for Linux (WSL) to access the Linux file system from within Windows.

This method offers a way more efficient (_we are talking about 1000 times faster page loads_) to share your code folder between WSL2 distro and the Windows host. Websites hosted on the WSL file system perform significantly faster than those on a shared folder.

You can create a code directory in `/home/<wsl_username>/project1` in the WSL Distro, and it will be accessible in Windows at `\\wsl$\Ubuntu-20.04\home\<wsl_username>\project1`.

>WARNING: Please note that using this method to share your code files in the \\wsl$\Ubuntu-20.04\home\<wsl_username>\project1 folder will result in data loss if the distro is uninstalled for any reason.

