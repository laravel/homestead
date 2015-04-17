#!/usr/bin/env bash

#account for different versions of ngrok
if [ $1 == "1" ];
then
 URL="https://api.equinox.io/1/Applications/ap_pJSFC5wQYkAyI0FIVwKYs9h1hW/Updates/Asset/ngrok.zip?os=linux&arch=amd64&channel=stable"
 CONFIG_FILE="/home/vagrant/.ngrok"
else
 URL="https://dl.ngrok.com/ngrok_2.0.15_linux_amd64.zip"
 CONFIG_DIR="/home/vagrant/.ngrok2"
 CONFIG_FILE=$CONFIG_DIR"/ngrok.yml"

 #make ngrok home dir
 if [ ! -f $CONFIG_DIR ];
 then
   mkdir $CONFIG_DIR
 fi

fi

#if we dont have ngrok then download it
if [ -f /usr/bin/ngrok ];
then
   echo "ngrok found, skipping download"
else
   #download and unzip script
   cd ~/
   wget -nv $URL -O ngrok.zip

   sudo apt-get install unzip
   unzip ngrok.zip

   #move the script to bin and trash zip
   sudo mv ngrok /usr/bin/ngrok
   rm ngrok.zip
fi

#symlink configuration file
ln -sf $2 $CONFIG_FILE

echo $CONFIG_FILE" linked to " $2