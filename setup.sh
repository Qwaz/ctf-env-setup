#!/bin/bash
set -ex

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

INSTALL="$SUDO apt -yq install"

LOCAL_BIN="$HOME/.local/bin"
RC_PATH="\$HOME/.local/bin"
RC='export LC_CTYPE=en_US.UTF-8
export TERM="xterm-256color"
ulimit -c unlimited
'

source versions.sh
source options.sh
mkdir -p $LOCAL_BIN


# add 32-bit support
$SUDO dpkg --add-architecture i386


# install packages
$SUDO apt -yq update && $SUDO apt -yq upgrade
$INSTALL git wget unzip curl
$INSTALL build-essential python3-dev python3-venv libc6-dbg
$INSTALL libc6-dbg:i386


# copy scripts
cp pwntools-terminal $LOCAL_BIN


# optional feature installation
test "$QEMU" -eq 1 && source optional/qemu.sh

test "$ZSH" -eq 1 && source optional/zsh.sh
test "$RUST" -eq 1 && source optional/rust.sh
test "$TMUX" -eq 1 && source optional/tmux.sh


# Python environment setup
if [[ ! -d "$HOME/.venv" ]]; then
    mkdir $HOME/.venv
    python3 -m venv $HOME/.venv/hack

    source $HOME/.venv/hack/bin/activate
    pip install --upgrade pip
    pip install pwntools pycryptodome
    deactivate
fi

str='VIRTUAL_ENV_DISABLE_PROMPT=true source $HOME/.venv/hack/bin/activate
'
RC="$RC
$str"

# Update PATH variable
RC="PATH=$RC_PATH:\$PATH

$RC"

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
