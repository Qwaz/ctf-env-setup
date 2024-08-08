curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

source $HOME/.cargo/env
cargo install --locked bat
cargo install --locked eza

RC_PATH="${RC_PATH}:\$HOME/.cargo/bin"

str='alias ls=eza
alias la="eza -a"
alias ll="eza -l"
alias lal="eza -al"
alias lla="eza -la"
alias lr="eza -lT"

alias cat="bat -p --paging=never"
'
RC="$RC
$str"
