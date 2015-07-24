
DOTFILES_WC=$(PWD)

bash:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-bash    .bash
	ln -s --backup $(DOTFILES_WC)/dot-bash/rc .bashrc

bc:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-bcrc .bcrc

bin:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/bin bin

elinks:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-elinks .elinks

emacs:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-emacs   .emacs
	ln -s --backup $(DOTFILES_WC)/dot-emacs.d .emacs.d

input:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-inputrc .inputrc

mplayer:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-mplayer .mplayer

rtorrent:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-rtorrent.rc .rtorrent.rc

screen:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-screen    .screen
	ln -s --backup $(DOTFILES_WC)/dot-screen/rc .screenrc

tf:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-tf    .tf
	ln -s --backup $(DOTFILES_WC)/dot-tf/rc .tfrc

top:
	cd $(HOME)
	ln -s --backup $(DOFILES_WC)/dot-toprc .toprc

vim:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-vim    .vim
	ln -s --backup $(DOTFILES_WC)/dot-vim/rc .vimrc

Xdefaults:
	cd $(HOME)
	ln -s --backup $(DOTFILES_WC)/dot-Xdefaults   .Xdefaults
	ln -s --backup $(DOTFILES_WC)/dot-Xdefaults.d .Xdefaults.d

Xmodmap:
	cd $(HOME)
	ln -s --backup $(DOFILES_WC)/dot-Xmodmap .Xmodmap


