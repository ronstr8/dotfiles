
if ! pingLib ${BASH_SOURCE[0]} ; then

needsLib 'truth' ;

[[ -z "${RV_SUCCESS:-}" ]] && export RV_SUCCESS=0 ;
[[ -z "${RV_FAILURE:-}" ]] && export RV_FAILURE=1 ;
[[ -z "${RV_TRUE:-}"    ]] && export RV_TRUE=$RV_SUCCESS ;
[[ -z "${RV_FALSE:-}"   ]] && export RV_FALSE=$RV_FAILURE ;
[[ -z "${RV_NOOP:-}"    ]] && export RV_NOOP=$RV_SUCCESS ;

export RV_FAILBASE=$(( RV_FAILURE+1  )) ;
export RV_MISMATCH=$(( RV_FAILBASE++ )) RV_MISSING=$(( RV_FAILBASE++ )) RV_SYNTAX=$(( RV_FAILBASE++ )) ;

[[ -z "${RV_NAN:-}" ]] && export RV_NAN='NaN'; ## Not a Number.

touchLib ${BASH_SOURCE[0]} ; fi ;

