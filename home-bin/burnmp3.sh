#!/bin/bash

WHEREAMI=`dirname $0`
SCRATCHPATH="/opt/tmp/mix-$$"
TOCFILE="cd.toc"
TRKFILE="$SCRATCHPATH/cd.txt"
MPG123="/usr/bin/mpg123 --rate 44100 --stereo --resync -w "
NORMALIZE="/usr/bin/normalize -m "
CDRDAO="cdrdao write --device 0,0,0 --driver generic-mmc "

echo "DEBUG: creating $SCRATCHPATH"
mkdir $SCRATCHPATH || exit

echo "$1" > $TRKFILE

i=1
for fn in $1/*.mp3; do
	echo $fn >> $TRKFILE
	echo "DEBUG: converting $fn to wavefile"
	$MPG123 $SCRATCHPATH/`printf "%02d" $i`.wav "$fn";
	i=`expr $i + 1`
done

echo "DEBUG: working in $SCRATCHPATH"
cd $SCRATCHPATH

echo "DEBUG: normalizing wavefiles"
normalize -m *.wav

$WHEREAMI/burnwav.sh $SCRATCHPATH

exit

########## see burnwav.sh for rest ##########
echo "DEBUG: creating table-of-contents file $TOCFILE"
echo "CD_DA" > $TOCFILE

for i in *.wav; do
	echo >> $TOCFILE
	echo "TRACK AUDIO" >> $TOCFILE
	echo "AUDIOFILE \"$i\" 0" >> $TOCFILE
done

echo "DEBUG: writing audio to disk"
$CDRDAO $TOCFILE
