
if ! pingLib ${BASH_SOURCE[0]} ; then

## xPostMortem - Display exit status of previous command.
#
# Echoes colored output describing the result of a command.
#
# @param rv is the return value/exit code, default $?
# @return the examined value.
##
unset -f xPostMortem ; function xPostMortem() {
    declare -i rv=${1:-$?} ;
    declare    meaning='' origin='' fgColor=$(( rv ? 1 : 2 )) ;
    
    (( rv )) && meaning='FAILURE'          || meaning='SUCCESS' ;
    (( $# )) && origin='explicitly passed' || origin='implied from $?' ;

    echo -e "\t$( tput setaf $fgColor )# $meaning ($rv), ${origin}.$( tput sgr0 )${disclaimer}" ;
    return $rv ;
} ;

## __hh2fd
#
# @param hh is either a name (e.g. "stdin") or a file descriptor  (e.g. 0)
# @return the file descriptor described by the given word.
##
unset -f __std2fd ; function __std2fd() {
    declare hh=$1 ;

    case "$1" in 
        0 | stdin  | STDIN  ) echo 0 ; return 0 ;;
        1 | stdout | STDOUT ) echo 1 ; return 0 ;;
        2 | stderr | STDERR ) echo 2 ; return 0 ;;
    esac

    return 1 ;
} ;

## isPiped
#
# @param hh is the handle to check: stdin/0 (default), also stdout/1, stderr/2)
# @return true if handle is connected to a pipe.
##
unset -f isPiped ; function isPiped() {
    declare -i fd=$( __std2fd "${1:-stdin}" ) ;
    [[ -p /dev/fd/$fd ]] ;
} ;

## isInteractive
#
# @param hh is the handle to check: stdin/0 (default), also stdout/1, stderr/2)
# @return true if handle is from a terminal/interactive input.
##
unset -f isInteractive ; function isInteractive() {
    declare -i fd=$( __std2fd "${1:-stdin}" ) ;
    [[ -t $fd ]] ;
} ;

## isRedirected
#
# @param hh is the handle to check: stdin/0 (default), also stdout/1, stderr/2)
# @return true if handle is from a redirection.
##
unset -f isRedirected ; function isRedirected() {
    declare -i fd=$( __std2fd "${1:-stdin}" ) ;
    [[ ! -t $fd && ! -p /dev/fd/$fd ]] ;
} ;

## readArgs
#
# Collect passed arguments and input from a pipe or redirection into an array
# for the caller to process.  A single arg of '-' presumes input is waiting in
# stdin.  If not, echo a message to stderr and return a failure value.
#
# If no arguments or no '-', read anything waiting in a pipe or redirect and
# append that to the array to be returned.
#
# @stdout an array of arguments for the caller.
##
unset -f readArgs ; function readArgs() {
    declare -i expectInput=0 requireInput=0 gotInput=0;
    declare -a args ;

    if [[ $# -eq 1 && $1 = '-' ]] ; then
        expectInput=1 ;
        requireInput=1 ;
    elif (( $# )) ; then
        args=( "$@" ) ; # declare arg ; for arg in "$@" ; do args[${#args[@]}]="$arg" ; done

        if isPiped || isRedirected ; then
            expectInput=1 ;
        fi
    else
        expectInput=1 ;
    fi

    if (( expectInput )) ; then
        declare readCommand='read ' ;
        isRedirected && readCommand+=' -u0' ;

        while $readCommand ; do gotInput=1 ;
            args[${#args[@]}]="$REPLY" ;
        done
    fi

    if (( requireInput && !gotInput )) ; then
        echo "Expected input (e.g. from an '-' argument) but got none." ;
        return 1 ;
    fi

    echo ${args[@]} ;
} ;

touchLib ${BASH_SOURCE[0]} ; fi ;
