
__resourceName='elinks' ; if ! pingLib "$__resourceName" ; then

unset -f elinks-dump ;
function elinks-dump() {
	local uri="$1" ;
	local fileName="$2" ;

	if [ ! "$uri" ] ; then
		echo "Missing required argument of a URI to dump" >/dev/stderr ;
		return ;
	fi

	if [ ! "$fileName" ] ; then
		fileName="$( basename "$uri" .html ).txt" ;
	fi

	elinks -dump -no-references -no-numbering "$uri" > "$fileName" ;
}

touchLib "$__resourceName" ; unset __resourceName ; fi ;

