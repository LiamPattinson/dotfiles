dotfiles - Liam Pattinson

A collection of personal settings files for Linux machines.

Relies on the tool GNU Stow to manage home directory symlinks.
To install a set of dotfiles for a package PKG, perform the commands:

cd ~/dotfiles
stow PKG

The directory layout should be:
dotfiles/
	PKG/
		[home directory dotfiles]
		.config/
			PKG/
				[any files in .config]
		.local/
			share/
				PKG/
					[any files in local]

For example, for vim dotfiles:
dotfiles/
	vim/
		.vimrc
		.vim/
			[vim setting files]
