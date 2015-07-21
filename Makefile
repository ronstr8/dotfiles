
DOTFILES_WC=$(PWD)

bash:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/.bashrc .bashrc
	ln -s --backup $(DOTFILES_WC)/.bash   ,bash

vim:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/.vimrc .vimrc
	ln -s --backup $(DOTFILES_WC)/.vim   ,vim

screen:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/.screenrc .screenrc
	ln -s --backup $(DOTFILES_WC)/.screen   ,screen
