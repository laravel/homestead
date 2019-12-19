#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/oh-my-zsh ]
then
    echo "oh-my-zsh already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/oh-my-zsh
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git /home/vagrant/.oh-my-zsh
cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
printf "\nemulate sh -c 'source ~/.bash_aliases'\n" | tee -a /home/vagrant/.zprofile
printf "\nemulate sh -c 'source ~/.profile'\n" | tee -a /home/vagrant/.zprofile
chown -R vagrant:vagrant /home/vagrant/.oh-my-zsh
chown vagrant:vagrant /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zprofile
chsh -s /bin/zsh vagrant
