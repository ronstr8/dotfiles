
if ! pingLib ${BASH_SOURCE[0]} ; then

unset -f vless ;
function vless() {
	local params="$@" ;

	if ! tty --silent ; then
		params="${params} -" ;	
	fi

	eval "vim -R -c 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' $params" ;
}

touchLib ${BASH_SOURCE[0]} ; fi ;

