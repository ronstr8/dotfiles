"" fazigu.vim
"" Maintainer: Ron "Quinn" Straight <quinnfazigu@gmail.com>
""
"" Based on and using some code from "desert256" by Henry So, Jr. <henryso@panix.com>.

set background=dark

if version > 580
    "" No guarantees for version 5.8 and below, but this makes it stop
    "" complaining.
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif

let g:colors_name="fazigu"
    
"" Default 8-color terminal definitions.

hi SpecialKey    ctermfg=darkgreen
hi NonText       cterm=bold ctermfg=darkblue
hi Directory     ctermfg=darkcyan
hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
hi IncSearch     cterm=NONE ctermfg=yellow ctermbg=green
hi Search        cterm=NONE ctermfg=grey ctermbg=blue
hi MoreMsg       ctermfg=darkgreen
hi ModeMsg       cterm=NONE ctermfg=brown
hi LineNr        ctermfg=3
hi Question      ctermfg=green
hi StatusLine    cterm=bold,reverse
hi StatusLineNC  cterm=reverse
hi VertSplit     cterm=reverse
hi Title         ctermfg=5
hi Visual        cterm=reverse
hi VisualNOS     cterm=bold,underline
hi WarningMsg    ctermfg=1
hi WildMenu      ctermfg=0 ctermbg=3
hi Folded        ctermfg=darkgrey ctermbg=NONE
hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
hi DiffAdd       ctermbg=4
hi DiffChange    ctermbg=5
hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
hi DiffText      cterm=bold ctermbg=1
hi Constant      ctermfg=brown
hi Special       ctermfg=5
hi Identifier    ctermfg=6
hi Statement     ctermfg=3
hi PreProc       ctermfg=5
hi Type          ctermfg=2
hi Underlined    cterm=underline ctermfg=5
hi Ignore        ctermfg=darkgrey
hi Error         cterm=bold ctermfg=7 ctermbg=1
hi Comment       ctermfg=darkcyan
hi perlPOD       ctermfg=lightcyan

if !has("gui_running") && &t_Co != 88 && &t_Co != 256
	finish
endif

fun <SID>grey_number(x)
	if &t_Co == 88
		if a:x < 23
			return 0
		elseif a:x < 69
			return 1
		elseif a:x < 103
			return 2
		elseif a:x < 127
			return 3
		elseif a:x < 150
			return 4
		elseif a:x < 173
			return 5
		elseif a:x < 196
			return 6
		elseif a:x < 219
			return 7
		elseif a:x < 243
			return 8
		else
			return 9
		endif
	else
		if a:x < 14
			return 0
		else
			let l:n = (a:x - 8) / 10
			let l:m = (a:x - 8) % 10
			if l:m < 5
				return l:n
			else
				return l:n + 1
			endif
		endif
	endif
endfun

" returns the actual grey level represented by the grey index
fun <SID>grey_level(n)
	if &t_Co == 88
		if a:n == 0
			return 0
		elseif a:n == 1
			return 46
		elseif a:n == 2
			return 92
		elseif a:n == 3
			return 115
		elseif a:n == 4
			return 139
		elseif a:n == 5
			return 162
		elseif a:n == 6
			return 185
		elseif a:n == 7
			return 208
		elseif a:n == 8
			return 231
		else
			return 255
		endif
	else
		if a:n == 0
			return 0
		else
			return 8 + (a:n * 10)
		endif
	endif
endfun

" returns the palette index for the given grey index
fun <SID>grey_color(n)
	if &t_Co == 88
		if a:n == 0
			return 16
		elseif a:n == 9
			return 79
		else
			return 79 + a:n
		endif
	else
		if a:n == 0
			return 16
		elseif a:n == 25
			return 231
		else
			return 231 + a:n
		endif
	endif
endfun

" returns an approximate color index for the given color level
fun <SID>rgb_number(x)
	if &t_Co == 88
		if a:x < 69
			return 0
		elseif a:x < 172
			return 1
		elseif a:x < 230
			return 2
		else
			return 3
		endif
	else
		if a:x < 75
			return 0
		else
			let l:n = (a:x - 55) / 40
			let l:m = (a:x - 55) % 40
			if l:m < 20
				return l:n
			else
				return l:n + 1
			endif
		endif
	endif
endfun

" returns the actual color level for the given color index
fun <SID>rgb_level(n)
	if &t_Co == 88
		if a:n == 0
			return 0
		elseif a:n == 1
			return 139
		elseif a:n == 2
			return 205
		else
			return 255
		endif
	else
		if a:n == 0
			return 0
		else
			return 55 + (a:n * 40)
		endif
	endif
endfun

" returns the palette index for the given R/G/B color indices
fun <SID>rgb_color(x, y, z)
	if &t_Co == 88
		return 16 + (a:x * 16) + (a:y * 4) + a:z
	else
		return 16 + (a:x * 36) + (a:y * 6) + a:z
	endif
endfun

" returns the palette index to approximate the given R/G/B color levels
fun <SID>color(r, g, b)
	" get the closest grey
	let l:gx = <SID>grey_number(a:r)
	let l:gy = <SID>grey_number(a:g)
	let l:gz = <SID>grey_number(a:b)

	" get the closest color
	let l:x = <SID>rgb_number(a:r)
	let l:y = <SID>rgb_number(a:g)
	let l:z = <SID>rgb_number(a:b)

	if l:gx == l:gy && l:gy == l:gz
		" there are two possibilities
		let l:dgr = <SID>grey_level(l:gx) - a:r
		let l:dgg = <SID>grey_level(l:gy) - a:g
		let l:dgb = <SID>grey_level(l:gz) - a:b
		let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
		let l:dr = <SID>rgb_level(l:gx) - a:r
		let l:dg = <SID>rgb_level(l:gy) - a:g
		let l:db = <SID>rgb_level(l:gz) - a:b
		let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
		if l:dgrey < l:drgb
			" use the grey
			return <SID>grey_color(l:gx)
		else
			" use the color
			return <SID>rgb_color(l:x, l:y, l:z)
		endif
	else
		" only one possibility
		return <SID>rgb_color(l:x, l:y, l:z)
	endif
