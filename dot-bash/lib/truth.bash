
##     printf '========================================\n' >&2 ;
##     printf 'truth: @:%s\n' "$@" >&2 ;
##     printf 'truth: 0:%s\n' "$0" >&2 ;
##     printf 'truth: 1:%s\n' "$1" >&2 ;
##     printf 'truth: BASH_SUBSHELL:%s\n' "$BASH_SUBSHELL" >&2 ;
##     printf 'truth: SHLVL:%s\n' "$SHLVL" >&2 ;
##     printf 'truth: FUNCNAME:%s\n' "${FUNCNAME[@]}" >&2 ;
##     printf 'truth: BASH_SOURCE:%s\n' "${BASH_SOURCE[@]}" >&2 ;
##     printf 'truth: BASH_LINENO:%s\n' "${BASH_LINENO[@]}" >&2 ;
##     printf 'truth: PIPESTATUS:%s\n' "${PIPESTATUS[@]}" >&2 ;

__resourceName='truth' ; if ! pingLib "$__resourceName" ; then

[[ -z "${TRUE:-}"  ]] && declare -r -i TRUE=1 ;
[[ -z "${FALSE:-}" ]] && declare -r -i FALSE=0 ;

touchLib $__resourceName ; unset __resourceName ; fi ;



