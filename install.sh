#!/bin/bash

if command -v apt 2>&1>/dev/null; then
    if command -v sudo 2>&1>/dev/null; then
        #full system path
        sudo apt -y update
        sudo apt -y autoremove
        sudo apt -y upgrade
        sudo apt -y install neovim gcc make gdb git 
    else
        #termux path
        apt -y update
        apt -y autoremove
        apt -y upgrade
        apt -y install neovim clang make gdb git
    fi
fi


git config --global init.defaultBranch master
git config --global user.email "oscar.arvidsson@protonmail.com"
git config --global user.name "Oscar Arvidsson"
git config --global push.autoSetupRemote true
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim
cp gdbinit ~/.gdbinit
