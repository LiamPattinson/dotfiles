# dotfiles of @LiamPattinson

A collection of my personal settings files.

## Usage

Relies on the tool `stow` to manage home directory symlinks.
This can be installed using `apt`.

First, clone this repo into your home directory:

```bash
cd $HOME
git clone git@github.com:LiamPattinson/dotfiles
```

To install a set of dotfiles for `git`, perform the commands:

```bash
cd ~/dotfiles
stow git
```

This will create a symlink at `~/.gitconfig` that points to the
file `~/dotfiles/git/.gitconfig`.

## Detailed Instructions

As a prerequisite, you should have your SSH keys set up with
GitHub. You should then proceed to set up the following
steps in order:

### `git`

This one is really easy -- simply `stow git` and you're done.

### `bash`

Zsh should be the preferred shell, but we need this as a foundation.
It contains only a minimal `.bashrc` file, but an optional `.bash_local`
file may be created within the home directory to add any machine-specific
setup. To install, simply run `stow bash`.
