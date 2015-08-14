
__resourceName='prompt' ; if ! pingLib "$__resourceName" ; then

## __machineColor
#       Echo integer representing an xterm-256color color "label" for the current host.
#
##
unset -f __machineColor ; function __machineColor() {
    ## Permutation of alphas in hostname, so all in a server
    ## group share the same prompt color.
    declare colorseedstr="$( hostname -s | tr -cd '[:alpha:]' )" ;

    declare MD5SUM="$( which md5sum 2> /dev/null )" ;
    : ${MD5SUM:=md5} ;

    ## Strip all non-digits.
    declare -i colorseedint="$( echo $colorseedstr | $MD5SUM | tr -cd '[:digit:]' | sed -e 's/^0//;' )" ;

    ## Specify how many colors made available for the prompt.
    declare -i colorcount=88 ;

    [[ $TERM =~ 256 ]] && colorcount=176

    declare maybecolor=$(( colorseedint % colorcount )) ;

    echo "${maybecolor#-}" ; ## Ersatz abs().
}

## bashprompt [NONE|GRAY|RED|GREEN|YELLOW|BLUE|CYAN|WHITE|{0..255}|...]
#       Set the primary color of the main command prompt.
#
#   Appending an exclamation mark to the color name/number will force the
#   prompt bold.   
#
# @param $colopt the desired fg color, defaults to __machineColor.
# @needs termcap for xcFF_* color/style variables.
##
unset -f bashprompt ; function bashprompt() {
    declare fgpref="${1:-$( __machineColor )}"
    declare dtfmt='%F %T' ## 'T' is ugly, '%z' unnecessary.

    declare fnstyle="$xcFF_NORMAL" ;

    [[ $fgpref =~ (^[A-Z]+|!)$ ]] && fnstyle="$xcFF_BOLD" ;

    declare fgname=$( tr '[a-z]' '[A-Z]' <<< ${fgpref%!} ) ;
    declare fncolor ;

    if [[ $fgname =~ ^[0-9]+$ ]] ; then
        fncolor="35;5;$fgname" ;
    else
        declare ffName="xcFF_$fgname" ;
        fncolor=${!ffName} ;
    fi

    declare escseq="\[\e[${fncolor};${fnstyle}m\]" ;

    export PS1_HOST_COLOR_SEQUENCE="${escseq}" ;
    export PS1="${escseq}\n\D{${dtfmt}} :: \w\n ${escseq}\u@\h\$\[\e[${NONE}m\] " ;
}

needsLib 'termcap' ;
touchLib "$__resourceName" ; unset __resourceName ; fi ;


