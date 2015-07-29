set incsearch
set ignorecase
set smartcase
"set nohlsearch
set bg=dark
set nocompatible
set ruler
syntax on
if has("autocmd")
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif
set tabstop=4
set noexpandtab
set shiftwidth=4
set autoindent
set gfn=Consolas\ 15

"function! RedrawSansHl ()
"	:nohl
"	:redraw
"endfunction
"map <CTRL-L> :call RedrawSansHl

let loaded_matchparen = 1

nnoremap <F1> :bprev<CR> 
nnoremap <F2> :bnext<CR>
nnoremap <F5> "=strftime("%F %T")<CR>P
inoremap <F5> <C-R>=strftime("%F %T")<CR>
nnoremap <F11> :set invpaste<CR> 
nnoremap <F8> :nohl<CR>

let g:no_italics = !empty($SSH_CLIENT) && !empty(matchstr($SSH_CLIENT, '^76\.180\.125\.'))

colorscheme fazigu
set t_Co=256

set t_ZH="^[[3m"
set t_ZR="^[[23m"

"colorscheme deveiate  ## horrible for perl
"colorscheme inkpot
"colorscheme gardener

"set ttymouse=xterm
"set mouse=a



"   Define this variable to make buftabs only print the filename of each buffer,
"   omitting the preceding directory name. Add to your .vimrc:
:let g:buftabs_only_basename=1

"   Define this variable to make the plugin show the buftabs in the statusline
"   instead of the command line. It is a good idea to configure vim to show
"   the statusline as well when only one window is open. Add to your .vimrc:
set laststatus=2
:let g:buftabs_in_statusline=1

"   By default buftabs will take up the whole of the left-aligned section of
"   your statusline. You can alternatively specify precisely where it goes
"   using %{buftabs#statusline()} e.g.:
"
"set statusline=%=buffers:\ %{buftabs#statusline()}
"set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set statusline=%<%f%h%m%r%=Col\ %c\ Line\ %l/%L\ %P

"
" * g:buftabs_active_highlight_group
" * g:buftabs_inactive_highlight_group
"
"   The name of a highlight group (:help highligh-groups) which is used to
"   show the name of the current active buffer and of all other inactive
"   buffers. If these variables are not defined, no highlighting is used.
"   (Highlighting is only functional when g:buftabs_in_statusline is enabled)
"
:let g:buftabs_active_highlight_group="Visual"


"" http://www.techrepublic.com/article/configure-vi-for-java-application-development/#
"" http://www.techrepublic.com/html/tr/sidebars/5054618-0.html
set sm
set ai
syntax on
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1

"" http://www.techrepublic.com/html/tr/sidebars/5054618-2.html
set makeprg=vimAnt
set efm=\ %#[javac]\ %#%f:%l:%c:%*\\d:%*\\d:\ %t%[%^:]%#:%m,
	\%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

filetype plugin on
autocmd Filetype java set tags=/home/rons/.vim/tags/java
set complete=.,w,b,u,t,i
set omnifunc=syntaxcomplete#Complete
"" Use c-Xc-O to enter completion in INSERT mode.
"" Use c-N and c-P to scroll through the completion list.
"" Sometimes only c-N works for me to complete and to scroll.


execute pathogen#infect()

"" let mapleader=','
"" if exists(":Tabularize")
"" 	nmap <Leader>a= :Tabularize /=<CR>
"" 	vmap <Leader>a= :Tabularize /=<CR>
"" 	nmap <Leader>a: :Tabularize /:\zs<CR>
"" 	vmap <Leader>a: :Tabularize /:\zs<CR>
"" endif



"" http://stackoverflow.com/questions/1675688/make-vim-show-all-white-spaces-as-a-character
" :set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" :set list

let Pmd_Cmd = "/opt/pmd/bin/run.sh pmd "
let Pmd_Rulesets = "java-basic,java-unusedcode,java-typeresolution,java-design"
"let Pmd_Rulesets = "rulesets/basic.xml,rulesets/imports.xml,rulesets/unusedcode.xml"


"function! RemoveSearchHighlighting ()
"	:nohl
"endfunction
"
"augroup SearchHighlightRemoval
"    autocmd!
"    autocmd InsertEnter * :call RemoveSearchHighlighting 
"augroup END
"

