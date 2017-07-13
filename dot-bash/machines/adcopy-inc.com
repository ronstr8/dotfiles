
## Give us a more recent locally-installed version of perl,
## and wrap an `ack' command around `beyondgrep'.

declare BEST_PERL='/usr/local/bin/perl' ;
declare BEYONDGREP="$HOME/bin/beyondgrep" ;

if [ -f $BEYONDGREP ] ; then
    function ack() { $BEST_PERL $BEYONDGREP "$@" ; }
fi

## Per-host history to avoid clobbering all into one over shared NFS home.

export HISTFILE="${HOME}/.history/${HOSTNAME}" ;

## @see /usr/share/lib/terminfo
## @see http://vim.wikia.com/wiki/Getting_colors_to_work_on_solaris
## @see man curses

#   export TERM='xterm-256color' ;
#   export TERMINFO="$HOME/.terminfo" ;

# @see /usr/share/lib/terminfo
# @see http://vim.wikia.com/wiki/Getting_colors_to_work_on_solaris
# @see man curses
export TERM='xterm-256color' ;
export TERMINFO="$HOME/.terminfo" ;
# Without the custom TERMINFO caps imported, use export TERM='xtermc', but it
# displays artifacts at times, e.g. when exiting vim.

## Fix some other bad choices for environment variables.

export PAGER='less' ;

## Aliases to GNU versions of common utilities.

[ -x /usr/sfw/bin/ggrep        ] && alias grep='/usr/sfw/bin/ggrep' ;
[ -x /usr/sfw/bin/gegrep       ] && alias egrep='/usr/sfw/bin/gegrep' ;
[ -x /usr/sfw/bin/gfgrep       ] && alias fgrep='/usr/sfw/bin/gfgrep' ;
[ -x /usr/sfw/bin/gmake        ] && alias make='/usr/sfw/bin/gmake' ;
[ -x /usr/sfw/bin/gtar         ] && alias tar='/usr/sfw/bin/gtar' ;

[ -x $HOME/src/screen/src/screen ] && alias screen="$HOME/src/screen/src/screen" ;

## Alias psql to most recent available version.

for subDir in /usr/local/pgsql-* ; do
    if [ -x "$subDir/bin/psql" ] ; then
        alias psql="LESS='-iMSx4 -FX' $subDir/bin/psql" ; 
    fi
done

## Add GNU and othertools to end of PATH, as we want the Solaris
## tools to come first.

for subDir in /opt/csw/{bin,sbin} ; do
    [ -d "$subDir" ] && pathmunge PATH "$subDir" after ;
done

function __SetPaths() {
    local repoDir="$HOME/dev/adcopy" ;
    local subDir pathDir gnuDir x11dir ;

    pathmunge 'PATH' "$HOME/bin" "$HOME/.local/bin" /usr/local/bin /sbin /usr/sbin /usr/local/sbin after ;

    for subDir in bin sbin tools bin/test ; do
        pathDir="$HOME/dev/adcopy/$subDir" ;
        [ -d "$pathDir" ] && pathmunge 'PATH' "$pathDir" after ;
    done

    for gnuDir in xpg4 sfw ; do
        for subDir in "/usr/$gnuDir/bin" "/usr/$gnuDir/sbin" ; do
            [ -d "$subDir" ] && pathmunge 'PATH' "$subDir" after ;
        done
    done

    if [ "$DISPLAY" ] ; then
        pathmunge 'PATH' /usr/openwin/demo after ;
        pathmunge 'PATH' /usr/openwin/bin after ;
        pathmunge 'PATH' /usr/X11R6/bin after ;
    fi
} ; __SetPaths ; unset -f __SetPaths ;

## Rough alternatives to GNU functionality.

if ! type -a stat &> /dev/null ; then
    # @see http://www.linuxquestions.org/questions/solaris-opensolaris-20/stat-command-on-solaris-934442/
    function stat() {
        ## Omits the actual output of `ls', showing only
        ## the stderr stats from `truss'.
        truss -t lstat64 -v lstat64 ls "$@" > /dev/null ;
    } ;
fi

# export TERMCAP=SC|screen-bce|VT 100/ANSI X3.64 virtual terminal:\
#         :DO=\E[%dB:LE=\E[%dD:RI=\E[%dC:UP=\E[%dA:bs:bt=\E[Z:\
#         :cd=\E[J:ce=\E[K:cl=\E[H\E[J:cm=\E[%i%d;%dH:ct=\E[3g:\
#         :do=^J:nd=\E[C:pt:rc=\E8:rs=\Ec:sc=\E7:st=\EH:up=\EM:\
#         :le=^H:bl=^G:cr=^M:it#8:ho=\E[H:nw=\EE:ta=^I:is=\E)0:\
#         :li#40:co#150:am:xn:xv:LP:sr=\EM:al=\E[L:AL=\E[%dL:\
#         :cs=\E[%i%d;%dr:dl=\E[M:DL=\E[%dM:dc=\E[P:DC=\E[%dP:\
#         :im=\E[4h:ei=\E[4l:mi:IC=\E[%d@:ks=\E[?1h\E=:\
#         :ke=\E[?1l\E>:vi=\E[?25l:ve=\E[34h\E[?25h:vs=\E[34l:\
#         :ti=\E[?1049h:te=\E[?1049l:us=\E[4m:ue=\E[24m:so=\E[3m:\
#         :se=\E[23m:mb=\E[5m:md=\E[1m:mh=\E[2m:mr=\E[7m:\
#         :me=\E[m:ms:\
#         :Co#8:pa#64:AF=\E[3%dm:AB=\E[4%dm:op=\E[39;49m:AX:\
#         :vb=\Eg:G0:as=\E(0:ae=\E(B:\
#         :ac=\140\140aaffggjjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~..--++,,hhII00:\
#         :po=\E[5i:pf=\E[4i:Km=\E[M:k0=\E[10~:k1=\EOP:k2=\EOQ:\
#         :k3=\EOR:k4=\EOS:k5=\E[15~:k6=\E[17~:k7=\E[18~:\
#         :k8=\E[19~:k9=\E[20~:k;=\E[21~:F1=\E[23~:F2=\E[24~:\
#         :F3=\E[1;2P:F4=\E[1;2Q:F5=\E[1;2R:F6=\E[1;2S:\
#         :F7=\E[15;2~:F8=\E[17;2~:F9=\E[18;2~:FA=\E[19;2~:\
#         :FB=\E[20;2~:FC=\E[21;2~:FD=\E[23;2~:FE=\E[24;2~:kb=:\
#         :K2=\EOE:kB=\E[Z:kF=\E[1;2B:kR=\E[1;2A:*4=\E[3;2~:\
#         :*7=\E[1;2F:#2=\E[1;2H:#3=\E[2;2~:#4=\E[1;2D:%c=\E[6;2~:\
#         :%e=\E[5;2~:%i=\E[1;2C:kh=\E[1~:@1=\E[1~:kH=\E[4~:\
#         :@7=\E[4~:kN=\E[6~:kP=\E[5~:kI=\E[2~:kD=\E[3~:ku=\EOA:\
#         :kd=\EOB:kr=\EOC:kl=\EOD:km:


## We aren't setting MANPATH anywhere in ~/.bash, but without unsetting it, we
## lose most man pages.
unset MANPATH ;

## Don't reply on __machinePrompt logic.
bashprompt 204 ;

# ps -e -o user,pid,pcpu,pmem,vsz,rss,tty,s,stime,time,args

# vim: ft=sh
