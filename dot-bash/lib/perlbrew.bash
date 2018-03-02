
if ! pingLib ${BASH_SOURCE[0]} ; then

PERLBREW_BASHRC="$HOME/perl5/perlbrew/etc/bashrc" ;

[ -f "$PERLBREW_BASHRC" ] && . "$PERLBREW_BASHRC"

RAKUDOBREW_BIN="$HOME/.rakudobrew/bin/rakudobrew" ;

# git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew
# echo 'export PATH=~/.rakudobrew/bin:$PATH' >> ~/.bashrc
# apt-get install build-essential git libssl-dev
# eval "$(/home/ronstra/.rakudobrew/bin/rakudobrew init -)"

# Broken right now.  :(
# [ -x $RAKUDOBREW_BIN ] && eval $( $RAKUDOBREW_BIN init - ) ;

touchLib ${BASH_SOURCE[0]} ; fi ;


