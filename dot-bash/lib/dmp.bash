
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

needsLib 'whinge' ;

[[ -z "${DEFAULT_DMP_UID:-}"      ]] || declare -i -r DEFAULT_DMP_UID=12345678901234567890 ;
[[ -z "${DEFAULT_DMP_PORT_WWW:-}" ]] || declare -i -r DEFAULT_DMP_PORT_WWW=8080 ;
[[ -z "${DEFAULT_DMP_PORT_SSL:-}" ]] || declare -i -r DEFAULT_DMP_PORT_SSL=8443 ;

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
        
        if [[  $server =~ :([0-9]+)$ ]] ; then
            serverPort=${BASH_REMATCH[1]} ;
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
