# Contributing

## Notes

-   It is not uncommon to have issues with the npm commands below. Make sure you have the latest versions of NPM and Node
    installed. You can attempt to execute the NPM commands from inside the box but they generally are more successful from
    the host system. See issues at the bottom

## Let's Go

-   Install Vagrant
-   (Windows/Intel Macs) Install Virtual Box
-   (M1 Macs) Install Parallels Desktop
-   (M1 Macs) run

        vagrant plugin install vagrant-parallels

-   Install Node (MacOs should have this already)
-   Install NPM (MacOs should have this already)

1.  (Windows) Setup git bash - <https://git-scm.com/download/win>

2.  (Windows) Open Git Bash As Administrator (right click on git bash, run as admin)  
    (MacOS) Open Terminal

3.  Perform the following command on your host machine:

        cat ~/.ssh/id_rsa.pub

    If you get `file not found`, then execute on your host machine, using your GitHub login email in place
    of the example email:

        ssh-keygen -t rsa -C “your_email@example.com”

    You will be prompted, just press \<enter\> for each. Next, execute:

        cat ~/.ssh/id_rsa.pub

4.  You should receive text beginning with "ssh-rsa". Copy all of this text and go to:

    <https://github.com/settings/ssh/new>

    Give a title and paste what you copied into the Key field. Save

5.  Decide where your repositories will be in your host filesystem. Create a directory if needed.

    `[host-repo-parent]` will reference the full path to this directory on the host in this document

6.  On your host machine, execute:

        cd [host-repo-parent]
        git clone git@github.com:rv-life/homestead.git homestead

7.  On your host machine, execute the following commands. Ignore any projects that you don't have access to:

        git clone git@github.com:rv-life/rvpr2.git cgr
        git clone git@github.com:rv-life/rvparkreviews.git cgr-admin
        git clone git@github.com:rv-life/platform-manager.git platform-manager
        git clone git@github.com:rv-life/rvtw-laravel.git rvtw/backend
        git clone git@github.com:rv-life/rvtw-react.git rvtw/frontend
        git clone git@github.com:rv-life/rvlife-profile.git profile
        cd homestead
        git checkout release

    If you are trying to add new project to your existing homstead box:

    -   manually copy over the project configs (folder & site mapping) from Homestead.yaml.example to Homestead.yaml
    -   run `vagrant reload --provision`

    Else:

        cp Homestead.yaml.example Homestead.yaml
        nano Homestead.yaml

    For the previous nano step, you need to update the placeholders with the location of the repos on your host
    machine.

    Find `[Platform Manager Directory on Host Machine]` and replace with `[host-repo-parent]/platform-manager`  
    Find `[RV Trip Wizard Directory on Host Machine]` and replace with `[host-repo-parent]/rvtw`  
    Find `[Campground Reviews Directory on Host Machine]` and replace with `[host-repo-parent]/cgr`  
    Find `[Campground Reviews Admin Directory on Host Machine]` and replace with `[host-repo-parent]/cgr-admin`  
    Find `[Homestead Directory on Host Machine]` and replace with `[host-repo-parent]/homestead`

    Remember [host-repo-parent] is replaced with the full path to the parent directory of your repositories.  
    So if [host-repo-parent] is "/Users/tom/Sites" then the "/Users/tom/Sites/platform-manager" would be the first replacement above

    For Windows, an example would be 'C:\vagrant\platform-manager'

    For M1 Mac, change the provider to `parallels` and add the line:

        box: laravel/homestead-arm

8.  On your host machine, execute the following commands:

        vagrant up
        vagrant ssh

9.  (MacOS) If you encounter an error with the previous step, go to System Preferences > Security & Privacy Then hit the "Allow" button to let Oracle (VirtualBox) load.

    (Mac M1) If you encounter an error with the previous step:

    -   (might need to change `bindIp` in `etc/mongod.conf` to `0.0.0.0`)

              vagrant ssh
              sudo apt-get purge mongodb-org*
              sudo apt remove mongodb
              sudo apt purge mongodb
              sudo apt autoremove
              sudo rm -r /var/log/mongodb
              sudo rm -r /var/lib/mongodb
              sudo apt-get install gnupg
              wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
              echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
              sudo apt-get update
              sudo apt-get upgrade
              sudo apt update
              sudo apt upgrade
              sudo apt-get install -y mongodb-org
              sudo apt-get install libc6
              sudo service mongod start
              sudo su
              service mongod stop
              systemctl start mongod
              systemctl enable mongodb.service
              exit
              sudo apt-get install php7.3-mongodb
              exit
              vagrant reload --provision

You are now logged into the box.

&nbsp;&nbsp;&nbsp;To login to the box, from the homestead directory on the host machine:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`vagrant ssh`

&nbsp;&nbsp;&nbsp;To stop the box, from the homestead directory on the host machine:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`vagrant halt`

&nbsp;&nbsp;&nbsp;To destroy the box, from the homestead directory on the host machine:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`vagrant destroy`

&nbsp;&nbsp;&nbsp;To start the box, from the homestead directory on the host machine:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`vagrant up`

### Setting up your local hosts file

