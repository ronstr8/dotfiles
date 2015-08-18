"" Syntax wrapper for `git annotate` output.
"
" A Git annotation (by default) looks like this:
"       0e68a16e (apache.devex       2013-05-28 09:25:18 +0000   1)
"
" The vim syntax directive below works in an after/syntax/php.vim file, except
" for multi-line strings.
"
"       syn match phpComment "^[0-9a-fA-F]\{8\} ([^)]\+[[:space:]][0-9]\+)"
""

syn include syntax/php.vim
syn match phpComment "^[0-9a-fA-F]\{8\} ([^)]\+[[:space:]][0-9]\+)"

