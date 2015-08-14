
__resourceName='vless' ; if ! pingLib "$__resourceName" ; then

unset -f vless ;
function vless() {
	local params="$@" ;

	if ! tty --silent ; then
		params="${params} -" ;	
	fi

	eval "vim -R -c 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' $params" ;
}

touchLib "$__resourceName" ; unset __resourceName ; fi ;

