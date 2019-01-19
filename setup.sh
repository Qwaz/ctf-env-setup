#!/bin/bash
set -ex

INSTALL="sudo apt -yq install"
RC='export LC_CTYPE=en_US.UTF-8
export TERM="xterm-256color"
ulimit -c unlimited
'

LOCAL_BIN="$HOME/.local/bin"
RC="PATH=$LOCAL_BIN:\$PATH

$RC"

source versions.sh
source options.sh
mkdir -p $LOCAL_BIN


# add 32-bit support
sudo dpkg --add-architecture i386


# install packages
sudo apt -yq update && sudo apt -yq upgrade
$INSTALL build-essential python-dev libc6-dbg libgmp3-dev unzip
$INSTALL libc6-dbg:i386 libncurses5:i386 libstdc++6:i386


# kernel related setting
SYSCTL_CONF=/etc/sysctl.conf
PTRACE_CONF=/etc/sysctl.d/10-ptrace.conf

echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
sudo sed -i '/^kernel.yama.ptrace_scope/ d' $PTRACE_CONF
echo 'kernel.yama.ptrace_scope = 0' | sudo tee -a $PTRACE_CONF

echo "core-%e.%p" | sudo tee /proc/sys/kernel/core_pattern
sudo sed -i '/^kernel.core_pattern/ d' $SYSCTL_CONF
echo 'kernel.core_pattern = core-%e.%p' | sudo tee -a $SYSCTL_CONF


# Python environment setup
sudo apt -yq install virtualenv
mkdir $HOME/.venv
virtualenv $HOME/.venv/hack

str='source $HOME/.venv/hack/bin/activate
'
RC="$RC
$str"

source $HOME/.venv/hack/bin/activate
pip install pwntools pycryptodome
deactivate


# copy scripts
cp pwntools-terminal $LOCAL_BIN
cp .tmux.conf $HOME


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
test "$ZSH" -eq 1 && echo "$RC$ZSH_RC" >> $HOME/.zshrc
