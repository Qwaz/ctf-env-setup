BAT_DEB_NAME=bat_${BAT_VERSION}_amd64.deb

wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${BAT_DEB_NAME}
sudo dpkg -i $BAT_DEB_NAME
rm $BAT_DEB_NAME

str='alias cat="bat -p --paging never"
'
RC="$RC
$str"
