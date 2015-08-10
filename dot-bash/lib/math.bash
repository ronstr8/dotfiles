
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

unset -f toBytes ; function toBytes() {
    declare -i bytes=0 ; while read ; do bytes+=$REPLY ; done ;

    declare    unitSpec='' unitScale='2' blockSize=1 ;
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

        --block-size|--bs|-b ) blockSize=$2 ; shift 2 ;;

        --scale    |-s ) unitScale=$2  ; shift 2 ;;
        --unit{,s} |-u ) unitSpec=$2   ; shift 2 ;;
        --pretty   |-p ) prettyPrint=1 ; shift   ;;

        -- ) shift ; break ;;
    esac ; done ;

    bytes=$(( bytes * blockSize )) ; 

    declare -i unitPower=1 unitBase=1024 bitDivisor=1;
    declare    unitLabel=${unitSpec:-KB} ;

    if [[ -n "$unitLabel" ]] ; then
        if [[ ! "$unitLabel" =~ ^([kKmMgGtT])?((i)?([Bb]))?$ ]] ; then
            echo -ne "Invalid unit \"$unitLabel\". Try [KMGT]i?[Bb]\n\t" >&2 ;
            echo     "Example: KB/Kb/KiB/Kib == 1024/128/1000/125 bytes" >&2 ;

            return 2 ;
        fi

        declare powerLabel=${BASH_REMATCH[1]} ;

        printf '%s\n' "${BASH_REMATCH[@]}" ;

        [[ -n "${BASH_REMATCH[3]}" ]] && unitBase=1000 ;
        [[ -n "${BASH_REMATCH[4]}" && ${BASH_REMATCH[4]} == 'b' ]] && bitDivisor=8 ;

        case "$powerLabel" in 
            [kK] ) unitPower=1 ;;
            [mM] ) unitPower=2 ;;
            [gG] ) unitPower=3 ;;
            [tT] ) unitPower=4 ;;
        esac
    fi

    echo "bytes=$bytes;unitScale=$unitScale;unitBase=$unitBase;unitPower=$unitPower;bitDivisor=$bitDivisor" ;

    declare units=$( bc <<< "scale=$unitScale;$bytes/($unitBase^$unitPower)/$bitDivisor" ) ;

    (( prettyPrint == 0 )) && echo $units || printf "%'.*f %s\n" $unitScale $units "$unitLabel" ;
} ;


