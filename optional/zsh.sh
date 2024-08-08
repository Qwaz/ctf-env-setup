$INSTALL zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Replace ZSH_THEME to ""
sed -i 's/^ZSH_THEME=.*/ZSH_THEME=""/' $HOME/.zshrc

# Install pure theme
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

str='zstyle ":completion:*" menu select

ZSH_THEME=""

fpath+=($HOME/.zsh/pure)

autoload -U promptinit; promptinit
prompt pure
'
RC="$RC
$str"

# change shell without prompt
$SUDO sed -ri "s#^($USER:[^s]+)/bin/bash#\1$(which zsh)#g" /etc/passwd
