#!/bin/bash

ROOTDIR='/av/video/TV/Britcoms'
cd $ROOTDIR


#ROTATABLES='Black*/ Garth*/ *Boosh/ *Ted/'
ROTATABLES=$( find -maxdepth 1 -type d -not -name '*.*' -printf '"%f" \n'  |  zenity --width=256 --height=384 --list  --column='Series to include in rotation' --multiple --separator=' ' )


#PLAYER='xine --loop=shuffle+'
#PLAYER='vlc --random'
#PLAYER='mplayer --shuffle --geometry=0+0 --profile=stereo'
PLAYER="mplayer --shuffle --profile=stereo --geometry='+0+0' --fs"


eval find $ROTATABLES -name '*.avi' -or -name '*.mkv' -not -path '*Extras*' -exec $PLAYER {} +
