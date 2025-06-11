# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Bring in bashrc configuration
source $HOME/.bashrc

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory notify extendedglob
unsetopt autocd beep nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# User preferences


# Create settings dir
if [[ ! -d $HOME/.zsh ]]; then
    mkdir $HOME/.zsh
fi

# Prompt setup
autoload -Uz promptinit
promptinit

# Install antigen
ANTIGEN_FILE=$HOME/.zsh/antigen.zsh
if [[ ! -f $ANTIGEN_FILE ]]; then
    curl -L git.io/antigen > $ANTIGEN_FILE
fi
source $ANTIGEN_FILE

# Use oh-my-zsh for plugins
antigen use oh-my-zsh

antigen bundle common-aliases # Add things like l, la, rm/cp/mv protection
antigen bundle colored-man-pages # what it says in the name
antigen bundle git # Git aliases
antigen bundle git-prompt # Info about current repo
antigen bundle gitfast # Autocompletion for git
antigen bundle history-substring-search # Search history with incomplete command
antigen bundle heroku  # Better autocomplete
antigen bundle pip # PyPI autocomplete

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k

antigen apply

# Something earlier seems to unset this...
bindkey -v

if [[ -d /opt/anaconda ]]; then
    __conda_setup="$('/opt/anaconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/anaconda/etc/profile.d/conda.sh" ]; then
            . "/opt/anaconda/etc/profile.d/conda.sh"
        else
            export PATH="/opt/anaconda/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
