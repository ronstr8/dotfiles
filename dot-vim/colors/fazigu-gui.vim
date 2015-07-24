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
hi Constant      guifg=brown ctermfg=brown
hi DiffAdd       guibg=blue ctermbg=blue
hi DiffChange    guibg=magenta ctermbg=magenta
hi DiffDelete    gui=bold cterm=bold guifg=blue ctermfg=blue guibg=cyan ctermbg=cyan
hi DiffText      gui=bold cterm=bold guibg=red ctermbg=red
hi Directory     guifg=darkcyan ctermfg=darkcyan
hi Error         gui=bold cterm=bold guifg=white ctermfg=white guibg=red ctermbg=red
hi ErrorMsg      gui=bold cterm=bold guifg=white ctermfg=white guibg=red ctermbg=red
hi FoldColumn    guifg=darkgrey ctermfg=darkgrey guibg=NONE ctermbg=NONE
hi Folded        guifg=darkgrey ctermfg=darkgrey guibg=NONE ctermbg=NONE
hi Identifier    guifg=cyan ctermfg=cyan
hi Ignore        guifg=darkgrey ctermfg=darkgrey
hi IncSearch     gui=NONE cterm=NONE guifg=yellow ctermfg=yellow guibg=green ctermbg=green
hi LineNr        guifg=yellow ctermfg=yellow
hi ModeMsg       gui=NONE cterm=NONE guifg=brown ctermfg=brown
hi MoreMsg       guifg=darkgreen ctermfg=darkgreen
hi NonText       gui=bold cterm=bold guifg=darkblue ctermfg=darkblue
hi perlPOD       guifg=lightcyan ctermfg=lightcyan
hi PreProc       guifg=magenta ctermfg=magenta
hi Question      guifg=green ctermfg=green
hi Search        gui=NONE cterm=NONE guifg=grey ctermfg=grey guibg=blue ctermbg=blue
hi Special       guifg=magenta ctermfg=magenta
hi SpecialKey    guifg=darkgreen ctermfg=darkgreen
hi Statement     guifg=yellow ctermfg=yellow
hi StatusLine    gui=bold,reverse cterm=bold,reverse
hi StatusLineNC  gui=reverse cterm=reverse
hi Title         guifg=magenta ctermfg=magenta
hi Type          guifg=green ctermfg=green
hi Underlined    gui=underline cterm=underline guifg=magenta ctermfg=magenta
hi VertSplit     gui=reverse cterm=reverse
hi Visual        gui=reverse cterm=reverse
hi VisualNOS     gui=bold,underline cterm=bold,underline
hi WarningMsg    guifg=red ctermfg=red
hi WildMenu      guifg=black ctermfg=black guibg=yellow ctermbg=yellow

"" My preferred overrides.

hi Comment gui=NONE cterm=NONE guifg=darkgray ctermfg=darkgray guibg=NONE ctermbg=NONE
hi Constant gui=NONE cterm=NONE guifg=#ffa0a0 ctermfg=#ffa0a0 guibg=NONE ctermbg=NONE
hi Cursor gui=NONE cterm=NONE guifg=SlateGrey ctermfg=SlateGrey guibg=khaki ctermbg=khaki
"CursorIM
"DiffAdd
"DiffChange
"DiffDelete
"DiffText
"Directory
"Error
"ErrorMsg
hi FoldColumn gui=NONE cterm=NONE guifg=tan ctermfg=tan guibg=grey30 ctermbg=grey30
hi Folded gui=NONE cterm=NONE guifg=gold ctermfg=gold guibg=grey30 ctermbg=grey30
hi Identifier gui=none cterm=none guifg=PaleGreen ctermfg=PaleGreen guibg=NONE ctermbg=NONE
hi Ignore gui=NONE cterm=NONE guifg=grey40 ctermfg=grey40 guibg=NONE ctermbg=NONE
hi IncSearch gui=NONE cterm=NONE guifg=SlateGrey ctermfg=SlateGrey guibg=khaki ctermbg=khaki
"LineNr
"Menu
hi ModeMsg gui=NONE cterm=NONE guifg=goldenrod ctermfg=goldenrod guibg=NONE ctermbg=NONE
hi MoreMsg gui=NONE cterm=NONE guifg=SeaGreen ctermfg=SeaGreen guibg=NONE ctermbg=NONE
hi NonText gui=bold cterm=bold guifg=#addbe7 ctermfg=#addbe7 guibg=black ctermbg=black
hi Normal gui=NONE cterm=NONE guifg=grey80 ctermfg=grey80 guibg=black ctermbg=black
hi perlPOD gui=NONE cterm=NONE guifg=dimgray ctermfg=dimgray guibg=NONE ctermbg=NONE
hi PreProc gui=NONE cterm=NONE guifg=IndianRed ctermfg=IndianRed guibg=NONE ctermbg=NONE
hi Question gui=NONE cterm=NONE guifg=SpringGreen ctermfg=SpringGreen guibg=NONE ctermbg=NONE
"Scrollbar
hi Search gui=NONE cterm=NONE guifg=wheat ctermfg=wheat guibg=peru ctermbg=peru
hi Special gui=NONE cterm=NONE guifg=#ffdead ctermfg=#ffdead guibg=NONE ctermbg=NONE
hi SpecialKey gui=NONE cterm=NONE guifg=OliveDrab3 ctermfg=OliveDrab3 guibg=NONE ctermbg=NONE
hi Statement gui=bold cterm=bold guifg=khaki ctermfg=khaki guibg=NONE ctermbg=NONE
hi StatusLine gui=reverse cterm=reverse guifg=#c2bfa5 ctermfg=#c2bfa5 guibg=black ctermbg=black
hi StatusLineNC gui=reverse cterm=reverse guifg=#c2bfa5 ctermfg=#c2bfa5 guibg=grey50 ctermbg=grey50
hi String gui=italic cterm=italic guifg=wheat ctermfg=wheat guibg=NONE ctermbg=NONE
hi Title gui=NONE cterm=NONE guifg=IndianRed ctermfg=IndianRed guibg=NONE ctermbg=NONE
hi Todo gui=NONE cterm=NONE guifg=OrangeRed ctermfg=OrangeRed guibg=yellow2 ctermbg=yellow2
"Tooltip
hi Type gui=bold cterm=bold guifg=DarkKhaki ctermfg=DarkKhaki guibg=NONE ctermbg=NONE
"Underlined
hi VertSplit gui=reverse cterm=reverse guifg=#c2bfa5 ctermfg=#c2bfa5 guibg=grey50 ctermbg=grey50
hi Visual gui=reverse cterm=reverse guifg=OliveDrab ctermfg=OliveDrab guibg=khaki ctermbg=khaki
"VisualNOS
hi WarningMsg gui=NONE cterm=NONE guifg=salmon ctermfg=salmon guibg=NONE ctermbg=NONE
"WildMenu

