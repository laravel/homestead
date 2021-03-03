#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
export CLOUDSDK_PYTHON=python3

if [ -f /home/vagrant/.homestead-features/gcloud ]
then
    echo "gcloud already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/gcloud
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

sudo apt-get update
sudo apt-get install -y apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

sudo apt-get update
sudo apt-get install -y google-cloud-sdk kubectl
