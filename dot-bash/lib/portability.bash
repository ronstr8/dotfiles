### portability
###     Functions to make this bashrc suite work across as many platforms as
###     practical.
#
## -- 
## Ronald E. Straight <straightre@gmail.com>

if ! pingLib ${BASH_SOURCE[0]} ; then

unset -f date-Is ; function date-Is() {

    if date -Is $* 2>/dev/null ; then
        return ;
    elif (( ! $# )) ; then
        date +%Y-%m-%dT%H:%M:%S ;
        return ;
    fi

    perl -e 'use File::stat; use Getopt::Long qw( :config no_ignore_case gnu_getopt ); use POSIX qw( strftime ); GetOptions("date|d=s" => \my $ds, "reference|r=s" => \my $rf, "utc|u!" => \my $utc) or die "failed to parse all options\n"; die "-d only supports @<epoch-seconds>\n" if $ds and not($ds =~ s/^@(\d+)$/$1/); $rf && $rf =~ s/~/$ENV{HOME}/; die "failed to stat -f $rf\n" if $rf and not($fs = stat($rf)); my $es = defined($ds) ? $ds : ( $rf ? stat($rf)->mtime : time ); my(@lt) = $utc ? gmtime($es) : localtime($es); my $dt=strftime("%Y-%m-%dT%H:%M:%S", @lt); print "$dt\n"' -- $@ ;
} ;

touchLib ${BASH_SOURCE[0]} ; fi ;


