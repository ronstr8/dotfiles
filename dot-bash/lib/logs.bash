
__resourceName='logs' ; if ! pingLib "$__resourceName" ; then

unset -f mrl ;
function mrl() {
	## @TODO Break out log glob logic from tdl, find most recent log/file.
	tdl $*
}

unset -f tdl ;
function tdl() {
	local logType="$1" ;

	local DEFAULT_DMP_HOME="/opt/adiant/dmp" ;

	local dmpLogPrefix="${DMP_HOME-$DEFAULT_DMP_HOME}/var/log/dmp" ;

	if [ -d "$dmpLogPrefix" ] ; then
		local altLogPrefix='./usr/var/log/dmp' ;
		[ -d "$altLogPrefix" ] && dmpLogPrefix="$altLogPrefix" ;
	fi

	local today="$( date +%Y%m%d )" ;
	local matchingGlob="" ;

	if [ "$logType" ] ; then
		case "$logType" in
			dmp-access )
				matchingGlob="${dmpLogPrefix}/*-$today-access.log" ;;
			dmp-message )
				matchingGlob="${dmpLogPrefix}/*-$today-message.log" ;;
			dmp-warning )
				matchingGlob="${dmpLogPrefix}/*-$today-warning.log" ;;
		esac

		if [ ! "$matchingGlob" ] ; then
			echo "Available log types are dmp-access, dmp-message, and dmp-warning." 1>&2 ;
			return 1 ;
		fi
	else
		logType='(basedir)' ;
		matchingGlob="${dmpLogPrefix}/*-$today-*.log" ;
	fi

	local matchingFiles="$( ls -U $matchingGlob 2>/dev/null )" ;

	if [ ! "$matchingFiles" ] ; then
		echo "No today-log for «$logType» found in glob «$matchingGlob»." 1>&2 ;
		return 1 ;
	fi

	echo $matchingFiles ;
}

touchLib "$__resourceName" ; unset __resourceName ; fi ;

