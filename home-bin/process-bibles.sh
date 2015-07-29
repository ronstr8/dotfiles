#!/bin/bash

index="59";
indices=""
bibles="";
today=`date +%Y%m%d`;

for fn in [A-Z]*; do
    if [ $(echo $fn | grep TB) ]; then
    	continue;
    fi

    dn="TB`printf "%0.3d" $index`";

    mv "$fn" $dn ;
    cd $dn ;
    echo "$fn" > TITLE.txt ;

    if [ -f front.tif ];  then page=front.tif;
    else  page=p1.tif ; fi ;

    convert -quality 60 -sample 133x100 $page tn_teaser.jpg;
    convert -quality 60 -sample 320x240 front.tif tn_front.jpg ;
    convert -quality 60 -sample 320x240 back.tif tn_back.jpg ;

    for fn in front.tif back.tif p*.tif ;
	do false;
	convert -quality 75 -sample x400 $fn `basename $fn .tif`.jpg;
	convert -quality 60 -sample x200 $fn `basename tn_$fn .tif`.jpg;
    done ;

    cd .. ;

    indices="$indices $index";
    index="`expr $index + 1`" ;
done


for i in $indices ; do
    dn=`printf "TB%.3d" $i` ;

    echo "SKUID: $dn" ;
    echo "NAME: `cat $dn/TITLE.txt`";
    echo "DESC:" ;

    echo "ADDED: $today" ;

    printf "PREV: TB%.3d\n" `expr $i - 1`;
    printf "NEXT: TB%.3d\n" `expr $i + 1`;


    pages=`cd $dn && ls -x p[0-9].jpg | perl -pe 'chop; s/\s+/;/g;'` ;
    echo "PAGES: $pages";

    if test -e front.jpg ; then echo "FRONT: front.jpg" ; fi
    if test -e back.jpg  ; then echo "BACK: back.jpg" ; fi

    echo "AUTHOR:" ;
    echo "NOTES:" ;
    echo "KEYWORDS:" ;
    echo "SOURCE:" ;

    echo ;
done
