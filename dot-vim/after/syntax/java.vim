" Overrides for standard system Java defs.
"

syn match javaError         "<<<\|\.\.\|=>\|||=\|&&=\|[^-]->\|\*\/"
syn match javaAnnotation    "@\([_$a-zA-Z][_$a-zA-Z0-9]*\.\)*[_$a-zA-Z][_$a-zA-Z0-9]*\>"

" syn match javaNumber        "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
" syn match javaNumber        "\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
" syn match javaNumber        "\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
" syn match javaNumber        "\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

" Added to support underscores as thousandths delimiters.
syn match javaNumber "\<\(\d\{1,3\}\)\(_\d\{3,3\}\)\+[lL]\=\>"

" Below must be a vim74 thing.
" syntax spell default

syn region javaFold              start="{" end="}" transparent fold
syn region javaDocTags contained start="{@\(code\|link\|linkplain\|inherit[Dd]oc\|doc[rR]oot\|value\)" end="}"

