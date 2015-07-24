

unset -f curl-dmp ;
function curl-dmp() {
    local USAGE="Usage: curl-dmp <HttpMethod> <RequestUri> [ContentBody]" ;
    local method="${1:-Missing 
export xCID=11 ; export xCFN="xConsumer${xCID}.json" ; cat > $xCFN <<EOT && ( for hostPort in $( seq -fwebdmp%02g:8080 1 3 ) localhost:7980 localhost:6969 devex2:8080 ; do baseUrl="http://${hostPort}" ; echo -e "\n\n## $baseUrl \n\n" ; curl -i -H 'Content-Type: application/json' -X PATCH "${baseUrl}/i/consumer/11/" --data-binary @$xCFN ; done ) ; rm -f $xCFN ; unset xCID xCFN ; echo "xCID=$xCID ; xCFN=$xCFN" ;
{
  "id": "11",
  "is-sync-partner": "1",
  "name": "IndexExchange",
  "sync-cookie-id": "indexexchange",
  "aliases": "INDEXPLATFORM,IndexPlatform,Indexplatform,f78ab189d385625db486179bad69dde3,indexplatform" 
}
EOT

}
