# CTF Environment Setup

CTF enviroment setup script for Ubuntu

## Installation

```
git clone https://github.com/Qwaz/ctf-env-setup.git
cd ctf-env-setup
# edit options.sh to adjust optional features
./setup.sh
```

## Included

- [pwndbg](https://github.com/pwndbg/pwndbg)
- [pwntools](https://github.com/Gallopsled/pwntools)
- tmux configuration for pwntools

### Optional Features

- [qemu-user-static](https://wiki.debian.org/QemuUserEmulation) for multi-arch support
- zsh with [pure theme](https://github.com/sindresorhus/pure)
- `cat` replacement with [`bat`](https://github.com/sharkdp/bat)
- `ls` replacement with [`exa`](https://github.com/ogham/exa)
