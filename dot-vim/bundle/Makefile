
##	for xDir in */doc ; do [[ -d $xDir/doc ]] && vim -u NONE -c "helptags $xDir/doc" -c q ; done

all: clone helptags

helptags: helptags-tabular helptags-fugitive

helptags-tabular: tabular
	vim -u NONE -c "helptags tabular/doc" -c q

helptags-fugitive: vim-fugitive
	vim -u NONE -c "helptags vim-fugitive/doc" -c q

helptags-gitgutter: vim-gitgutter
	vim -u NONE -c "helptags vim-gitgutter/doc" -c q

clone: tabular vim-fugitive vim-json

tabular: tabular
	git clone git://github.com/godlygeek/tabular.git

vim-fugitive: vim-fugitive
	git clone git://github.com/tpope/vim-fugitive.git

vim-json: vim-json
	git clone https://github.com/elzr/vim-json.git

vim-gitgutter: vim-gitgutter
	git clone git://github.com/airblade/vim-gitgutter.git
