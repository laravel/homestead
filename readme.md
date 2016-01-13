# Laravel Homestead

The official Laravel local development environment.

Official documentation [is located here](http://laravel.com/docs/homestead).

## ChangeLog

### 2016-01-13 -- added Apache support via Homestead configuration

Enable Apache2 by setting `src:Apache2` in `~/.homestead/Homestead.yaml`  
This will stop NginX, install Apache and configure the virtualhosts  
Just have to configure your local `/etc/hosts` file 