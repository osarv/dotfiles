#!/bin/bash

if command -v apt 2>&1>/dev/null; then
    if command -v sudo 2>&1>/dev/null; then
        #full system path
        sudo apt -y update
        sudo apt -y autoremove
        sudo apt -y upgrade
        sudo apt -y install neovim gcc make gdb git
        # olang: clang 18 or newer with its LTO plugin, xz, libffi and the C headers
        sudo apt -y install clang-18 llvm-18-linker-tools xz-utils libffi-dev libc6-dev
        sudo apt -y install pipx
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

# olang (x86-64 Linux only): build it from source and install it into ~/.local
# (the compiler, std, the Neovim/Vim packages, and ~/.local/bin on PATH)
if [ "$(uname -s) $(uname -m)" = "Linux x86_64" ]; then
    # its own checkout, always master: a working checkout elsewhere (~/olang) is never touched
    src=~/.local/src/olang
    if [ -d "$src/.git" ]; then
        git -C "$src" fetch --depth 1 origin master && git -C "$src" reset --hard origin/master
    else
        git clone --depth 1 --branch master https://github.com/osarv/olang "$src"
    fi
    make -C "$src" boot && make -C "$src" install
    # notebooks: JupyterLab, with olang as a kernel
    if command -v pipx > /dev/null 2>&1; then
        pipx install jupyterlab
        ~/.local/bin/olang jupyter -install
    fi
fi

# the olang prompt edits in vi mode
grep -qxF 'export OLANG_EDIT=vi' ~/.bashrc 2> /dev/null || echo 'export OLANG_EDIT=vi' >> ~/.bashrc
