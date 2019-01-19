EXA_ZIP_NAME=exa-linux-x86_64-${EXA_VERSION}.zip

wget https://github.com/ogham/exa/releases/download/v${EXA_VERSION}/${EXA_ZIP_NAME}
unzip ${EXA_ZIP_NAME}
rm ${EXA_ZIP_NAME}
mv exa-linux-x86_64 $LOCAL_BIN/exa

str='alias ls=exa
alias la="exa -a"
alias ll="exa -al"
alias lr="exa -lT"
'
RC="$RC
$str"
