
if ! pingLib ${BASH_SOURCE[0]} ; then

needsLib 'proc' ;

unset -f vless ; function vless() {
	local -a params="$@" ;

    if [[ $# -ne 1 || "$1" != '-' ]] && ( isPiped || isRedirected ) ; then
		params[${#params[@]}]='-' ;
    fi

	eval "vim -n -R -c 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' ${params[@]}" ;
}

touchLib ${BASH_SOURCE[0]} ; fi ;

