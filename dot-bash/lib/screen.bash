
if ! pingLib ${BASH_SOURCE[0]} ; then

#needsLib 'session' ;

# alias screen-mrenv=". $HOME/.screen/var/mrenv.$STY"

function screen-stuff() {
    ## Use \015 instead of \n for older versions of screen.
    screen -X at \# stuff "$*\015" ;
} ;

## function session-checkpoint() {
##     if [[ ! "$SESSION_HOME" ]] ; then
##         echo "${FUNCNAME}: No \$SESSION_HOME defined.  Aborting." >&2 ;
##         return $RV_FAILURE ;
##     fi
## 
##     declare thisWinDir="${WINDOW_HOME:-}" eachWindir='' ;
## 
##     for eachWinDir in $SESSION_HOME/window-[0-9][0-9] ; do
##         [[ $eachWinDir != $thisWinDir ]] && screen -X at ${eachWinDir/#*window-} stuff "eval \$( session --eval )\015" ;
##     done
## 
##     eval $( session --eval ) ; 
## 
##     session --screenrc ;
##     session --status   ;
## 
##     [[ ! -f "$HISTFILE" ]] || [[ "$HISTFILE" -nt "$WAITFILE" ]] ;
## } ;

touchLib ${BASH_SOURCE[0]} ; fi ;

