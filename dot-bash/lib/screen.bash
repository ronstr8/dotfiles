
if ! pingLib ${BASH_SOURCE[0]} ; then

needsLib 'status' ;

# alias screen-mrenv=". $HOME/.screen/var/mrenv.$STY"

function screen-stuff() {
    ## Use \015 instead of \n for older versions of screen.
    screen -X at \# stuff "$*\015" ;
} ;

function session-checkpoint() {
    if [[ ! "$SESSION_HOME" ]] ; then
        echo "${FUNCNAME}: No \$SESSION_HOME defined.  Aborting." >&2 ;
        return $RV_FAILURE ;
    fi

    declare thisWinDir="${WINDOW_HOME:-}" eachWindir='' ;

    for eachWinDir in $SESSION_HOME/window-[0-9][0-9] ; do
        [[ $eachWinDir != $thisWinDir ]] && screen -X at ${eachWinDir/#*window-} stuff "eval \$( session --eval )\015" ;
    done

    eval $( session --eval ) ; 

    session --screenrc ;
    session --status   ;

    [[ ! -f "$HISTFILE" ]] || [[ "$HISTFILE" -nt "$WAITFILE" ]] ;
} ;

#alias ssh-agent-reuse='eval `ssh-agent-attach`'
#alias screendoor='source ~/.x-terminal-emulator/screendoor.sh'

## function screen-mrenv {
## 	if [ ! "$STY" ] ; then
## 		echo "Shell does not appear to be within a screen; aborting ..." > /dev/stderr
## 		return
## 	fi
## 
## 	if [ ! "$SCREEN_MRENV" ] ; then
## 		echo "Defaulting \$SCREEN_MRENV to «$SCREEN_MRENV» ..." > /dev/stderr
## 		SCREEN_MRENV="$HOME/.screen/var/mrenv.$STY"
## 	fi
## 
## 	if [ ! -r "$SCREEN_MRENV" ] ; then
## 		echo "No readable file for \$SCREEN_MRENV «$SCREEN_MRENV»; aborting ..." > /dev/stderr
## 		return
## 	fi
## 
## 	export SCREEN_MRENV
## 
## 	## @TODO screen -X at \# "stuff source $SCREEN_MRENV"  FUCKING SCREEN -X AT STUFF FUCKER
## 	echo "Slurping most-recently-invoked screen ENV from «$SCREEN_MRENV» ..." > /dev/stderr
## 	. "$SCREEN_MRENV"
## }

touchLib ${BASH_SOURCE[0]} ; fi ;

