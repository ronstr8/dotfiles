
if ! pingLib ${BASH_SOURCE[0]} ; then

## urldecode
#       Convert %XX hex codes into the ASCII characters they represent.
##
unset -f urldecode ; function urldecode() {
    declare expr='s/%([0-9A-F]{2})/chr(hex($1))/gie;' ;

    if (( $# )) ; then ## Encoded string on cmdline.
        echo "$@" | perl -p -e "$expr" ;
    else
        perl -p -e "$expr" ;
    fi
} ;

## tablify
#       Print tabular data with horizontal justification.
##
unset -f tablify ; function tablify() {
    perl -a -n -e 'push(@rows, [@F]); for (0..$#F) { $ll = length($F[$_]); $cm[$_] = $ll if $ll > ($cm[$_] || 0); } ; END { printf(join(q{ }, map { "%${_}s" } @cm) . "\n", @{$_}) for @rows; }' ;
} ;

## genpwd
#		Create a random password of safe printable characters.
unset -f genpwd ; function genpwd() {
	declare pwlen=${1:-16} ;
	LC_ALL=C tr -cd '[:graph:]' < /dev/urandom | tr -d "\"'\$\`"'\\' | head -c $pwlen ;
} ;

touchLib ${BASH_SOURCE[0]} ; fi ;


