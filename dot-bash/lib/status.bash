
if ! pingLib ${BASH_SOURCE[0]} ; then

needsLib 'truth' ;

[[ -z "${RV_SUCCESS:-}" ]] && declare -x -i  RV_SUCCESS=0 ;
[[ -z "${RV_FAILURE:-}" ]] && declare -x -i  RV_FAILURE=1 ;
[[ -z "${RV_TRUE:-}"    ]] && declare -x -i  RV_TRUE=$RV_SUCCESS ;
[[ -z "${RV_FALSE:-}"   ]] && declare -x -i  RV_FALSE=$RV_FAILURE ;
[[ -z "${RV_NOOP:-}"    ]] && declare -x -i  RV_NOOP=$RV_SUCCESS ;

declare -x -i  RV_FAILBASE=$(( RV_FAILURE+1  )) ;
declare -x -i  RV_MISMATCH=$(( RV_FAILBASE++ )) RV_MISSING=$(( RV_FAILBASE++ )) RV_SYNTAX=$(( RV_FAILBASE++ )) ;

## [[ -z "${RV_NAN:-}" ]] && export RV_NAN='NaN'; ## Not a Number, so can't "return" this "value" from a bash function.

touchLib ${BASH_SOURCE[0]} ; fi ;

