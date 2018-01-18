# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load local settings
if [[ -f $HOME/.bash_local ]]; then
    source $HOME/.bash_local
fi

# Command prompt
PS1='[\t \u@\h \w]\$ '

# Running urxvt? If so, make sure TERM is set correctly
if [[ ! -z "$COLORTERM" ]]; then # -z tests empty string. Preferable to -v for compatibility.
    export TERM=xterm-256color
fi

# Ignore Ctrl-d as a shell-killer
set -o ignoreeof

# User defined aliases
alias ls='ls --color=auto'
alias l='ls --color=auto -lha'
alias tmux='tmux -2'

# Path edits

if [[ -d /opt/anaconda ]]; then
    PATH="$PATH:/opt/anaconda/bin"
fi

# SSH keychain
eval $(keychain --eval --quiet --nogui --noask id_rsa)

# Environment Variables
COLOUR_BLUE_RGB="38,139,210"
COLOUR_BLUE_HEX="268bd2"
