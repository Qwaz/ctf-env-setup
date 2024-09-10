$INSTALL zsh

mkdir -p "$HOME/.zsh"

# Install fish-like experiences
git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search

# Install pure theme
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

str='bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^H" backward-kill-word

zstyle ":completion:*" menu select

# fish-like experiences
fpath+=($HOME/.zsh/zsh-completions/src)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# pure prompt theme
fpath+=($HOME/.zsh/pure)

autoload -U promptinit; promptinit
prompt pure
'
RC="$RC
$str"

# change shell without prompt
$SUDO sed -ri "s#^($USER:[^s]+)/bin/bash#\1$(which zsh)#g" /etc/passwd
