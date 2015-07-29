#!/bin/bash
## scan.sh <output-image-filename> -- @args-for-scanimage
##
##		--verbose	Whatever verbose usually means
##		--dry-run   Ditto
##		--help		This message
## -- 
## quinnfazigu@gmail.com

GOX=`getopt -o vhn --long 'verbose,help,dry-run' --name "$0" -- "$@"`
if [ $? != 0 ] ; then echo "Aborting..." >&2 ; exit 1 ; fi

eval set -- "$GOX"

while true ; do
    case "$1" in
        -v|--verbose) 
            verbose=1 ; shift ;;
        -h|--help)
            do_help=1 ; shift ;;
        -n|--dry-run)
            dry_run=1 ; shift ;;
        --)
            shift ; break ;;
    esac
done

if [ $do_help ] ; then awk  '/^## -- $/ { exit } !/^#!/ { gsub("^#+[[:space:]]?", "") ; print }' $0 >&2 ; exit ; fi

OFN=$1 ; shift

if [ ! "$OFN" ] ; then
	echo "missing required parameter of output filename" > /dev/stderr
	exit 1
fi

EXE='scanimage'

#RES='75'
RES='300'
GEO='-x 215 -y 297'

FMT_GUESS=$( echo $OFN | grep -Eo '\w+$' )

case "$FMT_GUESS" in
	PNM|pnm)
		FMT=pnm     ;;
	TIFF|tiff)
		FMT=tiff    ;;
	*)
		FMT=unknown ;;
esac

if [ "$FMT" != "unknown" ] ; then
	FMT="tiff"
elif [ "$FMT_GUESS" ] ; then
	echo "Unsupported format '$FMT_GUESS'; use PNM or TIFF." > /dev/stderr
	exit 1
else
	echo "No format guessed; defaulting to TIFF." > /dev/stderr
	FMT="tiff"
	OFN="$OFN.$FMT"
fi

[ "$verbose" ] && echo -n "Scanning for devices ... " > /dev/stderr
#DEV=$( sane-find-scanner | grep -E '^found' | awk '{ print $NF }' )
#DEV=$( scanimage -L | grep -Eo '\w+:\w+:[0-9]+:[0-9]+' )
DEV=$( $EXE -f '%d' )
[ "$verbose" ] && echo "$DEV" > /dev/stderr


if [ "$verbose" ] ; then
	cat > /dev/stderr << EOT
	$EXE --device="$DEV" $GEO --resolution="$RES" --format="$FMT" $* > $OFN
EOT
fi

if [ ! "$dry_run" ] ; then
	$EXE --device="$DEV" $GEO --resolution="$RES" --format="$FMT" $* > $OFN
fi

## $ sane-find-scanner
## found USB scanner (vendor=0x04a9, product=0x2206, chip=LM983x?) at libusb:003:003

