$INSTALL zsh

ANTIBODY_DEB_NAME=antibody_${ANTIBODY_VERSION}_linux_amd64.deb
wget https://github.com/getantibody/antibody/releases/download/v${ANTIBODY_VERSION}/${ANTIBODY_DEB_NAME}
sudo dpkg -i $ANTIBODY_DEB_NAME
rm $ANTIBODY_DEB_NAME

echo '# fish-like experience
zsh-users/zsh-autosuggestions
zsh-users/zsh-completions
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search

# theme
mafredri/zsh-async
sindresorhus/pure' > $HOME/.zsh_plugins

ZSH_RC='source <(antibody init)
antibody bundle < ~/.zsh_plugins
zstyle ":completion:*" menu select
'

sudo sed -ri "s#^($USER:[^s]+)/bin/bash#\1$(which zsh)#g" /etc/passwd
