
unset -f pathmunge ;
function pathmunge() {
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
}

unset -f filename ;
function filename() {
	local fullname=$1
	basename $fullname | sed 's/\.[^.]\+$//'
}

unset -f extension ;
function extension() {
	local fullname=$1
	basename $fullname | sed 's/^.\+\.\([^.]\+\)$/\1/'
}

