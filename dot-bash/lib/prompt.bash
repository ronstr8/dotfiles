
if ! pingLib ${BASH_SOURCE[0]} ; then

    requireLib 'termcap' ;

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

## XXX Intended to escape for PS1, but doesn't work.  LATER. TODO
## unset -f __escesc ; function __escesc() { echo "$@" | awk '{ print gensub("\033", "\\\e", "g"); }' ; } ;

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

    declare fnstyle='' ; # "$xcFF_NORMAL" ;

    [[ $fgpref =~ (^[A-Z_]+|!)$ ]] && fnstyle=$( tput smso ) ; # "$xcFF_BOLD" ;

    declare fgattr=$( tr 'a-z' 'A-Z' <<< ${fgpref%!} ) ;
    
    declare ffPrefix='xcFF_' ;
    declare ffName="${ffPrefix}${fgattr}" ;

    declare setseq="$fnstyle" ; # "\[\e[${fnstyle};" ;
#   declare rstseq="$( tput oc )$( tput sgr0 )" ; # "\[\e[${xcFF_NONE}m\]" ;
    declare rstseq="$( tput sgr0 )" ; # "oc" does some weird shit.

    declare -i fncolor ;

    if [[ $fgattr =~ ^[0-9]+$ ]] ; then
        fncolor=$fgattr ;
    elif [[ "${!ffName}" ]] ; then
        fncolor="${!ffName}" ;
    else
        echo "Unknown embellishment '${fgattr}'.  Try one of these:" >&2 ;
        declare -a available ;
        read -a available <<< "${!xcFF_*}" ;
        printf "\t%s\n" "${available[@]#$ffPrefix}" >&2 ;

#        while read ; do
#            echo -e "\t${REPLY#$ffPrefix}" >&2 ;
#        done < <( printf '%s\n' "${!xcFF_*}" ) ;

        return 1 ;
    fi

#   setseq="${setseq}${fncolor}m\]" ;
    setseq="${setseq}$( tput setaf $(( fncolor - 30 )) )" ;

#   setseq="$( sed -e 's/\033/\\e/g;' <<< $setseq )" ; rstseq="$( sed -e 's/\033/\\e/g;' <<< $rstseq )" ;
#   setseq="$( __escesc "$setseq" )" ;
#   rstseq="$( __escesc "$rstseq" )" ;

    export PS1_HOST_COLOR_SEQUENCE="$setseq" ;
    export PS1_HOST_RESET_SEQUENCE="$rstseq" ;
    export PS1="${setseq}\n\D{${dtfmt}} :: \w\n ${setseq}\u@\h\$${rstseq} " ;
} ;

## unset -f bashprompt ; function bashprompt() { local fgname="$1" ; if [ ! "$fgname" ] ; then ; fgname="$( __machineColor )" ; fi ; local NONE=0 ; local BOLD=1 ; local NORMAL=2 ; local UNDERLINE=4 ; local BLINK=5 ; local REVERSE=7 ; local INVISIBLE=8 ; local GRAY=30 ; local RED=31 ; local GREEN=32 ; local YELLOW=33 ; local BLUE=34 ; local MAGENTA=35 ; local CYAN=36 ; local WHITE=37 ; local ORANGE=172 ; local OLIVE_DRAB=65 ; local datetimef='%F %T' local fgint ; local fontstyle ; local coloresc ; if [ $( echo $fgname | egrep '(^[A-Z]+|!)$' ) ] ; then ; fontstyle="$BOLD" ; else ; fontstyle="$NORMAL" ; fi ; fgname=$( echo $fgname | tr '[a-z]' '[A-Z]' | sed 's/!$//' ) ; if [ $( echo $fgname | egrep '^[0-9]+$' ) ] ; then ; fgint="38;5;$fgname" ; else ; fgint=${!fgname} ; fi ; coloresc="\[\e[38;5;${fgint}m\]\[\e[${fontstyle}m\]" ; coloresc="\[\e[${fgint};${fontstyle}m\]" ; export PS1_HOST_COLOR_SEQUENCE="${coloresc}" ; export PS1="${coloresc}\n\D{${datetimef}} :: \w\n ${coloresc}\u@\h\$\[\e[${NONE}m\] " ; } ;

unset -f bashprompt ;
function bashprompt() {
        ## bashprompt NONE|GRAY|RED|GREEN|YELLOW|BLUE|CYAN|WHITE

        local fgname="$1"

		if [ ! "$fgname" ] ; then
			fgname="$( __machineColor )"
		fi

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

        local datetimef='%F %T' ## 'T' is ugly, '%z' unnecessary

        local fgint
        local fontstyle
        local coloresc

        if [ $( echo $fgname | egrep '(^[A-Z]+|!)$' ) ] ; then
                fontstyle="$BOLD"
        else
                fontstyle="$NORMAL"
        fi

		fgname=$( echo $fgname | tr '[a-z]' '[A-Z]' | sed 's/!$//' )

        if [ $( echo $fgname | egrep '^[0-9]+$' ) ] ; then
                fgint="38;5;$fgname"
        else
                fgint=${!fgname}
        fi

##        coloresc="\[\e[38;5;${fgint}m\]\[\e[${fontstyle}m\]"
        coloresc="\[\e[${fgint};${fontstyle}m\]"

		export PS1_HOST_COLOR_SEQUENCE="${coloresc}"
        export PS1="${coloresc}\n\D{${datetimef}} :: \w\n ${coloresc}\u@\h\$\[\e[${NONE}m\] "
}

touchLib ${BASH_SOURCE[0]} ; fi ;

##  Color_Off="\[\033[0m\]"       # Text Reset
##
##  # Regular Colors
##  Black="\[\033[0;30m\]"        # Black
##  Red="\[\033[0;31m\]"          # Red
##  Green="\[\033[0;32m\]"        # Green
##  Yellow="\[\033[0;33m\]"       # Yellow
##  Blue="\[\033[0;34m\]"         # Blue
##  Purple="\[\033[0;35m\]"       # Purple
##  Cyan="\[\033[0;36m\]"         # Cyan
##  White="\[\033[0;37m\]"        # White
##
##  # Bold
##  BBlack="\[\033[1;30m\]"       # Black
##  BRed="\[\033[1;31m\]"         # Red
##  BGreen="\[\033[1;32m\]"       # Green
##  BYellow="\[\033[1;33m\]"      # Yellow
##  BBlue="\[\033[1;34m\]"        # Blue
##  BPurple="\[\033[1;35m\]"      # Purple
##  BCyan="\[\033[1;36m\]"        # Cyan
##  BWhite="\[\033[1;37m\]"       # White
##
##  # Underline
##  UBlack="\[\033[4;30m\]"       # Black
##  URed="\[\033[4;31m\]"         # Red
##  UGreen="\[\033[4;32m\]"       # Green
##  UYellow="\[\033[4;33m\]"      # Yellow
##  UBlue="\[\033[4;34m\]"        # Blue
##  UPurple="\[\033[4;35m\]"      # Purple
##  UCyan="\[\033[4;36m\]"        # Cyan
##  UWhite="\[\033[4;37m\]"       # White

