
LN=ln --symbolic --backup='numbered' --relative
DOTFILES_WC=$(PWD)

all: bash bc bin elinks emacs input mplayer rtorrent screen tf top vim Xdefaults Xmodmap

bash: dot-bash dot-bash/rc 
	$(LN) $(DOTFILES_WC)/dot-bash    $(HOME)/.bash
	$(LN) $(DOTFILES_WC)/dot-bash/rc $(HOME)/.bashrc

bc: dot-bcrc
	$(LN) $(DOTFILES_WC)/dot-bcrc $(HOME)/.bcrc

bin: home-bin
	$(LN) $(DOTFILES_WC)/home-bin $(HOME)/bin

elinks: dot-elinks
	$(LN) $(DOTFILES_WC)/dot-elinks $(HOME)/.elinks

emacs: dot-emacs dot-emacs.d
	$(LN) $(DOTFILES_WC)/dot-emacs   $(HOME)/.emacs
	$(LN) $(DOTFILES_WC)/dot-emacs.d $(HOME)/.emacs.d

input: dot-inputrc
	$(LN) $(DOTFILES_WC)/dot-inputrc $(HOME)/.inputrc

mplayer: dot-mplayer
	$(LN) $(DOTFILES_WC)/dot-mplayer $(HOME)/.mplayer

rtorrent: dot-rtorrent.rc
	$(LN) $(DOTFILES_WC)/dot-rtorrent.rc $(HOME)/.rtorrent.rc

screen: dot-screen dot-screen/rc
	$(LN) $(DOTFILES_WC)/dot-screen    $(HOME)/.screen
	$(LN) $(DOTFILES_WC)/dot-screen/rc $(HOME)/.screenrc

tf: dot-tf dot-tf/rc
	$(LN) $(DOTFILES_WC)/dot-tf    $(HOME)/.tf
	$(LN) $(DOTFILES_WC)/dot-tf/rc $(HOME)/.tfrc

top: dot-toprc
	$(LN) $(DOTFILES_WC)/dot-toprc $(HOME)/.toprc

vim: dot-vim dot-vim/rc
	$(LN) $(DOTFILES_WC)/dot-vim    $(HOME)/.vim
	$(LN) $(DOTFILES_WC)/dot-vim/rc $(HOME)/.vimrc

Xdefaults: dot-Xdefaults dot-Xdefaults.d
	$(LN) $(DOTFILES_WC)/dot-Xdefaults   $(HOME)/.Xdefaults
	$(LN) $(DOTFILES_WC)/dot-Xdefaults.d $(HOME)/.Xdefaults.d

Xmodmap: dot-Xmodmap
	$(LN) $(DOTFILES_WC)/dot-Xmodmap $(HOME)/.Xmodmap


