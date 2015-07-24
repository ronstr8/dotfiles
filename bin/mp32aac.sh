#!/bin/bash
# Azakus 2007
# Requires mplayer, faac, and id3v2
echo "Input name of mp3 file, excluding .mp3"
echo -n ">"
read IN
OUT="`ls | grep $IN.mp3`"
echo "Dumping mp3 to wav"
mplayer -vo null -vc null -ao pcm:fast:file=$IN.wav $OUT
echo "Converting id3v1 tags to id3v2 for easier transition to m4a tags" 
id3v2 -C $OUT
#"Coverting id3 tag from mp3 to m4a tag" --requires id3v2 tags.
TITLE="`id3v2 -l $OUT | grep TIT2 | awk '{ORS=" "} {for (i = 4; i <= NF; i++) print $i}'`"
ARTIST="`id3v2 -l $OUT | grep TPE1 | awk '{ORS=" "} {for (i = 4; i <= NF; i++) print $i}'`"
ALBUM="`id3v2 -l $OUT | grep TALB | awk '{ORS=" "} {for (i = 4; i <= NF; i++) print $i}'`"
TRACK="`id3v2 -l $OUT | grep TRCK | awk '{ORS=" "} {for (i = 6; i <= NF; i++) print $i}'`"
YEAR="`id3v2 -l $OUT | grep TYER | awk '{ORS=" "} {for (i = 3; i <= NF; i++) print $i}'`"
faac -b 128 -c 44100 -w --title "$TITLE" --artist "$ARTIST" --year "$YEAR" --album "$ALBUM" --track "$TRACK" $IN.wav
rm $IN.wav
echo "AAC transcode complete!"
