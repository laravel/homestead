# Vagrant Homestead for Veromo's Platform project

## Requirements
- VirtualBox [5.2.6](https://www.virtualbox.org/wiki/Downloads)
- Vagrant [2.0.2](https://www.vagrantup.com/downloads.html)

## Installation
1. Clone `veromo/homestead`
1. `vagrant up` 
1. Add `192.168.10.10 local.go.veromo.com.au` to your `/etc/hosts`

# Accessing VM
- `vagrant ssh`

## Accessing DB
- 

## Ports
- SSH: 2222 → Forwards To 22
- HTTP: 8000 → Forwards To 80
- HTTPS: 44300 → Forwards To 443
- MySQL: 33060 → Forwards To 3306
