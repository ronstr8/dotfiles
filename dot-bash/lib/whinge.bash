### whinge
###      Utilities for reporting exceptional conditions to the user.
#
## -- 
## Ronald E. Straight <straightre@gmail.com>

if ! pingLib ${BASH_SOURCE[0]} ; then

needsLib 'portability' ;

unset -f __digitOr ; function __digitOr() {
    declare ifNot=$1 ;
    declare maybe=$2 ;
    declare hasNonDigits=${maybe:+${maybe//[0123456789]+}} ;

    if [[ -z "$maybe" ]] ;then
        echo $ifNot ;
        return $RV_FALSE ; 
    elif [[ -n "$hasNonDigits" ]] ; then
        echo $ifNot ;
        return $RV_FALSE ; 
    else 
        echo $maybe ;
        return $RV_TRUE ;
    fi
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

    echo "# [$( date-Is )] $fmtMsg" 1>&2 ;

    return $statusCode ;
}

### croak [$statusCode] $fmtMsg ${fmtArgs[@]}
###     Print a message to stderr, then exit.
#
#   If every character of the first argument isdigit, use that as the return
#   value or exit code.  Else, use $RV_FAILURE from status.bash.
#
#   The default behavior is to exit with $statusCode. If this function is
#   called from an interactive shell (e.g. with `source' or `eval') and that
#   shell is the one that invoked this process, the _user will be logged out_.
#   That is unlikely to be the intended behaviour, so any code you write which
#   invokes a croak() should take precautions against that.  The simplest way
#   to do so is to run your code in a subshell.  For example:
#
#   ( __main $* )
#
#   ... wherein any code which may call croak() is in the __main() function.
#   Thus, when croak() exits, it exits that parenthetical subshell and not the
#   shell of the invoking user.
#
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

