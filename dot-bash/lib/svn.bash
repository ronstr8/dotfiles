
__resourceName='svn' ; if ! pingLib "$__resourceName" ; then

## @see http://subversion.tigris.org/ds/viewMessage.do?dsForumId=1065&dsMessageId=88333&orderBy=createDate&orderType=desc

unset -f svn ;
function svn() {
    if true ; then 
        case "$1" in
            st|stat|status)
                command svn "$@" | egrep -v '(\s(logs)/|/build/|((crontab)$))'
                ;;
            *)
                command svn "$@"
                ;;
        esac
    fi
    if false ; then 
        case "$1" in
            st|stat|status|up|update)
                svnargs1=""
                svnargs2="--ignore-externals"
                for i in $@; do
                    if [ "--examine-externals" == "$i" ]; then
                        svnargs2=""
                    else
                        svnargs1="$svnargs1 $i"
                    fi
                done
                echo "→ svn $svnargs1 $svnargs2 ## From ~/.bash/stdlib" > /dev/stderr
                command svn $svnargs1 $svnargs2
                ;;
            *)
                command svn "$@"
                ;;
        esac
    fi
}

touchLib "$__resourceName" ; unset __resourceName ; fi ;


## vim: ft=sh


