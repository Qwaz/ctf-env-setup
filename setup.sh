#!/bin/bash
set -ex

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

INSTALL="$SUDO apt -yq install"
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
$SUDO dpkg --add-architecture i386


# install packages
$SUDO apt -yq update && $SUDO apt -yq upgrade
$INSTALL git wget unzip
$INSTALL build-essential python3-dev python3-venv libc6-dbg
$INSTALL libc6-dbg:i386


if [ $KERNEL_OPT -eq 1 ]; then
    # kernel related setting
    SYSCTL_CONF=/etc/sysctl.conf
    PTRACE_CONF=/etc/sysctl.d/10-ptrace.conf

    echo 0 | $SUDO tee /proc/sys/kernel/yama/ptrace_scope
    $SUDO sed -i '/^kernel.yama.ptrace_scope/ d' $PTRACE_CONF
    echo 'kernel.yama.ptrace_scope = 0' | $SUDO tee -a $PTRACE_CONF

    echo "core-%e.%p" | $SUDO tee /proc/sys/kernel/core_pattern
    $SUDO sed -i '/^kernel.core_pattern/ d' $SYSCTL_CONF
    echo 'kernel.core_pattern = core-%e.%p' | $SUDO tee -a $SYSCTL_CONF
fi


# Python environment setup
mkdir $HOME/.venv
python3 -m venv $HOME/.venv/hack

str='source $HOME/.venv/hack/bin/activate
'
RC="$RC
$str"

source $HOME/.venv/hack/bin/activate
pip install --upgrade pip
pip install pwntools pycryptodome
deactivate


# copy scripts
cp pwntools-terminal $LOCAL_BIN
cp .tmux.conf $HOME


if [ $KERNEL_OPT -eq 1 ]; then
    # install pwndbg
    git clone https://github.com/pwndbg/pwndbg $HOME/.pwndbg
    pushd $PWD
    cd $HOME/.pwndbg
    ./setup.sh
    popd
fi


# optional feature installation
test "$ZSH" -eq 1 && source optional/zsh.sh
test "$BAT" -eq 1 && source optional/bat.sh
test "$EXA" -eq 1 && source optional/exa.sh
test "$QEMU" -eq 1 && source optional/qemu.sh


# Updating RC
if [[ "$ZSH" -eq 1 ]]; then
    echo "$RC" >> $HOME/.zshrc
else
    echo "$RC" >> $HOME/.bashrc
fi
