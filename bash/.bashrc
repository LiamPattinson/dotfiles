# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load local settings
if [[ -f $HOME/.bash_local ]]; then
  source $HOME/.bash_local
fi

# Command prompt
PS1='[\t \u@\h \w]\$ '

# Set up readline
# Doesn't apply in zsh
set -o vi

# Ignore Ctrl-d as a shell-killer
set -o ignoreeof

# Handy aliases
alias ls='ls --color=auto'
alias l='ls --color=auto -lha --group-directories-first'
alias tmux='tmux -2'

# Prefer nvim
if [[ -f /usr/bin/nvim ]]; then
  alias vim=nvim
  EDITOR=nvim
else
  EDITOR=vim
fi

# Path edits
if [[ -d /opt/anaconda ]]; then
  PATH="$PATH:/opt/anaconda/bin"
fi

PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"

# SSH keychain
eval $(keychain --eval --quiet --nogui --noask id_rsa)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ltp511/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ltp511/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ltp511/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:/home/ltp511/miniconda3/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

. "$HOME/.cargo/env"

