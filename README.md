# Dotfiles of @LiamPattinson

A collection of my personal settings files.

## Usage

Relies on the tool `stow` to manage home directory symlinks.  This can be
installed using `apt`:

```bash
sudo apt install stow
```

First, clone this repo into your home directory, being sure to include
submodules:

```bash
cd $HOME
git clone --recursive git@github.com:LiamPattinson/dotfiles
```

To install a set of dotfiles for `git`, perform the commands:

```bash
cd ~/dotfiles
stow git
```

This will create a symlink at `~/.gitconfig` that points to the file
`~/dotfiles/git/.gitconfig`.

## Detailed Instructions

As a prerequisite, you should have your SSH keys set up with GitHub. You should
then proceed through the following steps in order:

### Git

This one is really easy -- simply `stow git` and you're done.

### Vim

Again, just `stow vim` and you're done. We'll prefer Neovim for almost
everything, so this is just a minimal set up.

### Bash

Zsh should be the preferred shell, but we need this as a foundation.  It
contains only a minimal `.bashrc` file, but an optional `.bash_local` file may
be created within the home directory to add any machine-specific setup. To
install, simply run `stow bash`.

Options like `APPEND_HISTORY` will not be set here, as they'll interfere with
the Zsh set up later.

### Zsh

First install Zsh using your distro package manager.

We'll need to install oh-my-zsh next:

```bash
# Check the official site first to see if this has changed
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

This will install a default `.zshrc`, which you should keep in place for now.

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

### Neovim

Install the following:

```bash
sudo apt install ripgrep fd-find
```

You should also install Rust (see below), and then:

```bash
cargo install tree-sitter-cli
```

As the Ubuntu version of Neovim is hopelessly outdated, we'll then need to
install a pre-built binary for your system from the latest releases:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
```

The Neovim configuration can be found in my fork of
[kickstart.nvim](https://github.com/LiamPattinson/kickstart.nvim), which is
included in the top-level of this repo as a submodule. The `nvim` directory
simply contains a sym-link to that submodule.

After running `stow nvim`, all plugins will be installed the next time `nvim`
is opened.

Currently, the Neovim set up includes only minimal changes from the
kickstart.nvim defaults. I previously ran a setup that included LSP plugins and
more custom key-bindings, but I found it far too difficult to maintain and
could never remember how to use all of the features I'd installed. Since moving
to VSCode as my core 'heavy duty' editor, I've relegated Neovim to being a
convenience editor for smaller jobs. I may return to this at some point to
reintroduce Python/Rust LSPs if I can find the time.

## Additional Setup

- Install [`uv`](https://docs.astral.sh/uv/getting-started/installation/), which
  should be preferred over standard tools for Python development:

```bash
# Double-check the website to ensure this is still correct
curl -LsSf https://astral.sh/uv/install.sh | sh
```

- Install Rust:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

- Install Node.js. In lieu of Ubuntu's packaged version, go to the 
  [node website](https://nodejs.org/en/download) and follow the instructions there.

- Install [VSCode](https://code.visualstudio.com/docs/setup/linux) and set up using
  your saved profile info.

## License

This repo is licensed under the MIT License. It includes a fork of
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), which is also
licensed under MIT.
