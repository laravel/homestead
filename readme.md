# Laravel Homestead

The official Laravel local development environment.

Official documentation [is located here](http://laravel.com/docs/homestead?version=4.2).

## Creating Databases

Add a databases configuration in the Homestead.yaml file to create multiple databases.

```
---
ip: "192.168.10.10"
memory: 2048
cpus: 1

authorize: ~/.ssh/id_rsa.pub

keys:
    - ~/.ssh/id_rsa

folders:
    - map: ~/Code
      to: /home/vagrant/Code

sites:
    - map: homestead.app
      to: /home/vagrant/Code/Laravel/public
    - map: homesteadtwo.app
      to: /home/vagrant/Code/Laraveltwo/public

databases:
    - name: homesteadtwo

variables:
    - key: APP_ENV
      value: local

```
