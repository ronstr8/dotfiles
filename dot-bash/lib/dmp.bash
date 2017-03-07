
if ! pingLib ${BASH_SOURCE[0]} ; then


## unset -f curl-dmp ; function curl-dmp() {
##     local USAGE="Usage: curl-dmp <HttpMethod> <RequestUri> [ContentBody]" ;
##     local method=${1:-Missing HTTP request method} ;
##     export xCID=11 ; export xCFN="xConsumer${xCID}.json" ; cat > $xCFN <<EOT && ( for hostPort in $( seq -fwebdmp%02g:8080 1 3 ) localhost:7980 localhost:6969 devex2:8080 ; do baseUrl="http://${hostPort}" ; echo -e "\n\n## $baseUrl \n\n" ; curl -i -H 'Content-Type: application/json' -X PATCH "${baseUrl}/i/consumer/11/" --data-binary @$xCFN ; done ) ; rm -f $xCFN ; unset xCID xCFN ; echo "xCID=$xCID ; xCFN=$xCFN" ;
## {
##   "id": "11",
##   "is-sync-partner": "1",
##   "name": "IndexExchange",
##   "sync-cookie-id": "indexexchange",
##   "aliases": "INDEXPLATFORM,IndexPlatform,Indexplatform,f78ab189d385625db486179bad69dde3,indexplatform" 
## }
## EOT

[[ -z "${DEFAULT_DMP_UID:-}"      ]] || declare -i -r DEFAULT_DMP_UID=12345678901234567890 ;
[[ -z "${DEFAULT_DMP_PORT_WWW:-}" ]] || declare -i -r DEFAULT_DMP_PORT_WWW=8080 ;
[[ -z "${DEFAULT_DMP_PORT_SSL:-}" ]] || declare -i -r DEFAULT_DMP_PORT_SSL=8443 ;

unset -f mrl ; function mrl() {
	## @TODO Break out log glob logic from tdl, find most recent log/file.
	tdl $*
}

unset -f tdl ; function tdl() {
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

function dmp-benchmark() {
    declare uId path ;

    if [[ $1 =~ ^[0-9]+$ ]] ; then
        uId=$1 ; shift ;
    fi

    if [[ $1 =~ ^/ ]] ; then
        path=$1 ; shift ;
    fi

    declare -i iterations=10000 ;
    declare -i napMillis=1 ;

    declare -i wwwPort=$DEFAULT_DMP_PORT_WWW ; 
    declare -i sslPort=$DEFAULT_DMP_PORT_SSL ; 
    declare -a servers=( "$@" ) ;
    
    declare baseCmdline='curl' ;
    baseCmdline="${baseCmdline} -b '__tuid=${uId:-$DEFAULT_DMP_UID}' " ; ## Cookie tracking user-id.
    baseCmdline="${baseCmdline} -k " ; ## Allow "insecure" connections with bad SSL cred.
    baseCmdline="${baseCmdline} -i " ; ## Include headers.

    ## TODO Option for Connection: keep-alive?

    declare server requestCmdline serverPort ;

    for server in "${servers[@]}" ; do
        serverPort=$wwwPort ;
        
        if [[  $server =~ :[0-9]+$ ]] ; then
            serverPort=$( echo $server | cut -d: -f2 ) ;
        else
            serverPort=$wwwPort ;
            serverPort="${server}:${serverPort}" ;
        fi

        if [[ ! $server =~ ^https?:// ]] ; then
            if [[ $serverPort =~ 43$ ]] ; then
                server="https://$server" ;
            else
                server="http://$server" ;
            fi
        fi
 
        server="${server}${path}" ;

        requestCmdline="$baseCmdline '$server'" ;

        whinge "$requestCmdline" ;
        eval "$requestCmdline" ;
    done
}

touchLib ${BASH_SOURCE[0]} ; fi ;
