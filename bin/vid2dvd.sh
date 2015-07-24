#!/bin/bash

INFILE=$1
BBFILE=$2

if [ ! "$INFILE" ] ; then
	echo "missing required argument of input video file" > /dev/stderr
	exit 1
fi

if [ ! "$BBFILE" ] ; then
	echo "missing required argument of output video file" > /dev/stderr
	exit 1
fi

## Defaults
ASPECT=16/9

## PAL
SCALE=720:576
KEYINT=15
FPS=25

## NTSC
SCALE=720:480
KEYINT=18
FPS="30000/1001"

## Tweaks
#ASPECT=4/3     ## Prevent stretching?
#SCALE=720:576  ## Keep PAL aspect?

## http://www.linux.com/articles/53702
## I ignored the bit where the guy says the following is for PAL.  ARGH!
## mencoder -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd -vf scale=720:576,harddup -srate 48000 -af lavcresample=48000 -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=15:aspect=16/9:acodec=ac3:abitrate=192 -ofps 25 -o your_video.mpg your_video.avi

##mencoder -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd -vf scale=720:576,harddup -srate 48000 -af lavcresample=48000 -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=15:aspect=16/9:acodec=ac3:abitrate=192 -ofps $FPS -o "$BBFILE" "$INFILE"

##mencoder -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd -vf scale=$SCALE,harddup -srate 48000 -af lavcresample=48000 -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=$KEYINT:aspect=$ASPECT:acodec=ac3:abitrate=192 -ofps $FPS -o "$BBFILE" "$INFILE"

## Added noskip and the tele_{src,dest} opts below.
mencoder -oac lavc -ovc lavc -of mpeg -noskip -mpegopts format=dvd:tele_src=25:tele_dest=30000/1001 -vf scale=$SCALE,harddup -srate 48000 -af lavcresample=48000 -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=5000:keyint=$KEYINT:aspect=$ASPECT:acodec=ac3:abitrate=192 -ofps $FPS -o "$BBFILE" "$INFILE"

## 2009-03-22 17:47:11 :: /staging/rip/dvdauthor/The_Mighty_Boosh/The_Mighty_Boosh_S01_E05-08
##  rons@ga-e7aum-ds2h$ for fn in /data/video/Britcoms/The\ Mighty\ Boosh/s1e0[5678]*.mkv ; do bn=$( basename "$fn" ) ; vid2dvd.sh "$fn" "${bn//.[a-z]*/.mpg}" ; done

## 2009-03-21 19:03:06 :: /staging/rip/dvdauthor/The_Mighty_Boosh/The_Mighty_Boosh_S1
##  rons@ga-e7aum-ds2h$ cat > dvd.xml << EOT
## <dvdauthor>
##         <vmgm />
##                 <titleset>
##                         <titles>
##                                 <pgc>
##                                         <vob file="s1e01 - Killeroo.mpg" />
##                                         <vob file="s1e02 - Mutants.mpg" />
##                                         <vob file="s1e03 - Bollo.mpg" />
##                                         <vob file="s1e04 - Tundra.mpg" />
##                                 </pgc>
##                         </titles>
##                 </titleset>
## </dvdauthor>
## EOT

## 2009-03-21 19:04:06 :: /staging/rip/dvdauthor/The_Mighty_Boosh/The_Mighty_Boosh_S1
##  rons@ga-e7aum-ds2h$ dvdauthor -o dvd -x dvd.xml 

## 2009-03-21 19:06:40 :: /staging/rip/dvdauthor/The_Mighty_Boosh/The_Mighty_Boosh_S1
##  rons@ga-e7aum-ds2h$ mplayer dvd:// -dvd-device ./dvd

## 2009-03-21 19:07:27 :: /staging/rip/dvdauthor/The_Mighty_Boosh/The_Mighty_Boosh_S1
##  rons@ga-e7aum-ds2h$ growisofs -dvd-compat -Z /dev/dvd -dvd-video ./dvd

## growisofs didn't create a file our pals could read on their PS3 or standard
## DVD player, so trying genisoimage burnt with gnomebaker instead:

## 2009-03-22 11:31:31 :: /staging/rip/dvdauthor/The_Mighty_Boosh/The_Mighty_Boosh_S1
##  rons@ga-e7aum-ds2h$ genisoimage -dvd-video -o dvd.iso ./dvd/ 

## Gnomebaker just seems to do this, though:
## Executing 'builtin_dd if=/staging/rip/dvdauthor/The_Mighty_Boosh/The_Mighty_Boosh_S01_E05-08/dvd.iso of=/dev/hda obs=32k seek=0'

