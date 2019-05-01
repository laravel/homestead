#!/usr/bin/env bash

# Install oh-my-zsh

git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
printf "\nsource ~/.bash_aliases\n" | tee -a /home/vagrant/.zshrc
printf "\nsource ~/.profile\n" | tee -a /home/vagrant/.zshrc
chown -R vagrant:vagrant /home/vagrant/.oh-my-zsh
chown vagrant:vagrant /home/vagrant/.zshrc
chsh -s /bin/zsh vagrant
