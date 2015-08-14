
if ! pingLib ${BASH_SOURCE[0]} ; then

## @see http://subversion.tigris.org/ds/viewMessage.do?dsForumId=1065&dsMessageId=88333&orderBy=createDate&orderType=desc

## svn() {
##     case "$1" in
##         st|stat|status|up|update)
##             svnargs1=""
##             svnargs2="--ignore-externals"
##             for i in $@; do
##                 if [ "--examine-externals" == "$i" ]; then
##                     svnargs2=""
##                 else
##                     svnargs1="$svnargs1 $i"
##                 fi
##             done
## 			echo "→ svn $svnargs1 $svnargs2 ## From ~/.bash/stdlib" > /dev/stderr
##             command svn $svnargs1 $svnargs2
##             ;;
##         *)
##             command svn "$@"
##             ;;
##     esac
## }
## 

touchLib ${BASH_SOURCE[0]} ; fi ;

## vim: ft=sh


