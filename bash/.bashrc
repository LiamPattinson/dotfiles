#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Command prompt
PS1='[\t \u@\h \w]\$ '

# Environment Variables
export TERM='rxvt-unicode'
export COLORTERM='rxvt-unicode-256color'

# User defined aliases
alias ls='ls --color=auto'
alias l='ls --color=auto -lha'
alias tmux='tmux -2'

# SSH keychain
eval $(keychain --eval --quiet --nogui --noask id_rsa)

# Set lang
LANG=en_GB.UTF-8
LC_CTYPE=$LANG
