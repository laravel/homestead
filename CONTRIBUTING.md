## Notes:

* It is not uncommon to have issues with the npm commands below. Make sure you have the latest versions of NPM and Node
installed. You can attempt to execute the NPM commands from inside the box but they generally are more successful from
the host system.
  
## Let's Go

- Install Vagrant
- Install Virtual Box
- Install Node (MacOs should have this already) (I used Node v15)
- Install NPM (MacOs should have this already) (I used NPM v7.5)

1. (Windows) Setup git bash - https://git-scm.com/download/win


2. 	(Windows) Open Git Bash As Administrator (right click on git bash, run as admin)  
	(MacOS)   Open Terminal

	
3. $ cat ~/.ssh/id_rsa.pub
	- If you get file not found, then run:
		$ ssh-keygen -t rsa -C “your_email@example.com”
		Make sure the email is the same one you use to login to github.
		
		You will be prompted, just press \<enter\> for each.
		Next, run:
		
		$ cat ~/.ssh/id_rsa.pub
		
		
4. You should receive text beginning with "ssh-rsa". Copy all of this text and go to:

	https://github.com/settings/ssh/new
	
	Give a title and paste what you copied into the Key field. Save

		
5. Decide where your repositories will be in your host filesystem. Create a directory if needed.  

	**[host-repo-parent]** will reference the full path to this directory on the host.
	**\<\$host\>** indicates a shell command you are to execute on your host machine.  
	**\<\$vagrant\>** indicates a shell command you are to execute inside the vagrant box.
   

6. \<\$host\> cd [host-repo-parent]
   

7. \<\$host\> git clone git@github.com:rv-life/homestead.git homestead


8. \<\$host\> cd homestead


9. \<\$host\> git checkout release


10. \<\$host\> cp Homestead.yaml.example Homestead.yaml


11. \<\$host\> nano Homestead.yaml

	Find ``[Platform Manager Directory on Host Machine]`` and replace with ``[repo-parent]/platform-manager``  
	Find ``[RV Trip Wizard Directory on Host Machine]`` and replace with ``[repo-parent]/rvtw``  
	Find ``[Campground Reviews Directory on Host Machine]`` and replace with ``[repo-parent]/cgr``  
	Find ``[Campground Reviews Admin Directory on Host Machine]`` and replace with ``[repo-parent]/cgr-admin``  
	Find ``[Homestead Directory on Host Machine]`` and replace with ``[repo-parent]/homestead``
	

	Remember [repo-parent] is replaced with the full path to the parent directory of your repositories.  
	So if [repo-parent] is "/Users/tom/Sites" then the "/Users/tom/Sites/platform-manager" would be the first replacement above

	For Windows, an example would be 'C:\vagrant\platform-manager'

12.	The base box is now setup and ready to setup each individual site within.  

&nbsp;&nbsp;&nbsp;To login to the box, from the homestead directory on the host machine:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;``<$host> vagrant ssh``  

&nbsp;&nbsp;&nbsp;To stop the box, from the homestead directory on the host machine:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;``<$host> vagrant halt``

&nbsp;&nbsp;&nbsp;To destroy the box, from the homestead directory on the host machine:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;``<$host> vagrant destroy``

&nbsp;&nbsp;&nbsp;To start the box, from the homestead directory on the host machine:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;``<$host> vagrant up>``   


13. \<\$host\> vagrant up


14. \<\$host\> vagrant ssh


You are now logged into the box.

### Setting up your local hosts file

For Windows:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Edit  c:\windows\system32\drivers\etc\hosts
   
For MacOs:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sudo nano /etc/hosts

Then Add at the end:

	192.168.10.10 local.rvlife.com
	192.168.10.10 my-local.rvlife.com
	192.168.10.10 local.rvtripwizard.com
	192.168.10.10 local.campgroundreviews.com
	192.168.10.10 api-local.campgroundreviews.com
	192.168.10.10 admin-local.campgroundreviews.com

### Setting up RV Trip Wizard

1. \<\$host\> cd [host-repo-parent]


2. git clone git@github.com:rv-life/rvtw-laravel.git rvtw/backend


3. git clone git@github.com:rv-life/rvtw-react.git rvtw/frontend


4. \<\$vagrant\> cd /home/vagrant/rvtw


5. \<\$vagrant\> bash after.sh


RV Trip Wizard should now be accessible at http://local.rvtripwizard.com

By default, RV Trip Wizard is setup to authenticate from your local Platform Manager install (which we haven't go to yet).
If you are only working with RV Trip Wizard then you don't have to go any further if you don't wish to authenticate
locally. You may use https://pm-dev.rvlife.com to authenticate. To do that, then you will need to go to
https://pm-dev.rvlife.com/nova and create your own PM Client. Take the ID and secret, update the SSO_CLIENT_ID and
SSO_CLIENT_SECRET settings in .env. Update SSO_URL to https://pm-dev.rvlife.com

### Setting Up Platform Manager

1. \<\$host\> cd [host-repo-parent]


2. git clone git@github.com:rv-life/platform-manager.git platform-manager


3. cd platform-manager


4. npm install


5. npm run dev


6. cd nova-components/StripeProductManage


7. npm install


8. npm run dev


9. \<\$vagrant\> cd /home/vagrant/platform-manager
	

10. \<\$vagrant\> bash after.sh


Platform Manager should now be accessible at http://local.rvlife.com/nova  
You can log in with the following credentials:

*Username*: **admin@local.rvlife.com**  
*Password*: **password**


### Setting up Campground Reviews

1. \<\$host\> cd [host-repo-parent]


2. git clone git@github.com:rv-life/rvpr2.git cgr
   

3. git clone git@github.com:rv-life/rvparkreviews.git cgr-admin


4. cd cgr


4. npm install


5. npm run dev


6. \<\$vagrant\> cd /home/vagrant/cgr


7. \<\$vagrant\> bash after.sh


8. \<\$vagrant\> cd /home/vagrant/cgr-admin


9. \<\$vagrant\> bash after.sh


10. nano /home/vagrant/cgr-admin/app/config/database.php

&nbsp;&nbsp;&nbsp;In the *rvparkreviews* section:
* change the username to *homestead*
* change the password to *secret*

# Note to Bhuwan about step 10
database.php needs to be copied to database.php.example and database.php.homestead  
Update database.php.homestead to have the above values  
Add the two files to the repo  
Then update cgr-admin-after.sh to copy database.php.homestead to database.php  
Then update the cgr envoyer release to copy database.php.example to database.php
