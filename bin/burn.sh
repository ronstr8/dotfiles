#!/bin/bash

MKISOFS_ARGS="-full-iso9660-filenames -translation-table -joliet -rock"
#MKISOFS_ARGS="-full-iso9660-filenames -translation-table"
#CDRECORD_SPEED=24
#CDRECORD_SPEED=16
#CDRECORD_SPEED=4

# blank used to blank cdrw, might try blank=all, as well
#CDRECORD_ARGS="blank=fast -dev 0,0,0 -speed=$CDRECORD_SPEED"
#CDRECORD_ARGS=" -dev 0,0,0 "
#CDRECORD_ARGS=" -dev /dev/cdrom -tao -speed=$CDRECORD_SPEED"
CDRECORD_ARGS=" -dev /dev/cdrom -tao driveropts=burnfree -eject "
#CDRECORD_ARGS=" -dev /dev/cdrom "

if [ "$1" = "blank" ]; then
	echo "DEBUG: blank cdrw disc"
	cdrecord $CDRECORD_ARGS blank=fast
	exit
fi

if [ -d "$1" ]; then
	echo "DEBUG: $1 is a directory"
#	MKISOFS_ARGS="$MKISOFS_ARGS -follow-outside-links $1"
	MKISOFS_ARGS="$MKISOFS_ARGS -D"
	CDRECORD_ARGS="$CDRECORD_ARGS -"
elif [ "`echo "$1" | grep -F .iso`" ] ; then
	echo "DEBUG: $1 is an ISO image"
	MKISOFS_ARGS=""
elif [ "`file "$1" | grep ISO`" ] ; then
	echo "DEBUG: $1 is an ISO image"
	MKISOFS_ARGS=""
else
	echo "DEBUG: $1 is a file"
	CDRECORD_ARGS="$CDRECORD_ARGS -"
fi

# testing
[ "$MKISOFS_ARGS" ] && echo "DEBUG: mkisofs $MKISOFS_ARGS"
echo "DEBUG: cdrecord $CDRECORD_ARGS"

if test "$MKISOFS_ARGS" ; then
	echo "DEBUG: making ISO filesystem piped to burner"
	mkisofs $MKISOFS_ARGS "$1" | cdrecord $CDRECORD_ARGS
else
	echo "DEBUG: sending ISO image directly to burner"
	cdrecord $CDRECORD_ARGS "$1"
fi

echo $1
