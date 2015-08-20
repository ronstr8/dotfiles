" Vim syntax file
" Language:	gnu readline history
" Maintainer:	Ronald E. Straight <straightre@gmail.com>
" Filenames:	.historyrl.*
" Last Change:	2015 Aug 18

if exists("b:current_syntax")
  finish
endif

"runtime! syntax/mail.vim
unlet!   b:current_syntax

" Format of a history line with HISTTIMEFORMAT defined:
"
"   173  [2015-05-15T10:26:06] git status
"
" HISTTIMEFORMAT Can be just about anything (or nothing!), so matching that
" element is tricky.  While \([-+0-9T:.APMZ ]\+\) loosely catches RFC-3339,
" we can't rely on that.  So, we'll grab the value of the HISTTIMEFORMAT
" environemnt variable at runtime, and if its first and last characters aren't
" word-characters, we'll use those as the border.  Otherwise, we'll skip ahead
" until we see a word character, assuming it signals the beginning of the
" actual command stored in the history.

" Skeleton of this file taken from gitsendemail.vim by Tim Pope.

"" XXX +++ For future reference.  No time for full implementation now. XXX
" let histTimeFormat = $HISTTIMEFORMAT
" syn region historyrlLineNr     start="^\s\*\(\d+\)\s\+\[\([-+0-9T:.APMZ ]\+\\)]
" syn region historyrlTstamp  start=/\%(^diff --\%(git\|cc\|combined\) \)\@=/ end=/^-- %/ fold contains=@gitsendemailDiff
"
" syn case match
"
" syn match   gitsendemailComment "\%^From.*#.*"
" syn match   gitsendemailComment "^GIT:.*"

" hi def link gitsendemailComment Comment
"" XXX --- For future reference.  No time for full implementation now. XXX

" @see :so $VIMRUNTIME/syntax/hitest.vim

syn match historyrlLineNr  "^\s\+\(\d\+\)"
syn match historyrlTstamp  "\s\+\[[^]]\+\]"
syn match historyrlCommand "\$\s\+\w.\+$"

hi def link historyrlLineNr  PreProc
hi def link historyrlTstamp  Comment
hi def link historyrlCommand String

let b:current_syntax = "historyrl"

