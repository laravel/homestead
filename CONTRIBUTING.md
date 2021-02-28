- Install Vagrant
- Install Virtual Box

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

	**[repo-parent]** will reference this directory below.  
	**\$host** indicates a shell command you are to execute on your host machine.  
	**\$vagrant** indicates a shell command you are to execute inside the vagrant box.
   

6. \$host cd [repo-parent]


7. $ mkdir rvtw


8. $ cd rvtw


7. $ git clone https://github.com/socialknowledge/rvtw-laravel.git backend


9. $ cd backend


10. Unrar the database backup. It is at:

    rvtw/backend/database/seeds/rvtrip.rar
    
    Make sure that "rvtrip.sql" remains in the same directory.


11. $ composer install
	- Your OS will need Php 7.2

	If you get an error about ext-zip ( or other extensions by chance ), run these commands:
	brew update
	brew install php@7.3
	brew link php@7.3 --force


12.	(Windows) $ vendor/bin/homestead.bat make
	(MacOS)   $ php vendor/bin/homestead make
	
	Several files will be created in your project dir. Do not add these new files to git

	
13. Edit the "Homestead.yaml" file
	- Note the ip address. Change it to 192.168.33.10
	- Note the "sites:" section. Change to the following:
```

folders:
	- map: /Users/{YOUR_USERNAME_HERE}/RVTW/homestead/rvtw

sites:
    -
        map: local.rvtripwizard.com
        to: /home/vagrant/code/backend/public
```
   - Save file

14. Edit Hosts
	(Windows) c:\windows\system32\drivers\etc\hosts
	(MacOS) sudo nano /etc/hosts
	
	Add
	
	192.168.10.11 local.rvtripwizard.com


15. (Windows) rename "after.sh.win" to "after.sh"
	(MacOs)   rename "after.sh.mac" to "after.sh"

		
16. $ vagrant up


17. Remove the database dump file:

    rvtw/backend/database/seeds/rvtrip.sql