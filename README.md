Veromo Homestead
===

For local development of the [platform](https://github.com/Veromo/platform) project

## Requirements
- Local [platform](https://github.com/Veromo/platform) project installed 
- Optionally, local [adminimiser](https://github.com/Veromo/adminimiser) project installed 
- VirtualBox [5.2.6](https://www.virtualbox.org/wiki/Downloads)
- Vagrant [2.0.2](https://www.vagrantup.com/downloads.html)
- Git [^2.16.1](https://git-scm.com/downloads) (with Git Bash installed on Windows machines)
- SSH key [configured](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)

## Setup
```bash
git clone git@github.com:Veromo/homestead.git
```

Initialise Homestead.yaml:
```bash
bash init.sh
```
Check the SSH keys and folder paths are correct. `platform` is expected at `../platform` by default.

Launch VM:
```bash
vagrant up
```

SSH into VM and provision database:
```bash
vagrant ssh
cd /var/veromo

# Compile assets to speed up VM
php app/console assetic:dump

# Execute the platform Database Provisioning commands
...
```
- See [platform database provisioning commands](https://github.com/Veromo/platform#database-provisioning)



Finally:
- Add `192.168.10.10 local.go.veromo.com.au` to your `/etc/hosts`
- Open https://local.go.veromo.com.au/

### Notes:
- Windows users you may need to enable hardware virtualisation (VT-x). This may be in your BIOS settings.
- If errors occur during provisioning, fix and run `vagrant provision`
- To avoid permission problems, use `composer` from your host machine and not from within the vagrant vm.
- Authenticated sessions will redirect to `local.adminimiser.veromo.com.au:3000` expecting the [adminimiser](https://github.com/Veromo/adminimiser) project running
- `vagrant halt` to stop VM
- `vagrant destroy` to delete VM image

## Connecting to MYSQL database
To connect MYSQL Workbench:
1. New Standard TCP/IP connection
1. Hostname `192.168.10.10`
1. Port `3306`
1. Username `homestead`
1. Password `secret`

## Ports mapped: Client VM -> Host
- SSH: 2222 -> Forwards To 22
- HTTP: 8000 -> Forwards To 80
- HTTPS: 44300 -> Forwards To 443
- MySQL: 33060 -> Forwards To 3306
