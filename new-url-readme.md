# Running the scripts to change to a new url

## Caveats: 
1. This is for the RVTW Team.
2. These scripts only work on Mac. I'm pretty sure they won't even work on Linux because sed works a little differently there and DNS cache flushing does too. I can write the Linux version if needed but I don't think anyone needs them.
3. If you don't want to run a shell script that invokes sudo, you can just do those steps manually - changing the URLs appropriately in the /etc/hosts file, and flushing the DNS cache. If you do, make sure that you exit out of sudo before you run the second script or do vagrant provision --reload. Vagrant won't let you do that unless you're the same user that initialized the box, and you probably didn't do sudo vagrant up.


## Steps:
1. sh ./new-url-needs-sudo.sh
2. sh ./new-url.sh

(The two files are separated for the aforementioned vagrant issue and to quarantine root actions.)

This should change 5 files in your backend folder and 3 files in your frontend folder.
I don't know how versioning should be handled there, since we aren't making the switch on a synchronized timescale as far as I know.
Probably there will be a PR for each repo to merge into the main branch once everyone has switched over.
Just bear in mind that when you switch branches in the frontend or backend some of the changes made by the new-url.sh script will not travel with you unless you specify that it does so.