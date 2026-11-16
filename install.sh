#!/bin/bash
# ./install.sh                 every target below, in this order
# ./install.sh TARGET...       only those, in the order given
#
#   upgrade   the system's packages updated and upgraded, the unused removed (apt)
#   build     gcc and make (apt)
#   git       git, and its global settings: name, email, master as the default branch, push sets the upstream
#   neovim    the newest Neovim release system-wide, in /opt/nvim and /usr/local/bin, apt's removed (too old for
#             olang's completion, which needs 0.11; termux's own package there), and init.lua into ~/.config/nvim
#             (an old init.vim there removed: Neovim refuses to start with both)
#   gdb       gdb, and gdbinit into ~/.gdbinit
#   olang     olang built from its own checkout (~/.local/src/olang, always master) and installed into ~/.local,
#             with clang and the libraries it needs; its prompt edits in vi mode (x86-64 Linux)
#   jupyter   JupyterLab, with olang as a kernel (after olang)

all="upgrade build git neovim gdb olang jupyter"
cd "$(dirname "$0")" || exit 1

# apt as root where sudo exists, plain where it does not (termux)
apt_() {
    if command -v sudo > /dev/null 2>&1; then sudo apt -y "$@"; else apt -y "$@"; fi
}
has_apt() { command -v apt > /dev/null 2>&1; }
termux() { ! command -v sudo > /dev/null 2>&1; }

upgrade() {
    has_apt || return 0
    apt_ update
    apt_ autoremove
    apt_ upgrade
}

build() {
    has_apt || return 0
    if termux; then apt_ install clang make; else apt_ install gcc make; fi
}

git_() {
    has_apt && apt_ install git
    git config --global init.defaultBranch master
    git config --global user.email "oscar.arvidsson@protonmail.com"
    git config --global user.name "Oscar Arvidsson"
    git config --global push.autoSetupRemote true
}

neovim() {
    if termux; then
        apt_ install neovim
    elif [ "$(uname -s) $(uname -m)" = "Linux x86_64" ]; then
        # the newest release, system-wide: unpacked into /opt/nvim and linked from /usr/local/bin, which comes before
        # /usr/bin; apt's neovim removed (too old for olang's completion, which needs 0.11)
        tmp=$(mktemp -d) || return 1
        curl -fsSL -o "$tmp/nvim.tar.gz" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz || return 1
        sudo rm -rf /opt/nvim /opt/nvim-linux-x86_64
        sudo tar -xzf "$tmp/nvim.tar.gz" -C /opt && sudo mv /opt/nvim-linux-x86_64 /opt/nvim || return 1
        sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
        rm -rf "$tmp"
        dpkg -s neovim > /dev/null 2>&1 && sudo apt -y remove neovim
        # what an earlier install.sh put in the home directory
        rm -rf ~/.local/opt/nvim
        [ -L ~/.local/bin/nvim ] && rm -f ~/.local/bin/nvim
        hash -r
        nvim --version | head -1
    else
        has_apt && apt_ install neovim
    fi
    mkdir -p ~/.config/nvim
    rm -f ~/.config/nvim/init.vim
    cp init.lua ~/.config/nvim/init.lua
}

gdb_() {
    has_apt && apt_ install gdb
    cp gdbinit ~/.gdbinit
}

olang() {
    if [ "$(uname -s) $(uname -m)" != "Linux x86_64" ]; then
        echo "install.sh: olang is built on x86-64 Linux only - skipped" >&2
        return 0
    fi
    # clang 18 or newer with its LTO plugin, xz, libffi and the C headers
    has_apt && ! termux && apt_ install clang-18 llvm-18-linker-tools xz-utils libffi-dev libc6-dev
    # its own checkout, always master: a working checkout elsewhere (~/olang) is never touched
    src=~/.local/src/olang
    if [ -d "$src/.git" ]; then
        git -C "$src" fetch --depth 1 origin master && git -C "$src" reset --hard origin/master
    else
        git clone --depth 1 --branch master https://github.com/osarv/olang "$src"
    fi
    make -C "$src" || return 1
    # the olang prompt edits in vi mode
    grep -qxF 'export OLANG_EDIT=vi' ~/.bashrc 2> /dev/null || echo 'export OLANG_EDIT=vi' >> ~/.bashrc
}

jupyter() {
    if [ ! -x ~/.local/bin/olang ]; then
        echo "install.sh: jupyter needs olang installed first (./install.sh olang jupyter)" >&2
        return 1
    fi
    has_apt && ! termux && apt_ install pipx
    pipx install jupyterlab
    ~/.local/bin/olang jupyter -install
}

targets="${*:-$all}"
for t in $targets; do
    case " $all " in
        *" $t "*) ;;
        *) echo "install.sh: unknown target '$t' - one of: $all" >&2; exit 1 ;;
    esac
done
for t in $targets; do
    echo "== $t"
    case "$t" in
        git) git_ ;;
        gdb) gdb_ ;;
        *) "$t" ;;
    esac || { echo "install.sh: $t failed" >&2; exit 1; }
done
