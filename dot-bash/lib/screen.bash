
if ! pingLib ${BASH_SOURCE[0]} ; then


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

