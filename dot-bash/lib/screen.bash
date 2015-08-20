
if ! pingLib ${BASH_SOURCE[0]} ; then

# alias screen-mrenv=". $HOME/.screen/var/mrenv.$STY"

function screen-stuff() {
    screen -X at \# stuff "$*\n" ;
} ;

function session-checkpoint() {
    declare    sleepSeconds='0.25' ;
    declare -i remainingWaits=20 ;
    declare    WAITFILE='' ;

    if [[ -f "$HISTFILE" ]] ; then
        WAITFILE="/tmp/screen-stuff-waitfile-$$-$RANDOM.txt" ; 
        touch --reference="$HISTFILE" "$WAITFILE" ;
        trap "rm -f '$WAITFILE'" RETURN EXIT ;
    fi


    while [[ ! "$HISTFILE" -nt "$WAITFILE" ]] && (( remainingWaits-- > 0 )) ; do
        sleep $sleepSeconds ;
    done

    screen-stuff "(( WINDOW != $WINDOW )) && eval \$( session --eval )\n" ;

    eval $( session --eval ) ; 
    session --screenrc ;
    session --status   ;

    [[ ! "$HISTFILE" -nt "$WAITFILE" ]] ;
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

