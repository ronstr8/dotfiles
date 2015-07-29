
unset -f pathmunge ;
function pathmunge() {
        ## pathmunge $shell_var_name $path_to_add[ after]

        local varname=$1

        local addorsub="+"
        local whatdir=$2

        case "$whatdir" in
                +*)
                        addorsub="+"
                        whatdir="${whatdir:1}"
                        ;;
                -*)
                        addorsub="-"
                        whatdir="${whatdir:1}"
                        ;;
                --)
                        shift ; break ;;
        esac

        local whereat=$3

        local newpath=""
        local oldpath="${!varname}"
        local tmppath="$( echo "$oldpath" | sed 's#\(^\|:\)'$whatdir'\($\|:\)#\1\2#g' )"


        if [ "$addorsub" = "-" ] ; then
                newpath="$tmppath"
        elif [ "$whereat" = "after" ] ; then
                newpath="${tmppath}:${whatdir}"
        else
                newpath="${whatdir}:${tmppath}"
        fi

        newpath="$( echo "$newpath" | tr -s : | sed 's/^://' | sed 's/:$//' )"

        [ "$oldpath" != "$newpath" ] && eval "$varname='$newpath'"
}

unset -f filename ;
filename() {
	local fullname=$1
	basename $fullname | sed 's/\.[^.]\+$//'
}

unset -f extension ;
extension() {
	local fullname=$1
	basename $fullname | sed 's/^.\+\.\([^.]\+\)$/\1/'
}


