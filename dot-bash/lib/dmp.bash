
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
    declare -i sslPort=$DEFAULT_DMP_PORT_WWW ; 
    declare -a servers=( "$@" ) ;
    
    declare __tuid=${uId-$DEFAULT_UID} ;

    declare baseCmdline='curl' ;
    baseCmdline+=" -b '__tuid=$__tuid' " ; ## Cookie tracking user-id.
    baseCmdline+=' -k ' ; ## Allow "insecure" connections with bad SSL cred.
    baseCmdline+=' -i ' ; ## Include headers.

    ## TODO Option for Connection: keep-alive?

    declare server requestCmdline ;

    for server in "${servers[@]}" ; do
        if [[ ! $server =~ :[0-9]+$ ]] ; then
            server+=":$wwwPort" ;
        fi
        
        requestCmdline="$baseCmdline '$server'" ;

        eval "$requestCmdline" ;
    done
}

touchLib ${BASH_SOURCE[0]} ; fi ;
