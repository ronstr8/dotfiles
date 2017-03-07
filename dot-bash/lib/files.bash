
if ! pingLib ${BASH_SOURCE[0]} ; then

unset -f filename ; function filename() {
	declare fullname=$1 ;
	basename $fullname | sed 's/\.[^.]\+$//'
} ;

unset -f extension ; function extension() {
	declare fullname=$1 ;
	basename $fullname | sed 's/^.\+\.\([^.]\+\)$/\1/'
} ;

## dush [$root|$dir+]
##      du -sh, but prettier.
#
# @param $root parent dir of all directories to measure.
# @param $dir one or more directories to measure.
# @stdout tabularized/aligned byte-unit output of total dir sizes in root.
##
unset -f dush ; function dush() {
    declare awkOutScript='{ ll=length($1); printf("%7.2f%c %s\n", substr($1, 0, ll-1), substr($1, ll), $NF); }' ;

    [[ $# -gt 1 || $1 == "\*"  ]] && du -s "${@:-*}" || du -s ./* |
        sort -nr | awk '{ print $2 }' | xargs du -sh | awk "$awkOutScript" ;

#   du -s * | sort -nr | awk '{ print $2 }' | xargs du -sh | awk '{ printf("%7.2f%c %s\n", substr($1, 0, length($1)-1), substr($1, length($1)), $NF); }'
} ;

touchLib ${BASH_SOURCE[0]} ; fi ;

