
__resourceName='status' ; if ! pingLib "$__resourceName" ; then

needsLib 'truth' ;

[[ -z "${RV_SUCCESS:-}" ]] && declare -r -i RV_SUCCESS=0 ;
[[ -z "${RV_FAILURE:-}" ]] && declare -r -i RV_FAILURE=1 ;
[[ -z "${RV_TRUE:-}"    ]] && declare -r -i RV_TRUE=$RV_SUCCESS ;
[[ -z "${RV_FALSE:-}"   ]] && declare -r -i RV_FALSE=$RV_FAILURE ;
[[ -z "${RV_NOOP:-}"    ]] && declare -r -i RV_NOOP=$RV_SUCCESS ;

declare -i RV_FAILBASE=$(( RV_FAILURE+1  )) ;
declare -i RV_MISMATCH=$(( RV_FAILBASE++ )) RV_MISSING=$(( RV_FAILBASE++ )) RV_SYNTAX=$(( RV_FAILBASE++ )) ;

touchLib $__resourceName ; unset __resourceName ; fi ;


