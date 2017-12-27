#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load local settings
if [[ -f $HOME/.bash_local ]]; then
    source $HOME/.bash_local
fi

# Command prompt
PS1='[\t \u@\h \w]\$ '

# Running urxvt? If so, make sure TERM is set correctly
if [[ -v COLORTERM ]]; then
    export TERM=rxvt-unicode-256color
fi

# User defined aliases
alias ls='ls --color=auto'
alias l='ls --color=auto -lha'
alias tmux='tmux -2'

# SSH keychain
eval $(keychain --eval --quiet --nogui --noask id_rsa)

# Environment Variables
COLOUR_BLUE_RGB="38,139,210"
COLOUR_BLUE_HEX="268bd2"
