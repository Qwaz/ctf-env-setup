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


# copy scripts
cp pwntools-terminal $LOCAL_BIN


if [ $PWNDBG -eq 1 ]; then
    # install pwndbg
    git clone https://github.com/pwndbg/pwndbg $HOME/.pwndbg
    pushd $PWD
    cd $HOME/.pwndbg
    ./setup.sh
    popd
fi


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
