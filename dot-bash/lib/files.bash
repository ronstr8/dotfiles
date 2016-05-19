
if ! pingLib ${BASH_SOURCE[0]} ; then

unset -f pathmunge ; function pathmunge() {
        ## . ~/.bash/lib/files.bash ; echo $PATH ; pathmunge PATH +$HOME/work/bin after ; echo $PATH
        local varName="$1" ;
        local actionFlag="${2:0:1}" ;
        local whatDir="${2#[+-]}" ;
        local action=$( [ "$actionFlag" = '-' ] && echo 'remove' || echo "${3:-before}" ) ;

        local originalPath="${!varName}" ;
        local pathWithoutWhatDir="$( echo "$originalPath" | sed 's#\(^\|:\)'$whatDir'\($\|:\)#\1\2#g' )" ;
        local changedPath='' ;

        if   [ "$action" = 'before' ] ; then
            changedPath="${whatDir}:${pathWithoutWhatDir}" ;
        elif [ "$action" = 'after'  ] ; then
            changedPath="${pathWithoutWhatDir}:${whatDir}:" ;
        elif [ "$action" = 'remove' ] ; then
            changedPath="${pathWithoutWhatDir}" ;
        fi

        [ "$changedPath" ] && changedPath=$( echo "$changedPath" | sed 's/^://; s/:$//; s/:\+/:/g;' ) ;
        [ "$changedPath" ] && eval "$varName='$changedPath'" ; 
} ;

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

## df
##      df, but always properly columnized.
#
##
unset -f df ; function df() {
    command df -P $@ | perl -a -n -e 'push(@rows, [@F]); for (0..$#F) { $ll = length($F[$_]); $cm[$_] = $ll if $ll > ($cm[$_] // 0); } ; END { printf("%-$cm[0]s %$cm[1]s %$cm[2]s %$cm[3]s %$cm[4]s %s\n", @{$_}) for @rows; }' ;
} ;

## df
##      df, but always properly columnized.
#
##
unset -f df ; function df() {
        command df -P $@ | perl -a -n -e 'push(@rows, [@F]); for (0..$#F) { $ll = length($F[$_]); $cm[$_] = $ll if $ll > ($cm[$_] // 0); } ; END { printf("%-$cm[0]s %$cm[1]s %$cm[2]s %$cm[3]s %$cm[4]s %s\n", @{$_}) for @rows; }' ;
} ;


touchLib ${BASH_SOURCE[0]} ; fi ;

