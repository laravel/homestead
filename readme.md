# Vagrant

My Vagrantfile for development bliss.

- Ubuntu 14.04
- PHP 5.5
- Nginx
- MySQL
- Postgres
- Node (With Grunt & Gulp)
- Redis
- Memcached
- Beanstalkd
- Fabric + HipChat Extension (Python)

Setup for easily hosting multiple projects on various Nginx sites.

## Setup

1. Install VirtualBox & Vagrant
2. `vagrant box add laravel/homestead`
3. Clone this repository into a directory.
4. Configure SSH key, shared folders, and Nginx sites in `Homestead.yaml`.
6. Run `vagrant up` from that directory.

## Ports

- SSH: 2222
- HTTP: 8000
- MySQL: 33060
- Postgres: 54320

## Adding More Nginx Sites

If you want to add a new Nginx site without re-provisioning the entire site, SSH into the Vagrant box and run the following command:

```
serve foo.app /home/vagrant/Code/site/public
```

This command will configure the new Nginx site and restart Nginx. You will still need to add the `foo.app` entry to the `/etc/hosts` file on your host machine. On Windows, this file is located at `C:\Windows\System32\drivers\etc\hosts`.

## Notes

MySQL / Postgres user is `vagrant` and password is `secret`.
