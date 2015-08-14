
if ! pingLib ${BASH_SOURCE[0]} ; then

## Fucking CentOS 5 doesn't _have_ Bash4 with associative arrays. GRR.
# declare -A ALL_OPTIONS ; ALL_OPTIONS=(
#     [debug]='debug'
#     [trace]='trace'
#     [terse]='terse'
#     [evalMode]='eval'
#     [screenrc]='screenrc'
#     [commit]='commit'
#     [vivify]='vivify'
#     [session]='session:'
#     [title]='title:'
#     [renumberTo:]='renumber-to:'
#     [restoreWindow:]='restore-window:'
#     [checkpoint]='checkpoint'
# ) ;
# 
# declare -A RTPARAMS ;

export APPARAM_DEFAULT_OPTION_PREFIX='__APPARAM_OPTION_' ;
export APPARAM_DEFAULT_CONFIG_PREFIX='__APPARAM_CONFIG' ;
export APPARAM_DEFAULT_FLAG_VALUE=1 ;

export APPARAM_METAKEY_OPTIONS='options' ;
export APPARAM_METAKEY_HELP='helpText' ;

# /* Echoes a shell-safe version of an application parameter name.
#  *
#  * Current rules:
#  *
#  * 1. Remove leading dashes.  For the case of getopt names.
#  * 2. Replace remaining dashes with underscores.
#  * 3. Delete all remaining characters that are not alphanumeric or underscores.
#  *
#  * @param rawKey the raw key
#  *
#  * @output the scrubbed key
#  *
#  * __apparam_scrubKey rawkey
#  */
unset -f __apparam_scrubKey ;
function __apparam_scrubKey() {
    local rawKey="$1" ;

    echo "$rawKey" | sed -e 's/^-\+//; s/-/_/g; s/[^[:alnum:]_]//g;' ;
}

unset -f __apparam_setEnv ;
function __apparam_setEnv() {
    # @TODO Replace single-quotes with some escape, then put it back in __apparam_get.
    local key=$( __apparam_scrubKey "$1" ) ;
    local val=$( echo "$2" | sed "s/'/\\'/g;" ) ;

    echo eval "$key=$'$val'" ;
}

# /* Echoes the environment variable representing the given application parameter.
#  *
#  * @param appId a unique identifier for the application
#  * @param key the name of that application-specific parameter
#  *
#  * @output the previous value of the parameter (or empty string if none)
#  *
#  * __apparam_keyFor appId key
#  */
unset -f __apparam_keyFor ;
function __apparam_keyFor() {
    local keyType=$( echo "$1" | tr 'a-z' 'A-Z' ) ;
    local appId="${2:?Missing argument 1 specifying appId}" ;
    local forKey="$3" ;
}

unset -f __apparam_metaKeyFor ;
function __apparam_metaKeyFor() {
    local prefix="${APPMETA_PREFIX:-$APPARAM_DEFAULT_CONFIG_PREFIX}" ;
    local appId="${1:?Missing argument 1 specifying appId}" ;
    local metaKey="${2:?Missing argument 2 specifying metaKey}" ;

    echo "${prefix}$( __apparam_scrubKey "$appId" )_$( __apparam_scrubKey "$key" )" ;
}

unset -f __apparam_getMeta ;
function __apparam_getMeta() {
    local key=$( __apparam_metaKeyFor "$1" "$2" ) ;
    echo "${!key}" ;
}

unset -f __apparam_setMeta ;
function __apparam_setMeta() {
    local key=$( __apparam_metaKeyFor "$1" "$2" ) ;
    __apparam_setEnv "$key" "$3" ;
}


# /* Gets or sets the getopt(1) options string for an application.
#  *
#  * @param appId a unique identifier for the application
#  * @param longOpts a string of long-options suitable for feeding to getopt(1)
#  *
#  * @output the option string
#  *
#  * @croaks if appId is not provided
#  *
#  * __apparam_options appId [longOpts
#  */
unset -f __apparam_options ;
function __apparam_options() {
    local appId="${1:?Missing argument 1 specifying appId}" ;
    local longOpts="$2" ;

    local optionsKey=$( __apparam_metaKeyFor "$appId" "$APPARAM_METAKEY_OPTIONS" ) ;

    if [ "$longOpts" ] ; then
        __apparam_setEnv "$optionsKey" "$longOpts" ;
    fi

    echo "${!optionsKey}" ;
}


