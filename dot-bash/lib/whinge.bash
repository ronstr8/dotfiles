### whinge
###      Utilities for reporting exceptional conditions to the user.
#
## -- 
## Ronald E. Straight <straightre@gmail.com>

if ! pingLib ${BASH_SOURCE[0]} ; then

needsLib 'proc' ;
needsLib 'status' ;
needsLib 'truth' ;

unset -f __digitOr ; function __digitOr() {
    declare ifNot=$1 ;
    declare maybe=$2 ;
    declare isDigit=${maybe:-${maybe//[0123456789]+}} ;

    echo ${isDigit:-$maybe} ;

    return $(( ${isDigit:-0} ? RV_SUCCESS : RV_NAN )) ;
}

### whinge [$statusCode] $fmtMsg ${fmtArgs[@]}
###     Print a message to stderr.
#
#   If every character of the first argument isdigit, use that as the return
#   value.  Else, use whatever the value of $? was upon invocation of the
#   function, which may not be the expected behavior.  The $statusCode is
#   intended primarily for calls by the croak() function.
#
# @param $statusCode is the value returned
# @param $fmtMsg is the format for the bash printf builtin
# @param $fmtArgs follow the format in the printf call
#
# @return $statusCode as per this function description
#
# @see ./status.bash
# @see ./whinge.bash#croak()
##
unset -f whinge ; function whinge() {
    declare statusCode ;
    statusCode=$( __digitOr $? "$1" ) && shift ;

    declare fmtMsg="${1:?Need a printf-style format or literal message.}" ; shift ;
    
    if [ "$*" ] ; then
        fmtMsg=$( printf "$fmtMsg" "$@" ) ;
    fi ;

    echo "# [$( date -Is )] $fmtMsg" 1>&2 ;

    return $statusCode ;
}

### croak [$statusCode] $fmtMsg ${fmtArgs[@]}
###     Print a message to stderr, then exit.
#
#   If every character of the first argument isdigit, use that as the return
#   value or exit code.  Else, use $RV_FAILURE from status.bash.
#
#   The default behavior should be to exit with $statusCode, but I can't
##  figure out how to prevent that from happening during an interactive shell
##  session, e.g. from sourced function serving as a command.
#
# @param $statusCode is the value returned
# @param $fmtMsg is the format for the bash printf builtin
# @param $fmtArgs follow the format in the printf call
#
# @return $statusCode as per this function description
#
# @see ./status.bash
# @see ./whinge.bash#whinge()
##
unset -f croak  ; function croak() {
    declare statusCode ;
    statusCode=$( __digitOr $RV_FAILURE "$1" ) && shift ;

    whinge $statusCode "$@" ;

    ## XXX exit one day.
} ;

touchLib ${BASH_SOURCE[0]} ; fi ;