endfun

if !exists('g:colorname_x_rgb')
	let g:colorname_x_rgb = {}
	let s:rgbTxtFn = ''

	for fn in [expand('~/.vim/colors/rgb-minimal.txt'), expand('~/.vim/colors/rgb.txt'), '/etc/X11/rgb.txt' ]
		if filereadable(fn)
			let s:rgbTxtFn=fn
		endif
	endfor

	if s:rgbTxtFn != ''
		for ll in readfile(s:rgbTxtFn)
			if ll =~ '^[[:space:]]*[0-9]'
				let s:csplit = split(ll, '[[:space:]]\+')
				let g:colorname_x_rgb[tolower(join(s:csplit[3:], ''))] = <SID>color(s:csplit[0], s:csplit[1], s:csplit[2])
			endif
		endfor
	endif
endif

fun <SID>parse_colorname(cname)
	if has_key(g:colorname_x_rgb, tolower(a:cname))
		return g:colorname_x_rgb[tolower(a:cname)]
	endif

	echohl WarningMsg | echo 'No such color "' . a:cname . '"' | echohl None
	return <SID>color("255","255","255")
endfun


" returns the palette index to approximate the 'rrggbb' hex string
fun <SID>rgb(rgb)
	if a:rgb =~ '^[0-9A-Fa-f]\{6\}$'
		let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
		let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
		let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

		return <SID>color(l:r, l:g, l:b)
	endif

	return <SID>parse_colorname(a:rgb)
endfun

" sets the highlighting for the given group
fun <SID>X(group, fg, bg, attr)
	let s:group = a:group
	let s:fg    = a:fg   == '' ? 'NONE' : <SID>rgb(a:fg)
	let s:bg    = a:bg   == '' ? 'NONE' : <SID>rgb(a:bg)
	let s:attr  = a:attr == '' ? 'NONE' : a:attr

	exec 'hi ' . s:group . ' cterm=' . s:attr . ' ctermfg=' . s:fg . ' ctermbg=' . s:bg
endfun

"""
""" And now the actual colors.
"""

call <SID>X("Normal", "cccccc", "000000", "")

" highlight groups
call <SID>X("Cursor", "708090", "f0e68c", "")
"CursorIM
"Directory
"DiffAdd
"DiffChange
"DiffDelete
"DiffText
"ErrorMsg
call <SID>X("VertSplit", "c2bfa5", "7f7f7f", "reverse")
call <SID>X("Folded", "ffd700", "4d4d4d", "")
call <SID>X("FoldColumn", "d2b48c", "4d4d4d", "")
"LineNr
call <SID>X("ModeMsg", "daa520", "", "")
call <SID>X("MoreMsg", "2e8b57", "", "")
"call <SID>X("NonText", "addbe7", "000000", "bold")
call <SID>X("Question", "00ff7f", "", "")
call <SID>X("SpecialKey", "9acd32", "", "")
call <SID>X("StatusLine", "c2bfa5", "000000", "reverse")
call <SID>X("StatusLineNC", "c2bfa5", "7f7f7f", "reverse")
call <SID>X("Title", "cd5c5c", "", "")
call <SID>X("Visual", "6b8e23", "f0e68c", "reverse")
"VisualNOS
call <SID>X("WarningMsg", "fa8072", "", "")
"WildMenu
"Menu
"Scrollbar
"Tooltip
"
"call <SID>X("IncSearch", "708090", "f0e68c", "")
"call <SID>X("Search", "f5deb3", "cd853f", "")
"call <SID>X("IncSearch", "708090", "",       "")
"call <SID>X("Search",    "",       "708090", "")
call <SID>X("Search", "506075", "", "")
call <SID>X("IncSearch",    "", "506075", "")

" syntax highlighting groups
call <SID>X("Constant", "ffa0a0", "", "")
call <SID>X("Identifier", "98fb98", "", "none")
call <SID>X("Statement", "f0e68c", "", "bold")
"DimGray
call <SID>X("perlPOD", "696969", "", "")
"DarkGray
call <SID>X("Comment", "a9a9a9", "", "")

" http://vimdoc.sourceforge.net/htmldoc/syntax.html#italic
" bold, underline, undercurl, reverse, inverse, italic, standout, NONE
" but italic is underline in xterm when resource *.vt100.italicULMode:true
"Wheat
"call <SID>X("String", "f5deb3", "", g:no_italics ? "" : "underline")
call <SID>X("String", "f5deb3", "", "underline")

call <SID>X("PreProc", "cd5c5c", "", "")
call <SID>X("Type", "bdb76b", "", "bold")
call <SID>X("Special", "ffdead", "", "")
"Underlined
call <SID>X("Ignore", "666666", "", "")
"Error
call <SID>X("Todo", "ff4500", "eeee00", "")

"""
""" Delete our temporary helper functions.
"""

delf <SID>X
delf <SID>rgb
delf <SID>color
delf <SID>rgb_color
delf <SID>rgb_level
delf <SID>rgb_number
delf <SID>grey_color
delf <SID>grey_level
delf <SID>grey_number
delf <SID>parse_colorname

" vim: set fdl=0 fdm=marker:
