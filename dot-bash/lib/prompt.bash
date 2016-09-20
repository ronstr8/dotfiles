
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

## XXX Intended to escape for PS1, but doesn't work.  LATER. TODO
## unset -f __escesc ; function __escesc() { echo "$@" | awk '{ print gensub("\033", "\\\e", "g"); }' ; } ;

### bashprompt [NONE|GRAY|RED|GREEN|YELLOW|BLUE|CYAN|WHITE|{0..255}|...]
#       Set the primary color of the main command prompt.
#
#   Appending an exclamation mark to the color name/number will force the
#   prompt bold.   
#
# @param $colopt the desired fg color, defaults to __machineColor.
# @needs termcap for xcFF_* color/style variables.
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

##### unset -f bashprompt ; function bashprompt() {
#####     declare fgPref="${1:-$( __machineColor )}"
#####     declare dtfmt='%F %T' ## 'T' is ugly, '%z' unnecessary.
##### 
#####     declare fnstyle='' ; # "$xcFF_NORMAL" ;
##### 
#####     [[ $fgPref =~ (^[A-Z_]+|!)$ ]] && fnstyle=$xcFF_BOLD ; # $( tput smso ) ; # "$xcFF_BOLD" ;
##### 
#####     declare fgAttr=$( tr 'a-z' 'A-Z' <<< ${fgPref%!} ) ;
#####     
#####     declare ffPrefix='xcFF_' ;
#####     declare ffName="${ffPrefix}${fgAttr}" ;
##### 
#####     declare setSeq="\[\e[${fnstyle};" ; # "$fnstyle" ; # "\[\e[${fnstyle};" ;
#####     declare rstSeq="$( tput sgr0 )" ; # "oc" does some weird shit.
##### 
#####     declare -i fncolor ;
##### 
#####     if [[ $fgAttr =~ ^[0-9]+$ ]] ; then
#####         fncolor=$fgAttr ;
#####     elif [[ "${!ffName}" ]] ; then
#####         fncolor="${!ffName}" ;
#####     else
#####         echo "Unknown embellishment '${ffName}'.  Try one of these:" >&2 ;
#####         declare -a available ;
#####         read -a available <<< "${!xcFF_*}" ;
#####         printf "\t%s\n" "${available[@]#$ffPrefix}" >&2 ;
##### 
##### #        while read ; do
##### #            echo -e "\t${REPLY#$ffPrefix}" >&2 ;
##### #        done < <( printf '%s\n' "${!xcFF_*}" ) ;
##### 
#####         return 1 ;
#####     fi
##### 
#####     setSeq="${setSeq}${fncolor}m\]" ;
##### #   setSeq="${setSeq}$( tput setaf $(( fncolor - 30 )) )" ;
##### 
#####     declare -i eSHLVL=$(( SHLVL - ${STY:+1} - 1 )) ;
#####     declare    iSHLVL="" ;
##### 
#####     if (( eSHLVL )) ; then
#####         iSHLVL="$( tput setaf 1 )$( tput sitm ) «login+$(( eSHLVL ))»${rstSeq}$( tput ritm )" ;
#####     fi
##### 
#####     export PS1="${setSeq}\n\D{${dtfmt}} :: \w${iSHLVL}\n ${setSeq}\u@\h\$${rstSeq} " ;
##### } ;


# unset -f bashprompt ; function bashprompt() { local fgname="$1" ; if [ ! "$fgname" ] ; then ; fgname="$( __machineColor )" ; fi ; local NONE=0 ; local BOLD=1 ; local NORMAL=2 ; local UNDERLINE=4 ; local BLINK=5 ; local REVERSE=7 ; local INVISIBLE=8 ; local GRAY=30 ; local RED=31 ; local GREEN=32 ; local YELLOW=33 ; local BLUE=34 ; local MAGENTA=35 ; local CYAN=36 ; local WHITE=37 ; local ORANGE=172 ; local OLIVE_DRAB=65 ; local datetimef='%F %T' local fgint ; local fontstyle ; local coloresc ; if [ $( echo $fgname | egrep '(^[A-Z]+|!)$' ) ] ; then ; fontstyle="$BOLD" ; else ; fontstyle="$NORMAL" ; fi ; fgname=$( echo $fgname | tr '[a-z]' '[A-Z]' | sed 's/!$//' ) ; if [ $( echo $fgname | egrep '^[0-9]+$' ) ] ; then ; fgint="38;5;$fgname" ; else ; fgint=${!fgname} ; fi ; coloresc="\[\e[38;5;${fgint}m\]\[\e[${fontstyle}m\]" ; coloresc="\[\e[${fgint};${fontstyle}m\]" ; export PS1_HOST_COLOR_SEQUENCE="${coloresc}" ; export PS1="${coloresc}\n\D{${datetimef}} :: \w\n ${coloresc}\u@\h\$\[\e[${NONE}m\] " ; } ;

touchLib ${BASH_SOURCE[0]} ; fi ;

