#!/bin/bash
set -ex

INSTALL="sudo apt -yq install"
RC='export LC_CTYPE=en_US.UTF-8
test -z "$TMUX" && export TERM="xterm-256color"'
LOCAL_BIN="$HOME/.local/bin"

source versions.sh
source options.sh
mkdir -p $LOCAL_BIN


# add 32-bit support
sudo dpkg --add-architecture i386


# install packages
sudo apt -yq update && sudo apt -yq upgrade
$INSTALL build-essential python-dev libc6-dbg libgmp3-dev unzip
$INSTALL libc6-dbg:i386 libncurses5:i386 libstdc++6:i386


# Python environment setup
sudo apt -yq install virtualenv
mkdir $HOME/.venv
virtualenv $HOME/.venv/hack

RC=$RC'
source $HOME/.venv/hack/bin/activate'

source $HOME/.venv/hack/bin/activate
pip install pwntools pycryptodome
cp pwntools-terminal $LOCAL_BIN
deactivate


# install pwndbg
git clone https://github.com/pwndbg/pwndbg $HOME/.pwndbg
pushd $PWD
cd $HOME/.pwndbg
./setup.sh
popd


# optional feature installation
test "$SSHD" -eq 1 && source optional/sshd.sh
test "$ZSH" -eq 1 && source optional/zsh.sh
test "$BAT" -eq 1 && source optional/bat.sh
test "$EXA" -eq 1 && source optional/exa.sh


# Updating RC
echo "$RC" >> $HOME/.bashrc
test "$ZSH" -eq 1 && echo "$RC" >> $HOME/.zshrc
