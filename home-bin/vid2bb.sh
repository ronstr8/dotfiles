#!/bin/bash

## From http://www.blackberryforums.com/linux-users-corner/65660-vid2bb-sh-using-mencoder-create-videos.html

INFILE=$1
BBFILE=$2

if [ ! "$INFILE" ] ; then
	echo "missing required argument of input video file" > /dev/stderr
	exit 1
fi

if [ ! "$BBFILE" ] ; then
	bbsuff='_bb'
	sedexp=$( echo 's/\.\([^.]\+\)\+$/'$bbsuff'.\1/'  )
	BBFILE=$( echo $INFILE | sed -e "$sedexp" )
#	echo "missing required argument of output video file" > /dev/stderr
#	exit 1
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
        -o "$BBFILE" \
        -of avi \
        -ovc lavc \
        -oac mp3lame \
        -lavcopts vcodec=mpeg4:vbitrate=$VBR \
        -lameopts abr:br=$ABR \
		-vf scale=$RES

