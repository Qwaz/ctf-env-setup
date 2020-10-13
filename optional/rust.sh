curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

source $HOME/.cargo/env
cargo install --locked bat
cargo install --locked exa

RC_PATH="${RC_PATH}:\$HOME/.cargo/bin"

str='alias ls=exa
alias la="exa -a"
alias ll="exa -l"
alias lal="exa -al"
alias lla="exa -la"
alias lr="exa -lT"

alias cat="bat -p --paging never"
'
RC="$RC
$str"
