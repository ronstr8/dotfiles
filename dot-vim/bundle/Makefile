
##	for xDir in */doc ; do [[ -d $xDir/doc ]] && vim -u NONE -c "helptags $xDir/doc" -c q ; done

all: clone helptags

helptags: helptags-tabular helptags-fugitive

helptags-tabular: clone-tabular
	vim -u NONE -c "helptags tabular/doc" -c q

helptags-fugitive: clone-fugitive
	vim -u NONE -c "helptags vim-fugitive/doc" -c q

clone: clone-tabular clone-fugitive clone-json

clone-tabular: tabular
	git clone git://github.com/godlygeek/tabular.git

clone-fugitive: vim-fugitive
	git clone git://github.com/tpope/vim-fugitive.git

clone-json: vim-json
	git clone https://github.com/elzr/vim-json.git

