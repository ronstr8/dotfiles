
unset -f __machineColor ;
function __machineColor() {
    ## Permutation of final 8-bit quad of the host's IP address.
    #colorseedstr="$(  hostname --ip-address | head -1 | grep -o '[0-9]\+$' )"

    ## Permutation of alphas in hostname, so all in a server
    ## group share the same prompt color.
    local colorseedstr="$( hostname -s | tr -cd '[:alpha:]' )" ;

    MD5SUM="$( which md5sum 2> /dev/null )" || MD5SUM="md5" ;

    ## Strip all non-digits.
    local colorseedint="$( echo $colorseedstr | $MD5SUM | tr -cd '[:digit:]' | sed -e 's/^0//;' )" ;

    ## Specify how many colors made available for the prompt.
    local colorcount=88 ;

    if [[ "$TERM" =~ '256' ]] ; then
        colorcount=176 ;
    fi

##    maybecolor="$( echo $colorseedstr | sed -e 's/[^[:digit:]]//g' -e 's/$/ % 16/' -e 's/^/scale=0; /' | bc )"
    local maybecolor="$(( colorseedint % colorcount ))" ;

    echo "${maybecolor#-}" ; ## abs()
}


unset -f bashprompt ; function bashprompt() {
        declare fgname="${1:-$( __machineColor )}" ;

        local NONE=0

        local BOLD=1
        local NORMAL=2
        local UNDERLINE=4
        local BLINK=5
        local REVERSE=7
        local INVISIBLE=8

        local GRAY=30
        local RED=31
        local GREEN=32
        local YELLOW=33
        local BLUE=34
        local MAGENTA=35
        local CYAN=36
        local WHITE=37
        local ORANGE=172
        local OLIVE_DRAB=65

        declare datetimef='%F %T' ## 'T' is ugly, '%z' unnecessary
        declare fgint fontstyle coloresc ;

        ## Bold if name is (a) all caps or (b) ends in a bang.

        [[ $fgname =~ (^[A-Z]+|!)$ ]] && fontstyle="$BOLD" || fontstyle="$NORMAL" ;

        ## Remove any trailing bang and normalize to uppercase.

		fgname=$( echo ${fgname%!} | tr '[a-z]' '[A-Z]' ) ;

        ## Integer names reference explicit color slots.  Else, check if we
        ## define the given name in termcap.bash.

        [[ $fgname =~ ^[0-9]+$ ]] && fgint="38;5;$fgname" || fgint=${!fgname} ;

##        coloresc="\[\e[38;5;${fgint}m\]\[\e[${fontstyle}m\]"
        coloresc="\[\e[${fgint};${fontstyle}m\]"

        export PS1="${coloresc}\n\D{${datetimef}} :: \w\n ${coloresc}\u@\h\$\[\e[${NONE}m\] "
}

