# Installation & Use
This section will present how to install and use our custom Homestead development environment. 

***

**Table of Content**

* [Setup](#setup)
  * [Mount Your Codebase in the Virtual Machine](#setup--mount-the-codebase)
  * [Using Homestead from Any Folder](#setup--using-homestead-from-anywhere)
  * [Prepare Configuration](#setup--prepare-configuration)

* [Starting a New Project](#starting-a-new-project)
  * [Add a New Site in Homestead Configuration](#starting-a-new-project--add-a-new-site-in-homestead)
  * [Map the Site in Your Hosts](#starting-a-new-project--map-the-site-in-hosts)

* [Running the Development Environment](#running-the-development-environment)
  * [Provisioning It](#running-the-development-environment--provisioning-the-development-environment)
  * [Running It on a Day to Day Basis](#running-the-development-environment--running-the-development-environment-day-to-day)

***

<a id="setup"></a>
# Setup

First step: Clone this repository:
```bash
git clone git@github.com:Pod-Point/homestead.git /path/to/Homestead/folder
```

And now install dependencies:
```bash
cd /path/to/Homestead/folder
composer install 
```

***Organize the codebase***
 
We suggest you to put all of your cloned repositories in a main folder somewhere such as: `/path/to/my/main-repositories-folder`
This way it will be easier to share all your projects with the virtual machine.

<a id="setup--prepare-configuration"></a>
## Prepare Configuration

The `init` script will need 2 environment variable to setup Homestead configuration properly. If those variables don't
exist, the script will ask you to fill them in.

It is strongly recommended to add the following in your bash profile:

* bash -> `~/.bashrc`
* zsh -> `~/.zshrc`

```bash
export HOMESTEAD_WORKING_DIR=/path/to/my/main-repositories-folder
export HOMESTEAD_VENDOR_DIR=/path/to/Homestead/folder/vendor
```

> ***NOTE: Please put absolute path there.***

> *`/path/to/my/main-repositories-folder` is the folder where you host all of your source code
`/path/to/homestead-folder` is the folder where you cloned this repository.*

After that, remember to `source` the profile file in order to make it available:

```bash
source ~/.bashrc     # or ~/.zshrc
```

<a id="setup--using-homestead-from-anywhere"></a>
## Using Homestead from Any Folder

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
source ~/.bashrc     # or ~/.zshrc
```

Now you can run any vagrant command from any path! For instance: `homestead up` will start the vagrant box.

<a id="starting-a-new-project"></a>
# Starting a New Project

<a id="starting-a-new-project--add-a-new-site-in-homestead"></a>
## Add a New Site in Homestead Configuration

Homestead is using Nginx as a web server to serve files. In order to access your project, you'll have to add a new site in the Homestead configuration file.

Simply update the `sites` key of the `Homestead.yaml` file as follows (replace `<my-repository>` with the repository folder name):

 ```yaml
sites:
    - map: my-great-project.dev
      to: /home/vagrant/code/<my-repository>/public
```

after this change, remember to re-provision the vagrant box (see [Applying a configuration change](#box-provisioning) section) 

<a id="starting-a-new-project--map-the-site-in-hosts"></a>
## Map the Site in Your Hosts

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

> NOTE: You can find the `homesteadIP` value in `VagrantFile` file. Default is `192.168.10.10`.

Now your project is accessible from your host on the following URL: http://my-great-project.dev

<a id="running-the-development-environment"></a>
# Running the Development Environment

<a id="running-the-development-environment--provisioning-the-development-environment"></a>
## Provisioning It 

To re-provision the Virtual Machine (whenever a configuration file changed or a file needs to be re-provisioned in the VM),
just run the following command from the folder where you cloned this repository:

```bash
./init.sh && homestead <up/reload> --provision && homestead ssh
```

<a id="running-the-development-environment--running-the-development-environment-day-to-day"></a>
## Running It on a Day to Day Basis

If no provisioning if needed, just run the following command from anywhere:

```bash
homestead reload && homestead ssh
```
 
 > NOTE: If you changed anything in the `resources` folder, you'll need to run the "first time" command ;)
