
if ! pingLib ${BASH_SOURCE[0]} ; then

    requireLib 'status' ;
    requireLib 'termcap' ;
    requireLib 'whinge' ;

### __machineColor
#       Echo integer representing an xterm-256color color "label" for the current host.
#
##
unset -f __machineColor ; function __machineColor() {
    ## Permutation of alphas in hostname, so all in a server
    ## group share the same prompt color.
    ## Not using [:alpha:] for compat on Solaris.
    declare colorseedstr="$( hostname | cut -d. -f1 | tr -cd '[a-z][A-Z]' )" ;

#   declare MD5SUM="$( which md5sum 2> /dev/null )" ;
#   : ${MD5SUM:=md5} ;

    ## Strip all non-digits.
    ## Not using [:digit:] for compat on Solaris.
    declare colorseedint="$( echo $colorseedstr | sum | tr -cd '[0-9]' )" ;
    colorseedint=${colorseedint##0} ;

    ## Specify how many colors made available for the prompt.
    declare -i colorcount=255 ; # 88 ;

    [[ $TERM =~ 256 ]] && colorcount=176

    declare maybecolor=$(( 7 + ( colorseedint % (colorcount-8) ) )) ;

    echo "${maybecolor#-}" ; ## Ersatz abs().
}

    export xcFF_NONE=0 ;
    export xcFF_BOLD=1 ;
    export xcFF_NORMAL=2 ;
    export xcFF_UNDERLINE=4 ;
    export xcFF_BLINK=5 ;
    export xcFF_REVERSE=7 ;
    export xcFF_INVISIBLE=8 ;
    export xcFF_GRAY=30 ;
    export xcFF_RED=31 ;
    export xcFF_GREEN=32 ;
    export xcFF_YELLOW=33 ;
    export xcFF_BLUE=34 ;
    export xcFF_MAGENTA=35 ;
    export xcFF_CYAN=36 ;
    export xcFF_WHITE=37 ;
    export xcFF_ORANGE=172 ;
    export xcFF_OLIVE_DRAB=65 ;


### bashprompt [NONE|GRAY|RED|GREEN|YELLOW|BLUE|CYAN|WHITE|{0..255}|...]
#       Set the primary color of the main command prompt.
#
#   Appending an exclamation mark to the color name/number will force the
#   prompt bold.   
#
# @param $colopt the desired fg color, defaults to __machineColor.
#
# @see terminfo(5)
# @see infocmp(1M)
##
unset -f bashprompt ; function bashprompt() {
    declare fgname="${1:-$( __machineColor )}" ;
    declare datetimef='%F %T' ; ## 'T' is ugly, '%z' unnecessary
    declare fgint fontWeight fontStyle ;

    ## Bold if name is (a) all caps or (b) ends in a bang.

    if [[ $fgname =~ ^[A-Z_]+$ ]] || [[ $fgname =~ !_?$ ]] ; then
        fontWeight="$xcFF_BOLD" ;
    else
        fontWeight="" ; # $xcFF_NORMAL" ;
    fi

    ## Normalize what remains to uppercase.

    fgname=$( echo ${fgname} | sed -e 's/(!_|_!)$/_/;' | tr 'a-z' 'A-Z' ) ;

    ## Italics/underlined if name is enclosed in underbars.

    [[ $fgname =~ ^_[A-Z]+_$ ]] && fontStyle="$xcFF_UNDERLINE" || fontStyle="" ;

    fgname=$( echo ${fgname} | sed -e 's/^_//; s/_$//;' ) ;

    ## Integer names reference explicit color slots.  Else, check if we
    ## define the given name in termcap.bash.

    [[ $fgname =~ ^[0-9]+$ ]] && fgint="38;5;$fgname" || fgint=${!fgname} ;

    if [[ -z "$fgint" ]] ; then
        whinge "Color name «$fgname» is not recognized.  Try these..." ;

        declare -a available ; read -a available <<< "${!xcFF_*}" ;
        printf "\t%s\n" "${available[@]#xcFF_}" >&2 ;

        return $RV_FAILURE ;
    fi

##  declare coloresc="\[\e[38;5;${fgint}m\]\[\e[${fontWeight}m\]"
    declare coloresc="\[\e[${fgint}${fontWeight:+;$fontWeight}${fontStyle:+;$fontStyle}m\]"

#   declare -i depth=$SHLVL ; [[ "$STY" ]] && let SHLVL+=2 ;
    declare    depthMarker=' ' ; # " $( printf '«%0.0s' $( seq 1 $depth ) ) " ;

    export PS1="${coloresc}\n\D{${datetimef}}${depthMarker}\w\n ${coloresc}\u@\h\$\[\e[${xcFF_NONE}m\] "
}

touchLib ${BASH_SOURCE[0]} ; fi ;

