#!/bin/bash
set -ex

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

INSTALL="$SUDO apt -yq install"

LOCAL_BIN="$HOME/.local/bin"
RC_PATH="\$HOME/.local/bin"
RC='export TERM="xterm-256color"
ulimit -c unlimited
'

source options.sh
mkdir -p $LOCAL_BIN


# add 32-bit support
test "$ARCH_32" -eq 1 && $SUDO dpkg --add-architecture i386


# install packages
$SUDO apt -yq update && $SUDO apt -yq upgrade
$INSTALL git wget unzip curl
$INSTALL build-essential libc6-dbg
test "$ARCH_32" -eq 1 && $INSTALL libc6-dbg:i386


# copy scripts
cp pwntools-terminal $LOCAL_BIN

# Install pyenv
curl https://pyenv.run | bash


# optional feature installation
test "$QEMU" -eq 1 && source optional/qemu.sh

test "$ZSH" -eq 1 && source optional/zsh.sh
test "$RUST" -eq 1 && source optional/rust.sh
test "$TMUX" -eq 1 && source optional/tmux.sh
test "$PWNDBG" -eq 1 && source optional/pwndbg.sh

# Update RC
str='alias ga="git add -A"
alias gm="git commit -m"

if command -v code &> /dev/null; then
    export GIT_EDITOR="code --wait"
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
'
RC="PATH=$RC_PATH:\$PATH

$RC
$str"

# Updating RC
if [[ "$UPDATE_RC" -eq 1 ]]; then
    if [[ "$ZSH" -eq 1 ]]; then
        echo "$RC" >> $HOME/.zshrc
    else
        echo "$RC" >> $HOME/.bashrc
    fi
else
    set +x
    echo "RC was not added"
    echo "$RC"
fi

# P.S.

# Install fzf manually if you want
# fzf: https://github.com/junegunn/fzf

# type this in terminal if tmux is already running
# tmux source ~/.tmux.conf

# Use the tpm install command: prefix + I (default prefix is ctrl+b)