# /* Initializes the recognized parameters for an application.
#  *
#  * @param appId a unique identifier for the application
#  * @param option a series of long option descriptions for getopt(1)
#  *
#  * @croaks if appId is not provided
#  *
#  * __apparam_init appId [option ...]
#  */
unset -f __apparam_init ;
function __apparam_init() {
    local appId="${1:?Missing argument 1 specifying appId}" ; shift ;

    local allOptions="$@" ; ## Roly keeps our arguments quoted properly!

    $allOptions[${#allOptions[*]}]='help' ;    # -o h
    $allOptions[${#allOptions[*]}]='verbose' ; # -o v
#   $allOptions[${#allOptions[*]}]='dry-run' ; # -o n
#   $allOptions[${#allOptions[*]}]='debug' ;

    local longOpts="$( echo "${allOptions[@]}" | sed -e 's/[[:space:]]+/,/gm' )" ;
    __apparam_options "$appId" "$longOpts" ;
}

# /* Gets a named value from an application parameter map.
#  *
#  * @param appId a unique identifier for the application
#  * @param key the name of that application-specific parameter
#  *
#  * @output the previous value of the parameter (or empty string if none)
#  *
#  * __apparam_get appId key
#  */
unset -f __apparam_get ;
function __apparam_get() {
    local key=$( __apparam_keyFor "$1" "$2" ) ;

    echo "${!key}" ;
}

# /* Puts a named value into an application parameter map.
#  *
#  * @param appId a unique identifier for the application
#  * @param key the name of that application-specific parameter
#  * @param newVal the new value of the parameter
#  *
#  * @output the previous value of the parameter (or empty string if none)
#  *
#  * __apparam_put appId key newVal
#  */
unset -f __apparam_put ;
function __apparam_put() {
    local key=$( __apparam_keyFor "$1" "$2" ) ;
    local oldVal=$( __apparam_get "$1" "$2" ) ;

    local newVal="$3" ;

    __apparam_setEnv "$key" "$newVal" ;

    echo "$oldVal" ;
}

unset -f __apparam_echoHelp ;
function __apparam_echoHelp() {
    local appId="${1:?Missing argument 1 specifying appId}" ;
     __apparam_getMeta "$appId" "$APPARAM_METAKEY_HELP" ;
}

unset -f __apparam_getOpt ;
function __apparam_getOpt() {
    local appId="${1:?Missing argument 1 specifying appId}" ;
    local longOptions=$( __apparam_getMeta "$appId" "$APPARAM_METAKEY_OPTIONS" ) ;

    local pristineArgs="$*" ;
    local getoptOutput=$( getopt -o hv --long "help,verbose,$longOptions" --name "$0" -- "$@" ) \
        && eval set -- "$getoptOutput" || return $NOOP ;

    while [ "$1" ] ; do case "$1" in 
            -h|--help ) 
                shift ;
                __apparam_echoHelp "$appId" ;
                return `true` ;
                ;;

            -v|--verbose ) 
                shift ;
                local verbosity=$( __apparam_get "$appId" 'verbose' ) ;
                __apparam_put "$appId" 'verbose' $(( ${verbosity:-0}++ )) ;

                continue ;
                ;;

            -- )
                shift ;
                break ;
                ;;
        esac

        local option="$1" ;
        shift ;

        if ( echo $longOptions | egrep "\b${option}:\b") ; then
            __apparam_put "$appId" "$option" "$2" ;
            shift ;
        else
            __apparam_put "$appId" "$option" "${APPARAM_FLAG_VALUE:-$APPARAM_DEFAULT_FLAG_VALUE}" ;
        fi
    done
}


unset -f __apparam_test ;
function __apparam_test() {
    local appId='xApparamTest' ;

    __apparam_init   "$appId" 'flag' 'value:' 'foo' ;
#    __apparam_getOpt "$appId" $* ;

    export | fgrep APPARAM ;
}


touchLib ${BASH_SOURCE[0]} ; fi ;

