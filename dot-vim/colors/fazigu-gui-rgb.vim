"" fazigu.vim
"" Maintainer: Ron "Quinn" Straight <quinnfazigu@gmail.com>
""

set background=dark

if !has("syntax")
    finish
endif

hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name="fazigu"
 
"" Available styles: bold, underline, undercurl, reverse, inverse, italic, standout, NONE
"" @see :help highlight-args

"" Default 8-color terminal definitions.

hi Comment       guifg=darkcyan ctermfg=darkcyan
hi Constant      guifg=a52a2a ctermfg=a52a2a
hi DiffAdd       guibg=0000ff ctermbg=0000ff
hi DiffChange    guibg=ff00ff ctermbg=ff00ff
hi DiffDelete    gui=bold cterm=bold guifg=0000ff ctermfg=0000ff guibg=00ffff ctermbg=00ffff
hi DiffText      gui=bold cterm=bold guibg=ff0000 ctermbg=ff0000
hi Directory     guifg=darkcyan ctermfg=darkcyan
hi Error         gui=bold cterm=bold guifg=ffffff ctermfg=ffffff guibg=ff0000 ctermbg=ff0000
hi ErrorMsg      gui=bold cterm=bold guifg=ffffff ctermfg=ffffff guibg=ff0000 ctermbg=ff0000
hi FoldColumn    guifg=darkgrey ctermfg=darkgrey guibg=NONE ctermbg=NONE
hi Folded        guifg=darkgrey ctermfg=darkgrey guibg=NONE ctermbg=NONE
hi Identifier    guifg=00ffff ctermfg=00ffff
hi Ignore        guifg=darkgrey ctermfg=darkgrey
hi IncSearch     gui=NONE cterm=NONE guifg=ffff00 ctermfg=ffff00 guibg=00ff00 ctermbg=00ff00
hi LineNr        guifg=ffff00 ctermfg=ffff00
hi ModeMsg       gui=NONE cterm=NONE guifg=a52a2a ctermfg=a52a2a
hi MoreMsg       guifg=darkgreen ctermfg=darkgreen
hi NonText       gui=bold cterm=bold guifg=darkblue ctermfg=darkblue
hi perlPOD       guifg=lightcyan ctermfg=lightcyan
hi PreProc       guifg=ff00ff ctermfg=ff00ff
hi Question      guifg=00ff00 ctermfg=00ff00
hi Search        gui=NONE cterm=NONE guifg=bebebe ctermfg=bebebe guibg=0000ff ctermbg=0000ff
hi Special       guifg=ff00ff ctermfg=ff00ff
hi SpecialKey    guifg=darkgreen ctermfg=darkgreen
hi Statement     guifg=ffff00 ctermfg=ffff00
hi StatusLine    gui=bold,reverse cterm=bold,reverse
hi StatusLineNC  gui=reverse cterm=reverse
hi Title         guifg=ff00ff ctermfg=ff00ff
hi Type          guifg=00ff00 ctermfg=00ff00
hi Underlined    gui=underline cterm=underline guifg=ff00ff ctermfg=ff00ff
hi VertSplit     gui=reverse cterm=reverse
hi Visual        gui=reverse cterm=reverse
hi VisualNOS     gui=bold,underline cterm=bold,underline
hi WarningMsg    guifg=ff0000 ctermfg=ff0000
hi WildMenu      guifg=000000 ctermfg=000000 guibg=ffff00 ctermbg=ffff00

"" My preferred overrides.

hi Comment gui=NONE cterm=NONE guifg=darkgray ctermfg=darkgray guibg=NONE ctermbg=NONE
hi Constant gui=NONE cterm=NONE guifg=ffa0a0 ctermfg=ffa0a0 guibg=NONE ctermbg=NONE
hi Cursor gui=NONE cterm=NONE guifg=708090 ctermfg=708090 guibg=f0e68c ctermbg=f0e68c
"CursorIM
"DiffAdd
"DiffChange
"DiffDelete
"DiffText
"Directory
"Error
"ErrorMsg
hi FoldColumn gui=NONE cterm=NONE guifg=d2b48c ctermfg=d2b48c guibg=4d4d4d ctermbg=4d4d4d
hi Folded gui=NONE cterm=NONE guifg=ffd700 ctermfg=ffd700 guibg=4d4d4d ctermbg=4d4d4d
hi Identifier gui=none cterm=none guifg=98fb98 ctermfg=98fb98 guibg=NONE ctermbg=NONE
hi Ignore gui=NONE cterm=NONE guifg=666666 ctermfg=666666 guibg=NONE ctermbg=NONE
hi IncSearch gui=NONE cterm=NONE guifg=708090 ctermfg=708090 guibg=f0e68c ctermbg=f0e68c
"LineNr
"Menu
hi ModeMsg gui=NONE cterm=NONE guifg=daa520 ctermfg=daa520 guibg=NONE ctermbg=NONE
hi MoreMsg gui=NONE cterm=NONE guifg=2e8b57 ctermfg=2e8b57 guibg=NONE ctermbg=NONE
hi NonText gui=bold cterm=bold guifg=addbe7 ctermfg=addbe7 guibg=000000 ctermbg=000000
hi Normal gui=NONE cterm=NONE guifg=cccccc ctermfg=cccccc guibg=000000 ctermbg=000000
hi perlPOD gui=NONE cterm=NONE guifg=dimgray ctermfg=dimgray guibg=NONE ctermbg=NONE
hi PreProc gui=NONE cterm=NONE guifg=cd5c5c ctermfg=cd5c5c guibg=NONE ctermbg=NONE
hi Question gui=NONE cterm=NONE guifg=00ff7f ctermfg=00ff7f guibg=NONE ctermbg=NONE
"Scrollbar
hi Search gui=NONE cterm=NONE guifg=f5deb3 ctermfg=f5deb3 guibg=cd853f ctermbg=cd853f
hi Special gui=NONE cterm=NONE guifg=ffdead ctermfg=ffdead guibg=NONE ctermbg=NONE
hi SpecialKey gui=NONE cterm=NONE guifg=9acd32 ctermfg=9acd32 guibg=NONE ctermbg=NONE
hi Statement gui=bold cterm=bold guifg=f0e68c ctermfg=f0e68c guibg=NONE ctermbg=NONE
hi StatusLine gui=reverse cterm=reverse guifg=c2bfa5 ctermfg=c2bfa5 guibg=000000 ctermbg=000000
hi StatusLineNC gui=reverse cterm=reverse guifg=c2bfa5 ctermfg=c2bfa5 guibg=7f7f7f ctermbg=7f7f7f
hi String gui=italic cterm=italic guifg=f5deb3 ctermfg=f5deb3 guibg=NONE ctermbg=NONE
hi Title gui=NONE cterm=NONE guifg=cd5c5c ctermfg=cd5c5c guibg=NONE ctermbg=NONE
hi Todo gui=NONE cterm=NONE guifg=ff4500 ctermfg=ff4500 guibg=eeee00 ctermbg=eeee00
"Tooltip
hi Type gui=bold cterm=bold guifg=bdb76b ctermfg=bdb76b guibg=NONE ctermbg=NONE
"Underlined
hi VertSplit gui=reverse cterm=reverse guifg=c2bfa5 ctermfg=c2bfa5 guibg=7f7f7f ctermbg=7f7f7f
hi Visual gui=reverse cterm=reverse guifg=6b8e23 ctermfg=6b8e23 guibg=f0e68c ctermbg=f0e68c
"VisualNOS
hi WarningMsg gui=NONE cterm=NONE guifg=fa8072 ctermfg=fa8072 guibg=NONE ctermbg=NONE
"WildMenu

