
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



