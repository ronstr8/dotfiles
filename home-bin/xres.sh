#!/bin/bash

case $1 in
	640*)
		res="640x480"
		;;
	1024*)
		res="1024x768"
		;;
	1280*)
		res="1280x1024"
		;;
	*)
		res=$( xrandr | grep -Eom1 "$1[x ]+[0-9]+" | tr -d ' ' )
esac

if [ ! $res ] ; then
	echo "$0: missing screen resolution"
	exit
fi

pid=`ps x | grep WindowMaker | grep -- '--for-real' | awk '{ print $1 }'`
## Assuming Windowmaker...better way?
echo -n "switching to $res and "
# 20041106: fucking new windowmaker just dies with a USR1 -- argh!
echo "restarting WindowMaker task $pid"
xrandr -s $res && kill -USR1 $pid