For Windows:

    nano c:\windows\system32\drivers\etc\hosts

For MacOs:

    sudo nano /etc/hosts

Then Add at the end:

    192.168.56.56 local.rvlife.com
    192.168.56.56 my-local.rvlife.com
    192.168.56.56 local.rvtripwizard.com
    192.168.56.56 dev-cypress.rvtripwizard.com
    192.168.56.56 campgrounds.local-rvlife.com
    192.168.56.56 cgr-api.local-rvlife.com
    192.168.56.56 admin-local.campgroundreviews.com
    127.0.0.1 profile-local.rvlife.com

### Setting up RV Trip Wizard

Inside the vagrant box (vagrant ssh), perform the following steps :

    cd /home/vagrant/rvtw
    bash after.sh

RV Trip Wizard should now be accessible at <http://local.rvtripwizard.com>

By default, RV Trip Wizard is setup to authenticate from your local Platform Manager install (which we haven't go to yet).
If you are only working with RV Trip Wizard then you don't have to go any further if you don't wish to authenticate
locally. You may use <https://pm-dev.rvlife.com> to authenticate. To do that, then you will need to go to
<https://pm-dev.rvlife.com/nova> and create your own PM Client. Take the ID and secret, update the SSO_CLIENT_ID and
SSO_CLIENT_SECRET settings in .env. Update SSO_URL to <https://pm-dev.rvlife.com>

### Setting up RV Life Profile

Install Yarn on your host machine if you don't have it already

    npm install --global yarn

On Your host machine, perform the following steps :

    cd [host-repo-parent]
    cd profile
    cp .env.example .env

Install the `mkcert` command using `brew install mkcert` (Linux and Windows instructions are
[here](https://github.com/FiloSottile/mkcert)). Then run:

    mkcert -install
    mkdir .certs
    mkcert -key-file ./.certs/server.key -cert-file ./.certs/server.crt "profile-local.rvlife.com"

Then run:

    yarn install
    yarn build

### Setting Up Platform Manager

On Your host machine, perform the following steps :

    cd [host-repo-parent]
    cd platform-manager
    npm install
    npm run dev

    cd nova-components/StripeProductManage
    npm install
    npm run dev

Inside the vagrant box (vagrant ssh), perform the following steps :

    cd /home/vagrant/platform-manager
    bash after.sh

Platform Manager should now be accessible at <http://local.rvlife.com/nova>  
You can log in with the following credentials:

_Username_: **admin@local.rvlife.com**  
_Password_: **password**

### Setting up Campground Reviews

-   As of 2021/11/18 CGR requires Node 15.x.x.

Get the database backups from Mike. There are two .sql files in the allrvpr.tar.gz archive. To uncompress the archive:

    gzip -d allrvpr.tar.gz
    tar -xvf allrvpr.tar

Place the files in the following directory:

    [host-repo-parent]/database/seeds

Should have

    [host-repo-parent]/cgr/database/seeds/rvpr.sql
    [host-repo-parent]/cgr/database/seeds/rvprmissing.sql

On your host machine, perform the following steps :

    cd [host-repo-parent]
    cd cgr
    npm install
    npm run dev

Inside the vagrant box (vagrant ssh), perform the following steps :

    cd /home/vagrant/cgr
    bash after.sh
    cd /home/vagrant/cgr-admin
    bash after.sh

Campground Reviews should now be accessible at <https://local.campgroundreviews.com>  
Complete the SSL section below to remove the browser warning

## Sphinx Search

After setting up the boxes, you need to rotate Sphinx. Inside the vagrant box (vagrant ssh), perform the following step :

    sudo service sphinxsearch stop
    sudo service sphinxsearch start

    sudo /usr/bin/indexer --config /etc/sphinxsearch/sphinx.conf --rotate --all

## CGR Forum

Download the forum.tar.gz archive from the RVPR Files Server (same place you got the CGR database dumps) and place it in the cgr/public directory. Via SSH, move to the public folder and decompress the archive:

    [host-repo-parent]/cgr/public tar -zxvf forum.tar.gz

Delete the archive:

    [host-repo-parent]/cgr/public rm forum.tar.gz

## SSL

Inside the vagrant box (vagrant ssh), perform the following step :

    cp /etc/ssl/certs/ca.homestead.homestead.crt /home/vagrant/homestead

For MacOs, peform the following steps on your host machine in the `[host-repo-parent]/homestead/` folder:

    sudo security delete-certificate -c "Homestead homestead Root CA" /Library/Keychains/System.keychain
    sudo security add-trusted-cert -d -r trustRoot -p ssl -k /Library/Keychains/System.keychain ca.homestead.homestead.crt

For Windows:  
<https://medium.com/dinssa/ssl-certificates-laravel-homestead-windows-https-f83ec8b3198>  
Using the file copied in the previous step above, proceed to step 4 in the linked article.  
The file will be located at `[host-repo-parent]/homestead/ca.homestead.homestead.crt`

## Issues

1. npm says python2 can't be found on Windows - Install Python 2.7
2. Windows npm problems with node-gyp - Try <https://spin.atomicobject.com/2019/03/27/node-gyp-windows/>
