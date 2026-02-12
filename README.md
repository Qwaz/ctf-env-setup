# CTF Environment Setup

CTF environment setup script for Ubuntu

## Installation

```
git clone https://github.com/Qwaz/ctf-env-setup.git
cd ctf-env-setup
# edit options.sh to adjust optional features
./setup.sh
```

## Included

- Pyenv installation
- Git aliases

### Optional Features

- libc 32-bit architecture support
- [pwndbg](https://github.com/pwndbg/pwndbg)
- [qemu-user-static](https://wiki.debian.org/QemuUserEmulation) for multi-arch support
- zsh with [pure theme](https://github.com/sindresorhus/pure)
- [Rust](https://www.rust-lang.org/)
    - `cat` replacement with [`bat`](https://github.com/sharkdp/bat)
    - `ls` replacement with [`eza`](https://github.com/eza-community/eza)
- [tmux](https://github.com/tmux/tmux) with [Dracula Theme](https://draculatheme.com/tmux)
