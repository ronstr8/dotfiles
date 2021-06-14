
if ! pingLib ${BASH_SOURCE[0]} ; then

## necho <host> <port> ...
#
#   Echo text to a TCP host/port.  `echo -ne' is used to emit the text.
#
# @see http://www.linuxjournal.com/content/more-using-bashs-built-devtcp-file-tcpip
# @see http://www.tldp.org/LDP/abs/html/devref1.html
##
unset -f necho ; function necho() {
    declare    host=${1?Missing host argument.} ; shift ;
    declare -i port=${1?Missing port argument.} ; shift ;

    declare    sock=$( printf '/dev/tcp/%s/%d' "$host" $port ) ;

    if exec 13<>$sock ; then
        echo -ne "$@" >&13 ;
        cat <&13 ;
    else
        echo "Failed to create socket $sock!" >&2 ;
    fi

    exec 13>&- ;
} ;

unset -f jsonhttp_pp ; function jsonhttp_pp() {
	tee >( awk '/^(HTTP|[A-Za-z-]+:)/ { print }' > /dev/stderr ) | grep -v '^\(HTTP\|[A-Za-z-]\+:\|$\)' | json_pp ;
} ;

touchLib ${BASH_SOURCE[0]} ; fi ;

## vim: ft=sh



