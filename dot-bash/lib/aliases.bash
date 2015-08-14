
##     printf '========================================\n' >&2 ;
##     printf 'aliases: @:%s\n' "$@" >&2 ;
##     printf 'aliases: 0:%s\n' "$0" >&2 ;
##     printf 'aliases: 1:%s\n' "$1" >&2 ;
##     printf 'aliases: BASH_SUBSHELL:%s\n' "$BASH_SUBSHELL" >&2 ;
##     printf 'aliases: SHLVL:%s\n' "$SHLVL" >&2 ;
##     printf 'aliases: FUNCNAME:%s\n' "${FUNCNAME[@]}" >&2 ;
##     printf 'aliases: BASH_SOURCE:%s\n' "${BASH_SOURCE[@]}" >&2 ;
##     printf 'aliases: BASH_LINENO:%s\n' "${BASH_LINENO[@]}" >&2 ;
##     printf 'aliases: PIPESTATUS:%s\n' "${PIPESTATUS[@]}" >&2 ;

__resourceName='aliases' ; if ! pingLib "$__resourceName" ; then

unset -f ssh-ensure-keychain ;
function ssh-ensure-keychain() {
    if ssh-add -l &> /dev/null ; then
        return 0 ;
    fi

    eval `keychain --eval --quick` ;
    ssh-add -l ;
}

unset -f utf8-locale-force ;
function utf8-locale-force() {
    local desiredLocale='en_US.UTF-8' ;

    if ( locale | fgrep -qv "$desiredLocale" | grep -qv '^LC_ALL=$' )  ; then
        ## All locale values (except perhaps an unset LC_ALL) are as desired.
        return 0 ;
    fi 

    export LC_ALL="$desiredLocale" ; 
    locale | fgrep -v "$desiredLocale" ;
}

touchLib "$__resourceName" ; unset __resourceName ; fi ;

