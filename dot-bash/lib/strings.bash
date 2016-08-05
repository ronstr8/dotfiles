
if ! pingLib ${BASH_SOURCE[0]} ; then

## urldecode
#       Convert %XX hex codes into the ASCII characters they represent.
##
unset -f urldecode ; function urldecode() {
    perl -p -e 's/%([0-9A-F]{2})/chr(hex($1))/gie;' ;
} ;

## tablify
#       Print tabular data with horizontal justification.
##
unset -f tablify ; function tablify() {
    perl -a -n -e 'push(@rows, [@F]); for (0..$#F) { $ll = length($F[$_]); $cm[$_] = $ll if $ll > ($cm[$_] || 0); } ; END { printf(join(q{ }, map { "%${_}s" } @cm) . "\n", @{$_}) for @rows; }' ;
} ;


touchLib ${BASH_SOURCE[0]} ; fi ;


