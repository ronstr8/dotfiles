
__resourceName='perlbrew' ; if ! pingLib "$__resourceName" ; then

[ -f "$HOME/perl5/perlbrew/etc/bashrc" ] && . "$HOME/perl5/perlbrew/etc/bashrc"

touchLib "$__resourceName" ; unset __resourceName ; fi ;


