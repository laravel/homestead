# Laravel Homestead (with OCI8 support)

This is a fork of Laravel's Homestead Vagrant box, adding support for OCI8 so PHP can connect to Oracle databases.

## Installation

Because Oracle require you to set up an Oracle account and agree to a licence agreement before you can download the necessary files (Oracle Instant Client), we can't include them by default in the Vagrant box.

**You must get these files and place them in the `/files` directory before creating the machine (i.e. running `vagrant up`).**

However, it's easy enough:
- Browse to [Oracle's Instant Client Download page](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html)
- Accept the Licence Agreement (top of page)
- Search for the files below in turn and click to download. After logging in/creating an account, the files should download.
  - `oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm`
  - `oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm`
  - `oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm`
- Place  all three files in the `/files` directory inside this repository.
- Once done, run `vagrant up` on the command line. This will create the PHP with OCI8 development environment (plus all the goodies included in Laravel's Homestead).

## Usage

In your Laravel project, you will need to add the [Oracle DB driver package here](https://github.com/yajra/laravel-oci8). You should then have `'oracle'` available as a database driver.

Once done, you should add the following database connection details (fill in the username/password/character set as appropriate) to the file `config/database.php` (Laravel 5) or `app/config/database.php` (Laravel 4):

```php
'oracle' => array(
    'driver' => 'oracle',
    'host' => 'oracle.11.2',
    'port' => '1521',
    'database' => 'xe',
    'username' => <username>,
    'password' => <password>,
    'charset' => <charset>, # e.g. 'AL32UTF8'
    'prefix' => '',
),
```

Optionally, in the same file, change `'default'` to Oracle if you want this to be the default database driver.

Official documentation for Laravel Homestead [is located here](http://laravel.com/docs/5.0/homestead).
