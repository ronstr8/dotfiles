
if ! pingLib ${BASH_SOURCE[0]} ; then

unset -f urldecode ; function urldecode() {
    perl -p -e 's/%([0-9A-F]{2})/chr(hex($1))/gie;' ;
} ;

touchLib ${BASH_SOURCE[0]} ; fi ;


