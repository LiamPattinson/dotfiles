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

# Bring in bashrc configuration
source $HOME/.bashrc

# Prompt setup
autoload -Uz promptinit
promptinit

# oh-my-zsh configuration
if [[ -d $HOME/.oh-my-zsh ]]; then
	
    # Path to your oh-my-zsh installation.
    export ZSH=$HOME/.oh-my-zsh

    # Prevent automatic window renaming
    DISABLE_AUTO_TITLE="true"

    # Theme
    if [[ $TERM == "xterm-256colors" ]]; then
        ZSH_THEME="agnoster"
    else
        ZSH_THEME="robbyrussell"
    fi

    # Command auto-correction
    ENABLE_CORRECTION="true"

    # Plugins, format: plugins=(git python ruby)
    plugins=(
        git
        python
        catimg
        colored-man-pages
        zsh-autosuggestions
        zsh-syntax-highlighting
    )

    # Load
    source $ZSH/oh-my-zsh.sh
else
    prompt walters
fi
