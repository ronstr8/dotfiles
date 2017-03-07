
if ! pingLib ${BASH_SOURCE[0]} ; then

    requireLib 'status' ;
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

    # These are interpolated into raw code sequences such as:
    #   [<ESC>[38;5;${xcFF_RED}m][<ESC>[${xcFF_BOLD}m]]
    # TODO: Callers should be using tput or some abstraction thereof.
    declare xcFF_NONE=0 ;
    declare xcFF_BOLD=1 ;
    declare xcFF_NORMAL=2 ;
    declare xcFF_UNDERLINE=4 ;
    declare xcFF_BLINK=5 ;
    declare xcFF_REVERSE=7 ;
    declare xcFF_INVISIBLE=8 ;
    declare xcFF_GRAY=30 ;
    declare xcFF_RED=31 ;
    declare xcFF_GREEN=32 ;
    declare xcFF_YELLOW=33 ;
    declare xcFF_BLUE=34 ;
    declare xcFF_MAGENTA=35 ;
    declare xcFF_CYAN=36 ;
    declare xcFF_WHITE=37 ;
    declare xcFF_ORANGE=172 ;
    declare xcFF_OLIVE_DRAB=65 ;


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

    declare -i depth=$(( SHLVL - 1 )) ; ## "1" is first level w/no subshells.
    [[ "$STY" ]] && let depth-- ;

    declare depthMarker='' ;
    (( depth > 0 )) && depthMarker=${depth:+ [$depth]} ;

    export PS1="${coloresc}\n\D{${datetimef}} \w${depthMarker}\n${coloresc}\u@\h\$\[\e[${xcFF_NONE}m\] " ;
}

touchLib ${BASH_SOURCE[0]} ; fi ;

## 	# Reset
## 	Color_Off="\[\033[0m\]"       # Text Reset
## 
## 	# Regular Colors
## 	Black="\[\033[0;30m\]"        # Black
## 	Red="\[\033[0;31m\]"          # Red
## 	Green="\[\033[0;32m\]"        # Green
## 	Yellow="\[\033[0;33m\]"       # Yellow
## 	Blue="\[\033[0;34m\]"         # Blue
## 	Purple="\[\033[0;35m\]"       # Purple
## 	Cyan="\[\033[0;36m\]"         # Cyan
## 	White="\[\033[0;37m\]"        # White
## 
## 	# Bold
## 	BBlack="\[\033[1;30m\]"       # Black
## 	BRed="\[\033[1;31m\]"         # Red
## 	BGreen="\[\033[1;32m\]"       # Green
## 	BYellow="\[\033[1;33m\]"      # Yellow
## 	BBlue="\[\033[1;34m\]"        # Blue
## 	BPurple="\[\033[1;35m\]"      # Purple
## 	BCyan="\[\033[1;36m\]"        # Cyan
## 	BWhite="\[\033[1;37m\]"       # White
## 
## 	# Underline
## 	UBlack="\[\033[4;30m\]"       # Black
## 	URed="\[\033[4;31m\]"         # Red
## 	UGreen="\[\033[4;32m\]"       # Green
## 	UYellow="\[\033[4;33m\]"      # Yellow
## 	UBlue="\[\033[4;34m\]"        # Blue
## 	UPurple="\[\033[4;35m\]"      # Purple
## 	UCyan="\[\033[4;36m\]"        # Cyan
## 	UWhite="\[\033[4;37m\]"       # White
## 
## 	# Background
## 	On_Black="\[\033[40m\]"       # Black
## 	On_Red="\[\033[41m\]"         # Red
## 	On_Green="\[\033[42m\]"       # Green
## 	On_Yellow="\[\033[43m\]"      # Yellow
## 	On_Blue="\[\033[44m\]"        # Blue
## 	On_Purple="\[\033[45m\]"      # Purple
## 	On_Cyan="\[\033[46m\]"        # Cyan
## 	On_White="\[\033[47m\]"       # White
## 
## 	# High Intensty
## 	IBlack="\[\033[0;90m\]"       # Black
## 	IRed="\[\033[0;91m\]"         # Red
## 	IGreen="\[\033[0;92m\]"       # Green
## 	IYellow="\[\033[0;93m\]"      # Yellow
## 	IBlue="\[\033[0;94m\]"        # Blue
## 	IPurple="\[\033[0;95m\]"      # Purple
## 	ICyan="\[\033[0;96m\]"        # Cyan
## 	IWhite="\[\033[0;97m\]"       # White
## 
## 	# Bold High Intensty
## 	BIBlack="\[\033[1;90m\]"      # Black
## 	BIRed="\[\033[1;91m\]"        # Red
## 	BIGreen="\[\033[1;92m\]"      # Green
## 	BIYellow="\[\033[1;93m\]"     # Yellow
## 	BIBlue="\[\033[1;94m\]"       # Blue
## 	BIPurple="\[\033[1;95m\]"     # Purple
## 	BICyan="\[\033[1;96m\]"       # Cyan
## 	BIWhite="\[\033[1;97m\]"      # White
## 
## 	# High Intensty backgrounds
## 	On_IBlack="\[\033[0;100m\]"   # Black
## 	On_IRed="\[\033[0;101m\]"     # Red
## 	On_IGreen="\[\033[0;102m\]"   # Green
## 	On_IYellow="\[\033[0;103m\]"  # Yellow
## 	On_IBlue="\[\033[0;104m\]"    # Blue
## 	On_IPurple="\[\033[10;95m\]"  # Purple
## 	On_ICyan="\[\033[0;106m\]"    # Cyan
## 	On_IWhite="\[\033[0;107m\]"   # White


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


