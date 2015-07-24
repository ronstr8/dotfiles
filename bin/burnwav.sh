#!/bin/bash

TOCFILE="cd.toc"
CDRDAO="cdrdao write --device 0,0,0 --driver generic-mmc "

SCRATCHPATH=$1
echo "DEBUG: working in $SCRATCHPATH"
cd $SCRATCHPATH

echo "DEBUG: creating table-of-contents file $TOCFILE"
echo "CD_DA" > $TOCFILE

for i in *.wav; do
	echo >> $TOCFILE
	echo "TRACK AUDIO" >> $TOCFILE
	echo "AUDIOFILE \"$i\" 0" >> $TOCFILE
done

echo "DEBUG: writing audio to disk"
$CDRDAO $TOCFILE
