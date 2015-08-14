
if ! pingLib ${BASH_SOURCE[0]} ; then

## Not happy with these:
##	* Should read stdin like anything else, not force its own RS
##	* Use raw int or length?  An option, e.g. --length?
##
## unset -f max ;
## function max() {
## 	echo $* | awk -vRS='[[:space:]]' '{ length>bb && bb=length } END { print bb }' 
## }
## 
## unset -f min ; 
## function min() {
## 	echo $* | awk -vRS='[[:space:]]' 'BEGIN { bb=99999 } { length<bb && bb=length } END { print bb }' 
## }

[[ -z "${__xSCALE}"  ]] && declare -r -i __xSCALE=12 ;
[[ -z "${__xMAXINT}" ]] && declare -r -i __xMAXINT=$(( 2 ** 62 )) ;
[[ -z "${__xMININT}" ]] && declare -r -i __xMININT=$(( xMAXINT * -1 )) ;

unset -f numSum ; function numSum() {
    declare -i answer=0 arg=0 ;
    declare    mapper='answer+=$arg' ;

    if [ $# -lt 1 ] || [ $# -eq 1 -a "$1" = '-' ] ; then
        while read arg  ; do eval $mapper ; done # answer+=$arg ; done
    else
        for arg in "$@" ; do eval $mapper ; done # answer+=$arg ; done
    fi

    echo $answer ; 
} ;

unset -f numMax ; function numMax() {
    declare answer='' arg=0 ;
    declare mapper='(( arg >= ${answer:-$__xMININT} )) && answer=$arg' ;

    if [ $# -lt 1 ] || [ $# -eq 1 -a "$1" = '-' ] ; then
        while read arg  ; do eval $mapper ; done # answer+=$arg ; done
    else
        for arg in "$@" ; do eval $mapper ; done # answer+=$arg ; done
    fi

    echo $answer ; 
} ;

unset -f numMin ; function numMin() {
    declare answer='' arg=0 ;
    declare mapper='(( arg <= ${answer:-$__xMAXINT} )) && answer=$arg' ;

    if [ $# -lt 1 ] || [ $# -eq 1 -a "$1" = '-' ] ; then
        while read arg  ; do eval $mapper ; done # answer+=$arg ; done
    else
        for arg in "$@" ; do eval $mapper ; done # answer+=$arg ; done
    fi

    echo $answer ; 
} ;

unset -f numBytes ; function numBytes() {
    declare    unitLabel='' unitScale='' blockSize=1 ;
    declare -i prettyPrint=0 ;

    declare gOpt ;
    gOpt=$( getopt -o "bhps:u:" -l "block-size:,bs:,help,pretty,scale:,units:" --name "$0" -- "$@" ) || return $? ;
    eval set -- "$gOpt" ;

    while true ; do case "$1" in
        --help|-h )
            echo "
Usage: $FUNCNAME [options]
    Take lines beginning with integers and report the sum in bytes.

    --bs=<n>    Assume input of the given block size.  Defaults to 1 byte.
    --units=<s> Report total in the given units, e.g. GB, Gb, GiB, Gib.
    --scale=<n> Show this any places after the decimal point.
    --pretty    Include thousands-place separators and units in output." ;
            return ;;

        --block-size|--bs  |-b ) blockSize=$2 ; shift 2 ;;
        --units     |--unit|-u ) unitLabel=$2 ; shift 2 ;;

        --scale  |-s ) unitScale=$2  ; shift 2 ;;
        --pretty |-p ) prettyPrint=1 ; shift   ;;

        -- ) shift ; break ;;
    esac ; done ;

    declare bytes ;

    if [[ $# -lt 1 ]] || [[ $# -eq 1 && $1 = '-' ]] ; then
        read bytes ;
    else
        bytes=$( echo "$@" | numSum ) ;
    fi

    bytes=$(( bytes * blockSize )) ; 

    declare -i unitPower=0 unitBase=1024 bitMultiplier=1;

    declare powerLabel ;

    if [[ -n "$unitLabel" ]] ; then
        if [[ ! "$unitLabel" =~ ^([kKmMgGtT])?((i)?([Bb]))?$ ]] ; then
            echo -ne "Invalid unit \"$unitLabel\". Try [KMGT]i?[Bb]\n\t" >&2 ;
            echo     "Example: KB/Kb/KiB/Kib == 1024/128/1000/125 bytes" >&2 ;

            return 2 ;
        fi

        powerLabel=${BASH_REMATCH[1]} ;

#       printf '%s\n' "${BASH_REMATCH[@]}" ;

        [[ -n "${BASH_REMATCH[3]}" ]] && unitBase=1000 ;
        [[ -n "${BASH_REMATCH[4]}" && ${BASH_REMATCH[4]} == 'b' ]] && bitMultiplier=8 ;

    elif (( prettyPrint > 0 )) ; then
        if   (( bytes < 1024*1024 )) ; then
            powerLabel='KB' ;
        elif (( bytes < 1024*1024*1024 )) ; then
            powerLabel='MB' ;
        elif (( bytes < 1024*1024*1024*1024 )) ; then
            powerLabel='GB' ;
        elif (( bytes < 1024*1024*1024*1024*1024 )) ; then
            powerLabel='TB' ;
        fi
    fi

    case "$powerLabel" in 
        [kK]* ) unitPower=1 ;;
        [mM]* ) unitPower=2 ;;
        [gG]* ) unitPower=3 ;;
        [tT]* ) unitPower=4 ;;
    esac

    declare unitDivisor=$(( unitBase ** unitPower )) ; # $( bc <<< "scale=$__xSCALE;$unitBase^$unitPower" ) ;

    if [[ -z "$unitScale" ]] ; then
        if   (( bytes < (unitDivisor) )) ; then
            unitScale=4 ;
        elif (( bytes < (unitDivisor * unitBase) )) ; then
            unitScale=3 ; 
        else
            unitScale=0 ;
        fi
    fi

    (( bitMultiplier != 1 )) && bytes=$( bc <<< "scale=$__xSCALE;$bytes*$bitMultiplier" ) ;

    declare units=$( bc <<< "scale=$unitScale;$bytes/$unitDivisor" ) ;

    (( prettyPrint == 0 )) && echo $units || printf "%'.*f%s\n" $unitScale $units "${unitLabel:-$powerLabel}" ;
} ;


touchLib ${BASH_SOURCE[0]} ; fi ;


