#!/bin/bash

## http://ubuntuforums.org/archive/index.php/t-311588.html

INFILE=$1
OUTFILE=$2

if [ ! "$INFILE" ] ; then
	echo "missing required argument of input video file" > /dev/stderr
	exit 1
fi

if [ ! "$OUTFILE" ] ; then
	bbsuff='-WII'
	sedexp=$( echo 's/\.\([^.]\+\)\+$/'$bbsuff'.\1/'  )
	OUTFILE=$( echo $INFILE | sed -e "$sedexp" )
fi

## Original settings
RES=240:180             # 81** is 240x260, 240x180 is its std video size
ABR=64                  # audio bitrate
VBR=230                 # video bitrate
ACODEC=aac

## My overrides
##RES=320:240
##RES=176:144			   # http://www.mobiletechreview.com/phones/BlackBerry-Pearl-8120.htm
ABR=16                 # audio bitrate (32 works well, trying 16)
VBR=128                # video bitrate (128 is good, 64 gets blocky)

mencoder "$INFILE" \
	-fps 29.97\
	-ovc lavc\
	-lavcopts\
	vcodec=mjpeg\
	-oac pcm\
	-vf scale\
	-zoom -xy 512\
	-o "$OUTFILE"

# rons@ga-e7aum-ds2h$ mencoder Curb\ Your\ Enthusiasm\ -\ 1x05\ -\ Interior\ Decorator.avi -fps 29.97 -ovc lavc -lavcopts vcodec=mjpeg -oac pcm -vf scale -zoom -xy 512 -o Curb\ Your\ Enthusiasm\ -\ 1x05\ -\ Interior\ Decorator-WII.avi 

