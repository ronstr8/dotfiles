
if ! pingLib ${BASH_SOURCE[0]} ; then

x11-try-display() {
#	export DISPLAY="${HOSTNAME}:${display_number}.${screen_number}"
	local display_prospect="$1"

## display_prospect="localhost:11.0" ; xmessage -display "$display_prospect" -font 9x15bold -geometry +320+240 -background wheat -foreground black -bordercolor brown -title 'Can you see me?' -timeout 10 -buttons 'Confirm:100' "If you can see this message, click the button below to set your DISPLAY variable to '$display_prospect'." 2> /dev/null && echo "exitOK=$?" || echo "exitFail=$?"

	trap -- 'return 2' SIGINT

	xmessage -display "$display_prospect" -font '9x15bold' -geometry '+320+240' -background 'wheat' -foreground 'black' -bordercolor 'brown' -title 'Can you see me?' -timeout 5 -buttons 'Confirm:100' "Click the button below to set your DISPLAY variable to '$display_prospect'." 2> /dev/null
	xmessage_rv="$?"

	if [ "$xmessage_rv" = "100" ] ; then
		echo "→ Display confirmed. Exporting DISPLAY='$display_prospect'." > /dev/stderr
		export DISPLAY="$display_prospect"

		return 0
	fi

	if [ "$xmessage_rv" = "0" ] ; then
		echo "→ Timeout waiting for confirmation of possible display '$display_prospect'." > /dev/stderr
	else
		echo "→ No display found at '$DISPLAY'." > /dev/stderr
	fi

	return 1
}

x11-get-display() {
	## If a DISPLAY variable is set, try it first.
	if [ "$DISPLAY" ] ; then
#		echo -e "→ DISPLAY='$DISPLAY'" > /dev/stderr
		x11-try-display "$DISPLAY" && return $?
	fi

	## Dissection of the DISPLAY variable:
	## @see http://www.xfree86.org/current/X.7.html#sect4
	local display_hostname="localhost"
	local display_number=10
	local display_screen=0

#	local x11_connections=$( netstat -an | /bin/grep 0\ [0-9,:,.]*:60..\  | awk '{ print $4 }' | tail -n 1 )
	local x11_connections=$( netstat -an | awk '/0 [0-9,:.]*:60..[^0-9]/ { print substr($4,length($4)-1) }' | sort -nr | uniq | xargs )
#	echo -e "→ x11_connections: $x11_connections" > /dev/stderr

	for port in $x11_connections ; do
		display_number=${port: -2}
		display_prospect="${display_hostname}:${display_number}.${display_screen}"

#		echo -e "→ port=$port; display_number='$display_number'; display_prospect='$display_prospect'" > /dev/stderr
		x11-try-display "$display_prospect" && return $?
	done

	echo -e "→ Failed to find the display you are viewing." > /dev/stderr
	return 1
}

touchLib ${BASH_SOURCE[0]} ; fi ;


## vim: ft=sh

