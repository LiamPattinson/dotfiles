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

Features like `historyappend` will not be set here, as they'll interfere
with the Zsh set up later.

### `zsh`

First install Zsh using your distro package manager.

We'll need to install oh-my-zsh next:

```bash
# Check the official site first to see if this has changed
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

This will install a default `.zshrc`, which you should keep in place
for now.

Next, install nerd fonts:

```bash
mkdir -p ~/Workspace
cd ~/Workspace
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
chmod u+x install.sh
./install.sh RobotoMono  # Or something else...
```

Then go into your terminal settings, set your default font to the new Nerd
Font, and re-open the terminal.

You can then remove the default `.zshrc`, `stow zsh`, and go through the inital
setup by running `zsh`.

Finally, change your default shell:

```bash
chsh -s $(which zsh)  # Log-out so this will take effect!
```
