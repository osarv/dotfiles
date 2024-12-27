#!/bin/bash

if command -v apt 2>&1>/dev/null
then
sudo apt -y update
sudo apt -y autoremove
sudo apt -y upgrade
sudo apt -y install neovim gcc make gdb git 
fi

git config --global init.defaultBranch master
git config --global user.email "oscar.arvidsson@protonmail.com"
git config --global user.name "Oscar Arvidsson"
git config --global push.autoSetupRemote true
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim
cp gdbinit ~/.gdbinit
