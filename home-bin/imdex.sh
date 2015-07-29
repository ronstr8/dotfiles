#!/bin/bash

LARGEBASE=""
THUMBBASE=""
INDEXFILE="output.html"
THUMBWIDTH=
THUMBHEIGHT=250
THUMBDIMS="${THUMBWIDTH}x${THUMBHEIGHT}"
OUTFORMAT="jpg"
TITLE="Photos"
INTRO=""

cat >> $INDEXFILE <<EOT
<html>
<head>
<title>$TITLE</title>
</head>
<body>
<h1>$TITLE</h1>
<p>$INTRO</p>
EOT

function embellish
{
    FN=$1
    TN="$(echo $FN | sed s/\.[a-zA-Z]*$//g)_${THUMBDIMS}.${OUTFORMAT}"

    if [ ! -e $TN ]; then
	echo "convert -scale $THUMBDIMS $FN $TN"
	convert -scale $THUMBDIMS $FN $TN
    fi

#    printf "Enter a short title for the image.\n----------\n"
#    read TITLE
TITLE=$FN

#    printf "Enter a one-line description of the image.\n----------\n"
#    read DESC
DESC=$FN

    TITLE="$(echo $TITLE | sed s/\"/\'/g)"

    cat >> $INDEXFILE <<EOF
<br clear="all" />
    <a  href="${LARGEBASE}/${FN}">
    <img src="${THUMBBASE}/${TN}" 
         alt="$TITLE" title="$TITLE" />
    </a>
    <p>$DESC</p>

EOF
}


for FN in $*; do
    case $FN in
    *${THUMBDIMS}.${OUTFORMAT})
	continue
	;;
    esac

#    xv $FN &

#    echo -n "Index $FN? (Y/n) "
#    read
REPLY=yes

    if [ "$REPLY" ]; then
	case $REPLY in 
	[Yy]*)
	    embellish $FN
	;;
	esac
    else
	embellish $FN
    fi
done

cat >> $INDEXFILE <<EOT
</body>
</html>
EOT

