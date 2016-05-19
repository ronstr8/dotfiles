" @see http://ergoemacs.org/emacs_manual/emacs/Choosing-Modes.html
" @see http://vimdoc.sourceforge.net/htmldoc/filetype.html#new-filetype-scripts
autocmd BufNewFile,BufRead *
    \ let s:emacsre = '^.*-\*-\s*\(\S\+\)\s*-\*-$' |
    \ let s:line1 = getline(1) |
    \ if s:line1 =~ s:emacsre |
    \   let s:emacsmode = substitute(s:line1, s:emacsre, '\1', 'g') |
    \   echo 'matched: ' . s:line1 . '; emacsmode=' . s:emacsmode |
    \   let &filetype = s:emacsmode |
    \ fi

