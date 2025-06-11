# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load local settings from .bash_local
# Add any configuration to this file that isn't generalisable
# to all machines you use.
if [[ -f $HOME/.bash_local ]]; then
  source $HOME/.bash_local
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Use vi mode in GNU Readline
set -o vi

# Ignore Ctrl-d when used to kill the shell
set -o ignoreeof

# Handy aliases
alias ls='ls --color=auto'
alias l='ls -lhA --group-directories-first'
alias tmux='tmux -2'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Basic command prompt
if [[ "$TERM" =~ 256color ]]; then
  GREEN="\[\033[01;92m\]"
  BLUE="\[\033[01;94m\]"
  DEFAULT="\[\033[0m\]"
else
  GREEN=
  BLUE=
  DEFAULT=
fi
PS1="${GREEN}\u@\h:${BLUE}\w ${DEFAULT}\$ "

# Prefer nvim
if [[ -f /usr/bin/nvim ]]; then
  alias vim=nvim
  EDITOR=nvim
else
  EDITOR=vim
fi

# Path edits
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
