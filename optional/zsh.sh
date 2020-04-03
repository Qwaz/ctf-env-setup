$INSTALL zsh

ANTIBODY_DEB_NAME=antibody_${ANTIBODY_VERSION}_linux_amd64.deb
wget https://github.com/getantibody/antibody/releases/download/v${ANTIBODY_VERSION}/${ANTIBODY_DEB_NAME}
$SUDO dpkg -i $ANTIBODY_DEB_NAME
rm $ANTIBODY_DEB_NAME

cp .zsh_plugins $HOME

str='source <(antibody init)
antibody bundle < ~/.zsh_plugins
zstyle ":completion:*" menu select
'
RC="$RC
$str"

# change shell without prompt
$SUDO sed -ri "s#^($USER:[^s]+)/bin/bash#\1$(which zsh)#g" /etc/passwd
