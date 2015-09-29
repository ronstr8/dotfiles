
# @see $SIMPLE_BACKUP_SUFFIX, $VERSION_CONTROL
INSTALL_LINKS=ln --interactive --symbolic
DOTFILES_WC=$(PWD)
HOSTNAME=$(HOSTNAME)

all: bash bc bin elinks emacs input mplayer rtorrent screen tf top vim Xdefaults Xmodmap

## bash

dot-bash:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-bash .bash

dot-bashrc:
	$(INSTALL_LINKS) $(HOME)/.bash/rc        $(HOME)/.bashrc

bash: dot-bash dot-bashrc

## bc

dot-bcrc:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-bcrc .bcrc

bc: dot-bcrc

## ~/bin.

home-bin:
	$(INSTALL_LINKS) $(DOTFILES_WC)/home-bin bin

bin: home-bin

## elinks

dot-elinks:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-elinks .elinks

elinks: dot-elinks

## emacs

dot-emacs:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-emacs   $(HOME)/.emacs

dot-emacs.d:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-emacs.d .emacs.d

emacs: dot-emacs dot-emacs.d

## fonts

dot-fonts:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-fonts .fonts

fonts: dot-fonts

## inputrc/readline/libreadline

dot-inputrc:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-inputrc .inputrc

input: dot-inputrc
readline: input
libreadline: input

## mplayer

dot-mplayer:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-mplayer .mplayer

mplayer: dot-mplayer

## mutt

$(HOME)/.mutt: dot-mutt
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-mutt $(HOME)/.mutt 

$(HOME)/.muttrc: $(HOME)/.mutt
	$(INSTALL_LINKS) $(HOME)/.mutt/rc $(HOME)/.muttrc

mutt: $(HOME)/.mutt $(HOME)/.muttrc

## rtorrent

dot-rtorrent:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-rtorrent.rc .rtorrent.rc

rtorrent: dot-rtorrent

## screen

dot-screen:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-screen .screen

dot-screenrc:
	$(INSTALL_LINKS) $(HOME)/.screen/rc .screenrc

screen: dot-screen dot-screenrc

## tf/tinyfugue

dot-tf:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-tf .tf

dot-tfrc: dot-tf/rc .tfrc
	$(INSTALL_LINKS) $(HOME)/.tf/rc .tfrc

tf: dot-tf dot-tfrc
tinyfugue: tf

## top

dot-top:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-toprc .toprc

top: dot-top

## vim

dot-vim:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-vim    $(HOME)/.vim

dot-vimrc: dot-vim/rc .vimrc
	$(INSTALL_LINKS) $(HOME)/.vim/rc .vimrc

vim: dot-vim dot-vimrc

## xrdb/Xdefaults/Xresources

# @see man X(7) under FILES
#  $XENVIRONMENT, $XUSERFILESEARCHPATH, $XAPPLRESDIR

dot-Xdefaults:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-Xdefaults   $(HOME)/.Xdefaults

# @TODO Change .Xdefaults.d to contain files named after the resource
#  name of their application (e.g. XTerm, possibly with symlinks to
#  UXTerm et al) as per /etc/X11/app-defaults

dot-Xdefaults.d:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-Xdefaults.d .Xdefaults.d

Xdefaults: dot-Xdefaults dot-Xdefaults.d
Xresources: Xdefaults
xrdb: Xdefaults

## xmodmap(1)

dot-Xmodmap:
	$(INSTALL_LINKS) $(DOTFILES_WC)/dot-Xmodmap .Xmodmap

xmodmap: dot-Xmodmap
Xmodmap: xmodmap

## TODO: clean: Remove all numbered backup files.

