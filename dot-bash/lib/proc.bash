
__resourceName='proc' ; if ! pingLib "$__resourceName" ; then

## xPostMortem - Display exit status of previous command.
##
##

function xPostMortem() {
    declare -i rv=${1:-$?} ;
    declare    meaning='' origin='' fgColor=$(( rv ? 1 : 2 )) ;
    
    (( rv )) && meaning='FAILURE'          || meaning='SUCCESS' ;
    (( $# )) && origin='explicitly passed' || origin='implied from $?' ;

    echo -e "\t$( tput setaf $fgColor )# $meaning ($rv), ${origin}.$( tput sgr0 )${disclaimer}" ;
} ;

touchLib "$__resourceName" ; unset __resourceName ; fi ;


