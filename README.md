# Vagrant Homestead for `veromo/platform`

## Requirements on local development machine
- VirtualBox [5.2.6](https://www.virtualbox.org/wiki/Downloads)
- Vagrant [2.0.2](https://www.vagrantup.com/downloads.html)
- Composer [^1.6.3](https://getcomposer.org/download/) installed [globally](https://getcomposer.org/doc/00-intro.md#globally)
- PHP [7.1](http://php.net/manual/en/install.php)

## Setup
Assuming a common development folder, ie: 
```bash
cd ~/www/veromo
```

Clone `platform` and `homestead` as sibling folders:
```bash
git clone git@github.com:Veromo/platform.git
git clone git@github.com:Veromo/homestead.git
```

### Configure `platform`:
```bash
cd ~/www/veromo/platform
```

Install git submodules:
```bash
git submodule init
git submodule update
```

Add [personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) for private Github dependencies:
```bash
bash auth.sh
```

Install dependencies:
```bash
composer install
```

### Configure `homestead`:
```bash
cd ~/www/veromo/homestead
```

Launch VM:
```bash
vagrant up
```

Prepare database
```bash
vagrant ssh
cd /var/veromo
php app/console doctrine:schema:update --force

# Provision demo data:
php app/console veromo:schema:provision
php app/console veromo:batch:testaccounts
php app/console veromo:batch:testdata
```

### Ready!
- Add `192.168.10.10 local.go.veromo.com.au` to your `/etc/hosts`
- Open https://local.go.veromo.com.au/
- Rejoice!

### Notes:
- Windows users you may need to enable hardware virtualisation (VT-x). This may be in your BIOS settings.
- If errors occur during provisioning, fix and run `vagrant provision`
- To avoid permission problems, use `composer` from your host machine and not from within the vagrant vm.

## Adminimiser front-end
Once logged in to the platform you will be redirected to the Adminimiser frontend.
To set up the front end follow the Readme on [veromo/adminimiser](https://github.com/Veromo/adminimiser)

## Ports mapped: Client VM -> Host
- SSH: 2222 -> Forwards To 22
- HTTP: 8000 -> Forwards To 80
- HTTPS: 44300 -> Forwards To 443
- MySQL: 33060 -> Forwards To 3306

## Todo
- Add notes on reprovisioning and using both `vagrant provision` and `vagrant reload --provision`
- Add notes on connecting MySQL Workbench
