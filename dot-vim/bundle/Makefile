
##	for xDir in */doc ; do [[ -d $xDir/doc ]] && vim -u NONE -c "helptags $xDir/doc" -c q ; done

all: clone helptags

helptags: tabular-helptags fugitive-helptags gitgutter-helptags

tabular-helptags: tabular
	vim -u NONE -c "helptags tabular/doc" -c q

fugitive-helptags: vim-fugitive
	vim -u NONE -c "helptags vim-fugitive/doc" -c q

gitgutter-helptags: vim-gitgutter
	vim -u NONE -c "helptags vim-gitgutter/doc" -c q

clone: tabular vim-fugitive vim-json vim-gitgutter

tabular:
	git clone git://github.com/godlygeek/tabular.git

vim-fugitive:
	git clone git://github.com/tpope/vim-fugitive.git

vim-json:
	git clone git://github.com/elzr/vim-json.git

vim-gitgutter:
	git clone git://github.com/airblade/vim-gitgutter.git
