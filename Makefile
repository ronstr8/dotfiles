
# @see $SIMPLE_BACKUP_SUFFIX, $VERSION_CONTROL
INSTALL=ln --symbolic --backup='numbered' --relative
DOTFILES_WC=$(PWD)
HOSTNAME=$(HOSTNAME)

all: bash bc bin elinks emacs input mplayer rtorrent screen tf top vim Xdefaults Xmodmap

## bash

dot-bash: $(HOME)/.bash
	$(INSTALL) $(DOTFILES_WC)/dot-bash $(HOME)/.bash

dot-bashrc: $(HOME)/.bashrc 
	$(INSTALL) $(HOME)/.bash/rc        $(HOME)/.bashrc

bash: dot-bash dot-bashrc

## bc

dot-bcrc: $(HOME)/.bcrc
	$(INSTALL) $(DOTFILES_WC)/dot-bcrc $(HOME)/.bcrc

bc: dot-bcrc

## ~/bin.

home-bin: $(HOME)/bin
	$(INSTALL) $(DOTFILES_WC)/home-bin $(HOME)/bin

bin: home-bin

## elinks

dot-elinks: $(HOME)/.elinks
	$(INSTALL) $(DOTFILES_WC)/dot-elinks $(HOME)/.elinks

elinks: dot-elinks

## emacs

dot-emacs: $(HOME)/.emacs
	$(INSTALL) $(DOTFILES_WC)/dot-emacs   $(HOME)/.emacs

dot-emacs.d: $(HOME)/.emacs.d
	$(INSTALL) $(DOTFILES_WC)/dot-emacs.d $(HOME)/.emacs.d

emacs: dot-emacs dot-emacs.d

## inputrc/readline/libreadline

dot-inputrc: $(HOME)/.inputrc
	$(INSTALL) $(DOTFILES_WC)/dot-inputrc $(HOME)/.inputrc

input: dot-inputrc
readline: input
libreadline: input

## mplayer

dot-mplayer: $(HOME)/.mplayer
	$(INSTALL) $(DOTFILES_WC)/dot-mplayer $(HOME)/.mplayer

mplayer: dot-mplayer

## rtorrent

dot-rtorrent: $(HOME)/.rtorrent.rc
	$(INSTALL) $(DOTFILES_WC)/dot-rtorrent.rc $(HOME)/.rtorrent.rc

rtorrent: dot-rtorrent

## screen

dot-screen: $(HOME)/.screen
	$(INSTALL) $(DOTFILES_WC)/dot-screen $(HOME)/.screen

dot-screenrc: $(HOME)/.screenrc
	$(INSTALL) $(HOME)/.screen/rc $(HOME)/.screenrc

screen: dot-screen dot-screenrc

## tf/tinyfugue

dot-tf: $(HOME)/.tf
	$(INSTALL) $(DOTFILES_WC)/dot-tf $(HOME)/.tf

dot-tfrc: dot-tf/rc $(HOME)/.tfrc
	$(INSTALL) $(HOME)/.tf/rc $(HOME)/.tfrc

tf: dot-tf dot-tfrc
tinyfugue: tf

## top

dot-top: $(HOME)/.toprc
	$(INSTALL) $(DOTFILES_WC)/dot-toprc $(HOME)/.toprc

top: dot-top

## vim

dot-vim: $(HOME)/.vim
	$(INSTALL) $(DOTFILES_WC)/dot-vim    $(HOME)/.vim

dot-vimrc: dot-vim/rc $(HOME)/.vimrc
	$(INSTALL) $(HOME)/.vim/rc $(HOME)/.vimrc

vim: dot-vim dot-vimrc

## xrdb/Xdefaults/Xresources

# @see man X(7) under FILES
#  $XENVIRONMENT, $XUSERFILESEARCHPATH, $XAPPLRESDIR

dot-Xdefaults: $(HOME)/.Xdefaults
	$(INSTALL) $(DOTFILES_WC)/dot-Xdefaults   $(HOME)/.Xdefaults

# @TODO Change .Xdefaults.d to contain files named after the resource
#  name of their application (e.g. XTerm, possibly with symlinks to
#  UXTerm et al) as per /etc/X11/app-defaults

dot-Xdefaults.d: $(HOME)/.Xdefaults.d
	$(INSTALL) $(DOTFILES_WC)/dot-Xdefaults.d $(HOME)/.Xdefaults.d

Xdefaults: dot-Xdefaults dot-Xdefaults.d
Xresources: Xdefaults
xrdb: Xdefaults

## xmodmap(1)

dot-Xmodmap: $(HOME)/.Xmodmap
	$(INSTALL) $(DOTFILES_WC)/dot-Xmodmap $(HOME)/.Xmodmap

xmodmap: dot-Xmodmap
Xmodmap: xmodmap

## TODO: clean: Remove all numbered backup files.





