## session [options]
##
##      Write hardcopy of current screen window and its history to a session
##      directory.  Default check of $WINDOW to determine window number.
##
##      If second arg is given, the part before the slash is considered the
##      window number and the part after the title.  The window will be renumbered and
##      retitled.  If another window existed with that number, it will be moved to
##      the $WINDOW envvar, or renamed with a date extension if no $WINDOW.
##
##  --status         Show data relevant to the current session.
##  --dump-hardcopy
##
##  --screeenrc  Write a new screenrc in the root session directory.
##  --commit     Commit session directory changes to VCS (git).
##  --vivify     Create the session directory if it does not exist.
##
##  --checkpoint Intended to be called from a PROMPT_COMMAND; save session state
##               if it has been more than a half hour since last save.
##
##  --session=s  The name of the current session, default $SESSION_NAME.
##
##  --title=s       Set the title of the current window, default $WINDOW_TITLE.
##  --renumber-to=n Change the current window number, swapping state files if it already exists.
##
##  --verbose  Include more output at verbosity level 1.
##  --debug    ... add 10 to the verbosity value.
##  --trace    ... and 20 to the verbosity value.
##
##  --terse    Omit any unnecessary embellishment from output.
##
##  --help     Show this message.
##
## -- 
## Ronald E. Straight <straight@adiant.com>

if ! pingLib ${BASH_SOURCE[0]} ; then

function __giveHelpThenLeave() {
    declare thisFile=${BASH_SOURCE[0]} ;

    awk '/^## -- $/ { exit } !/^#!/ { gsub("^#+ ?", "") ; print }' "$thisFile" >&2 ;
    exit $NOOP ;
} ;

function __getOptions() {
    declare -a allOptions=(
        debug
        trace
        terse
        eval
        screenrc
        commit
        vivify
        session:
        title:
        renumber-to:
        restore-window:
        checkpoint
        status
        dump-hardcopy
    ) ;

    declare pristineArgs="$*" ;
    declare longOpts="$( echo "${allOptions[*]}" | sed -e 's/[[:space:]]+/,/gm' )"
    declare getoptOutput=$( getopt -o hvn --long "help,verbose,dry-run,$longOpts" --name "$0" -- "$@" ) \
        && eval set -- "$getoptOutput" || return $NOOP ;

    while true ; do case "$1" in
            --status )
                DO_STATUS='yes' ; shift ;;
            --dump-hardcopy )
                DO_HARDCOPY_DUMP='yes' ; shift ;;
            --eval )
                EVAL='yes' ; shift ;;
            --screenrc )
                WRITE_SCREENRC='yes' ; shift ;;
            --commit )
                COMMIT_SESSION='yes' ; shift ;;
            --vivify )
                VIVIFY='yes' ; shift ;;

            --checkpoint )
                CHECKPOINT_WAIT_SECONDS=1800 ; shift ;;
            --session )
                OPT_SESSION="$2" ; shift 2 ;;
            --title )
                RETITLE_TO="$2" ; shift 2 ;;
            --renumber* )
                RENUMBER_TO="$2" ; shift 2 ;;
            --restore* )
                RESTORE_FROM="$2" ; shift 2 ;;


            -h|--help )
                    __giveHelpThenLeave ;;
            -v|--verbose )
                    VERBOSITY+=1 ; VERBOSISM[${#VERBOSISM[@]}]='verbose' ; shift ;;
            -n|--dry-run ) DRY_RUN=1 ; VERBOSITY+=1 ; VERBOSISM[${#VERBOSISM[@]}]='dry-run' ; shift ;;

            --debug )
                    VERBOSITY+=10 ; VERBOSISM[${#VERBOSISM[@]}]='debug' ; shift ;;
            --trace )
                    TRACE='trace' ; VERBOSITY+=20 ; VERBOSISM[${#VERBOSISM[@]}]='trace' ; shift ;;
            --terse )
                    TERSE='terse' ; shift ;;
            -- )
                    shift ; break ;;
    esac ; done

    if [ ! "$OPT_SESSION" -a $# -eq 1 -a "$pristineArgs" = "$*" ] ; then
        OPT_SESSION="$1" ; shift ;
    fi
} ;

function __whinge() {
    ## Prefix shell comment markers before all whinging so as not to interfere with --eval.
    echo "# [$( date -Is )] $*" 1>&2 ;
} ;

function __croak() {
    __whinge $@ ;
    return $ERR ;
} ;

function __buildWindowDir() {
    local sessionDir="${1}" ;
    local windowNum="${2}" ;

    printf '%s/window-%02d' "$sessionDir" "$windowNum" ;
} ;

function __parseWindowDir() {
    local windowDir="${1}" ;

    echo "$windowDir" | sed -e 's/^.\+-0\?\([0-9]\+\)$/\1/;'
} ;

function __echoScreenRc() {
    local sessionName="${1}" ;
    local sessionDir="${2}" ;
    local currentWinNumber="${3}" ;


    [ "$sessionName" ] || __croak "echoScreenRc needs a sessionName." || return $ERR ;

    [ "$sessionDir" ] && [ -d "$sessionDir" ] || __croak "__echoScreenRc receiving missing or non-directory sessionDir." ;

    [ "$sessionName" ] || __croak "echoScreenRc needs a currentWinNumber." || return $ERR ;


    local promptCommand='eval `session --checkpoint`' ;
    ## Below is checkoing PROMPT_COMMAND when `session` is run and not necessarily when screenrc is executed.
    # echo "$PROMPT_COMMAND" | fgrep -v 'session --checkpoint' && promptCommand="$PROMPT_COMMAND ; $promptCommand" ;

    ## TODO: Don't overwrite some of these options (defwrap, hardcopy_append)
    ## and instead respect preferences from ~/.screenrc.

    cat <<EOT ;
    ## Generated by $0 at $( date -Is )."
    
    source '$HOME/.screenrc'
    
    sessionname '$sessionName'
    
    setenv SESSION_NAME '$sessionName'
    setenv PROMPT_COMMAND '$promptCommand'

    ## Hmm-- will wordwrap fuck our hardcopies?
    defwrap on

    ## Appending creates huge hardcopy files.  Maybe backup (or commit
    ## to VC) the old file when we dump anew in __loadWindowState?
    hardcopy_append off

EOT

    #   stuff "history -d \$(( --HISTCMD )) && cat \015"

    for winDir in $( ls -1d $sessionDir/window-* ) ; do
        local winNumber="$( __parseWindowDir "$winDir" )" ; # echo $winDir | sed -e 's/^.\+window-//;' )" ; # ${dir/*\/window-/}" ;
        local winCwd="$( cat "$winDir/$CHDIR_BASENAME" 2> /dev/null )" ;
        local winTitle="$( cat "$winDir/$TITLE_BASENAME" 2> /dev/null )" ;
#        local winScreenlogFile="$winDir/$SCREENLOG_BASENAME" ;
        local winHardcopyFile="$winDir/$HARDCOPY_BASENAME" ;
        local winHistoryFile="$winDir/$HISTORY_BASENAME" ;
        local winEnvFile="$winDir/$ENV_BASENAME" ;
        local winRcFile="$winDir/$WINDOWRC_BASENAME" ;
        local winLoginFile="$winDir/$WINDOWLOGIN_BASENAME" ;

        local screenCmd='screen' ;
        [ "$winTitle" ] && screenCmd="${screenCmd} -t '$winTitle'" ;
        screenCmd="${screenCmd} $winNumber" ;

        local chdirCmd=''
        [ "$winCwd" ] && chdirCmd="chdir '$winCwd'" ;

        local winHeader="Window #$winNumber " ;
        [ "$winTitle" ] && winHeader="${winHeader} AKA \"$winTitle\"" ;

        local windowRcCmd='' ;
        [ -e "$winRcFile" ] && windowRcCmd="source '$winRcFile'" ;

        local scrollbackCmd='' ;
        [ -e "$winHardcopyFile" ] && scrollbackCmd="exec cat '$winHardcopyFile'" ;

        local windowLoginCmd='' ;
        [ -e "$winLoginFile" ] && windowLoginCmd="source '$winLoginFile'" ;

        cat <<EOT ;

        ## $winHeader

        $chdirCmd

        setenv WINDOW_HOME "$winDir"
        setenv WINDOW_NUMBER "$winNumber"
        setenv WINDOW_TITLE "${winTitle:-win$winNumber}"
        setenv HISTFILE "$winHistoryFile"

        hardcopydir "$winDir"

EOT

        if false ; then
            cat <<EOT ;

        logfile "$winScreenlogFile"
        logfile flush 30
        logtstamp on
        logtstamp after 120
        log on

EOT
        fi

        if [ -e "$winRcFile" ] ; then
            echo "source '$winRcFile'" ;
        fi

        echo "$screenCmd"

        if [ -e "$winHardCopyFile" -a "$LOAD_SAVED_HARDCOPY" ] ; then
            echo "$scrollbackCmd" ;
        fi

        cat <<'EOT' ;

        clear
        stuff "\n"

EOT

        if [ -e "$winLoginFile" ] ; then
            echo "source '$winLoginFile'" ;
        fi

    done

    echo 'unsetenv HISTFILE' ;

    echo "select $currentWinNumber" ;
    echo ;
    echo "## vim: ft=screen" ;
    echo ;
} ;

function __evalCommented() {
    __whinge "\$ $*" ;
    eval $* 1>&2 | sed -e 's/^/# /g;' ;
} ;

function __changeWindowNumber() {
    local sessionDir="$1" ;
    local currWindowNumber="$2" ;
    local destWindowNumber="$3" ;

    [ "$sessionDir"       ] || __croak "__changeWindowNumber needs a sessionDir."       || return $ERR ; 
    [ "$currWindowNumber" ] || __croak "__changeWindowNumber needs a currWindowNumber." || return $ERR ;
    [ "$destWindowNumber" ] || __croak "__changeWindowNumber needs a destWindowNumber." || return $ERR ;

    local currWindowDir="$( __buildWindowDir "$sessionDir" "${currWindowNumber}" )";
    local destWindowDir="$( __buildWindowDir "$sessionDir" "${destWindowNumber}" )";

    local movedWindowNumber="$currWindowNumber" ;
    local movedWindowHistoryFile="$currWindowDir/$HISTORY_BASENAME" ;

    local tempWindowDir="$sessionDir/moving-${destWindowNumber}-$( date +'%Y%m%d%H%M%S' )" ;

    local destWindowHistoryFile="$destWindowDir/$HISTORY_BASENAME" ;

    if [ -d "$destWindowDir" ] ; then
        [ "$DEBUG" ] && __whinge "Moving $destWindowDir to $tempWindowDir ... " ;

        __evalCommented $MV_CMD "'$destWindowDir'" "'$tempWindowDir'" ;
    fi

    if [ -d "$currWindowDir" ] ; then
        [ "$DEBUG" ] && __whinge "Moving $currWindowDir to $destWindowDir ... " ;

        __evalCommented $MV_CMD "'$currWindowDir'" "'$destWindowDir'" ;
    fi

    if [ -d "$tempWindowDir" ] ; then
        [ "$DEBUG" ] && __whinge "Moving $tempWindowDir to $currWindowDir ... " ;

        __evalCommented $MV_CMD "'$tempWindowDir'" "'$currWindowDir'" ;
    fi

    ## This changes our number but keeps our focus in the current window.
    screen -X number $destWindowNumber ;

    MOVED_WINDOW_NUMBER="$movedWindowNumber" ;
    MOVED_WINDOW_HISTORY_FILE="$movedWindowHistoryFile" ;

    WINDOW_NUMBER="$destWindowNumber" ;
    WINDOW_HISTORY_FILE="$destWindowHistoryFile" ;
    WINDOW_HOME="$destWindowDir" ;

    return $OK ;
} ;

function __commitSessionToVcs() {
    local sessionDir="$1" ;

    [ "$sessionDir" ] || __croak "__mvWindowDir needs a sessionDir." || return $ERR ;

    export GIT_DIR="$sessionDir/.git" ;

    local gitXargs=" --git-dir="'$sessionDir/.git'" --work-tree="'$sessionDir'" " ;

    __whinge "Committing changes in $sessionDir ... " ;

    local commitMsg="Checkpoint of session data." ;

    ## TODO Maybe make these git sequences optional.

    __evalCommented git $gitXargs init --quiet
    __evalCommented git $gitXargs add "'$sessionDir'"
    __evalCommented git $gitXargs commit --message="'$commitMsg'" "'$sessionDir'"

} ;

function __echoBashEnv() {
    local winDir="${1:-$WINDOW_HOME}" ;
#    local winLogFile="$winDir/$SCREENLOG_BASENAME" ;
    local winHistoryFile="$winDir/$HISTORY_BASENAME" ;

    ## ( env ; export ; echo -e "\n\nunset BASH_ENV\n" ) | grep -v '\(DISPLAY\|SSH_\w\+\|STY\|SHLVL/HISTFILE\)=' > "$WINDOW_ENV_FILE"

    export | grep '\(HISTFILE\|SESSION_NAME\|WINDOW\|WINDOW_NUMBER\|WINDOW_TITLE\|OLDPWD\)' | sed 's/$/ ;/g;' ;

    echo ;

    dirs -l -p | sed 's/^/pushd -n /g; s/$/ ;/g;' ;

    cat <<EOT ;

    # cat '${winLogFile}' ;

    export HISTFILE='${winHistoryFile}' ;
    [[ -e "$HISTFILE" ]] && history -r $HISTFILE ;

    unset BASH_ENV ;

EOT
} ;

function __echoExports() {
    declare declaration='declare -x' varName='' ;

    for varName in "${SESSION_VARS[@]}" ; do
        declaration+=" $varName='${!varName}'" ;
    done

    echo "$declaration" ;
} ;

function __maybeVivifySessionDir() {
    if [ -d "$SESSION_HOME" ] ; then
        return ;
    elif [ "$VIVIFY" ] ; then
        mkdir -p "$SESSION_HOME" ;
    else
        __croak "Cannot continue if $SESSION_HOME does not exist and no --vivify." || return $ERR ;
        return $ERR ;
    fi
} ;

function __isWindowAlive() {
    local windowNumber="$1" ;
    local touchFile="/tmp/session-window-check-$RANDOM" ;

    screen -p "$windowNumber" -X exec touch $touchFile ;

    local windowIsAlive='' ;

    if [ -e "$touchFile" ] ; then
        windowIsAlive=$OK ;
    else
        windowIsAlive=$ERR ;
    fi
    
    rm -f $touchFile ;

    return $windowIsAlive ;
} ;

function __validateSessionState() {
    if [ "$OPT_SESSION" ] ; then
        SESSION_NAME="$OPT_SESSION" ;
    elif [ "$SESSION_NAME" ] ; then
        true ;
    elif [[ "$STY" =~ ^[0-9]+\..+ ]] ; then
        SESSION_NAME=$( echo "$STY" | cut -d. -f2- ) ; 
    else
        __croak 'Cannot continue without $SESSION_NAME, $STY indicating a name, or --session=s.' || return $ERR ;
    fi

    SESSION_HOME="$FRIDGE_DIR/$SESSION_NAME" ;
} ;

function __validateWindowState() {
    ## TODO $WINDOW was when it launched-- maybe not now.  Warn when used?
    if [ ! "$WINDOW_NUMBER" ] ; then
        if [ "$WINDOW" ] ; then
            __whinge "Defaulting WINDOW_NUMBER=$WINDOW." ;
            WINDOW_NUMBER="$WINDOW" ;
        else 
            __croak 'Cannot continue without $WINDOW_NUMBER or $WINDOW.' || return $ERR ;
        fi
    elif [ "$WINDOW" -a "$WINDOW_NUMBER" != "$WINDOW" ] ; then
        __whinge "WINDOW=$WINDOW != WINDOW_NUMBER=$WINDOW_NUMBER; setting WINDOW_NUMBER=$WINDOW." ;
        WINDOW_NUMBER="$WINDOW" ;
    fi

    export WINDOW_HOME="$( __buildWindowDir "$SESSION_HOME" "$WINDOW_NUMBER" )" ;
    return $OK ;
} ;

function __maybeRenumberWindow() {
    if [ ! "$RENUMBER_TO" ] ; then
        return $OK ;
    elif [ "$RENUMBER_TO" -eq "$WINDOW_NUMBER" ] ; then
        __whinge "\$WINDOW_NUMBER $WINDOW_NUMBER is same as given --renumber-to.  No change to window number." ;
        return $OK ;
    fi

    __changeWindowNumber "$SESSION_HOME" "$WINDOW_NUMBER" "$RENUMBER_TO" || return $ERR ;

    return $OK ;
} ;

function __maybeRetitleWindow() {
    if [ ! "$RETITLE_TO" ] ; then
        return $OK ;
    fi
    
    screen -X title "$RETITLE_TO" ;
    export WINDOW_TITLE="$RETITLE_TO" ;

    return $OK ;
} ;

function __dumpWindowHardcopy() {
    ## This just ensures our default hardcopy directory is set.
    screen -X hardcopydir "$WINDOW_HOME" ;

    local hcFile="$WINDOW_HARDCOPY_FILE" ;

    if [ -e "$hcFile" ] ; then
        local hcLastModYmd="$( date --ref="$hcFile" +%Y%m%d )" ;
        local todayYmd="$( date +%Y%m%d )" ;

        if [ "$hcLastModYmd" != "$todayYmd" ] ; then
            local hcFileArchived="${hcFile}.${todayYmd}" ;
            [ "$DEBUG" ] && __whinge "Moving older $hcFile to $hcFileArchived ... " ;
            mv "$hcFile" "$hcFileArchived" ;
        fi
    fi

    screen -X hardcopy -h "$hcFile" ;
} ;

function __saveWindowState() {
    declare histFile="${WINDOW_HISTORY_FILE:-$HISTFILE}" ;

    if [[ -e "$histFile" ]] ; then
        declare historyCommand="history -a \"${WINDOW_HISTORY_FILE:-$HISTFILE}\"" ;
        if [ "$EVAL" ] ; then
            echo "$historyCommand ; " ;
        else
            $historyCommand
        fi
    else
        touch "$histFile" ; 
    fi

    [ "$WINDOW_TITLE" ] && echo "$WINDOW_TITLE" > "$WINDOW_TITLE_FILE" ;

    pwd > "$WINDOW_CHDIR_FILE" ;

    __echoBashEnv > "$WINDOW_ENV_FILE" ;

    __dumpWindowHardcopy ;

    [ "$WRITE_SCREENRC" ] && __echoScreenRc "$SESSION_NAME" "$SESSION_HOME" "$WINDOW_NUMBER" > "$SESSION_HOME/screenrc" ;
    [ "$COMMIT_SESSION" ] && __commitSessionToVcs "$SESSION_HOME" ;
    [ "$EVAL" ] && __echoExports ;
} ;

function __loadWindowState() {
    local sessionName="${1}" ;
    local sessionDir="${2}" ;
    local winNumber="${3:-$WINDOW}" ;

    local winDir="$( __buildWindowDir "$sessionDir" "${winNumber}" )";

    local winCwd="$( cat "$winDir/$CHDIR_BASENAME" 2> /dev/null )" ;
    local winTitle="$( cat "$winDir/$TITLE_BASENAME" 2> /dev/null )" ;
#    local winScreenlogFile="$winDir/$SCREENLOG_BASENAME" ;
    local winHardcopyFile="$winDir/$HARDCOPY_BASENAME" ;
    local winHistoryFile="$winDir/$HISTORY_BASENAME" ;
    local winEnvFile="$winDir/$ENV_BASENAME" ;

    export SESSION_NAME="$sessionName" ;
    export WINDOW="$winNumber" ;
    export WINDOW_NUMBER="$winNumber" ;
    export WINDOW_HOME="$winDir" ;
    export WINDOW_TITLE="${winTitle:-win$winNumber}" ;
    export HISTFILE="$winHistoryFile"

    [ "$EVAL" ] && __echoExports ;

    [ -e "$winHistoryFile" ] && history -r "$winHistoryFile" ;

    return $OK ;
} ;

function __readyForCheckpoint() {
    local staleSeconds=${1:-1800} ;
    local refFile="$WINDOW_HOME/$HISTORY_BASENAME" ;

    local nowEpoch ;
    local refEpoch ;

    if [[ ! -e "$refFile" ]] ; then
        ## Never wrote session, so do a checkpoint.
        nowEpoch=0 ;
        refEpoch=1 ;
        ## And touch the refFile.
        touch $refFile ;
    else
        nowEpoch=$( date +%s ) ;
        refEpoch=$( date +%s --reference="$refFile" ) ;
    fi
 
    if (( ( refEpoch + staleSeconds ) < nowEpoch )) ; then
#       EVAL='yes' ;
        VIVIFY='yes' ;
        WRITE_SCREENRC='yes' ;
    fi

    return $OK ;
} ;

function __echoStatus() {
    local winDir subDir histFile histTime hcFile cwdFile cwd titleFile title statusLine ;
    local wtf='‽‽‽' ;

    __whinge "$SESSION_HOME" ;
    __whinge ;

    for winDir in $SESSION_HOME/window-* ; do
        subDir=$( basename $winDir ) ;

        histFile="$winDir/$HISTORY_BASENAME" ;
        histTime=$( date --ref="$histFile" +'%m/%d/%Y@%H:%M:%S' 2>/dev/null ) ;

        hcFile="$winDir/$HARDCOPY_BASENAME" ;

        cwdFile="$winDir/$CHDIR_BASENAME" ;
        cwd=$( cat "$cwdFile" | awk '{ home=ENVIRON["HOME"]; print gensub(home, "~", "g", $1); }' ) ;

        titleFile="$winDir/$TITLE_BASENAME" ;
        title=$( cat "$titleFile" ) ;

        statusLine=$( printf "%s AKA %-12s %s   %s" "$subDir" "${title:-$wtf}" "${histTime:-$wtf}" "${cwd:-$wtf}" ) ;
        __whinge "$statusLine" ;
    done

    __whinge ;

    __whinge "$( __echoExports )" ; # exportables ;" ;
#   __whinge $( export | grep -E 'WINDOW|STY|HISTFILE|SESSION|SCREEN' | xargs | sed -e 's/ declare -x \(\w\+\)='?\(\)'?/ /g;' ) ;

    return $OK ;
} ;

## 0-black 1-red 2-green 3-yellow 4-blue 5-magenta 6-cyan 7-white

function __dumpHardcopyFiles() {
    declare    fileName='' skippedLine='' ;
    declare -a skippedLines=() ;
    declare -i skippedLineThreshold=24 ;

    for fileName in "$@" ; do
        cat $fileName | while read ; do
            if [[ "$REPLY" =~ ^[[:space:]]*$ ]] ; then
                skippedLines[${#skippedLines[@]}]="$REPLY" ;
                continue ;
            fi

            if [[ ${#skippedLines[@]} -le $skippedLineThreshold ]] ; then
                for skippedLine in "${skippedLines[@]}" ; do
                    echo $skippedLine ;
                done
            else
                ## Print a brief "skip-notice" if count exceeds threshold.
                printf '\n\n## skippedLines+=%d %s%s%s\n\n' ${#skippedLines[@]} "$( tput setaf 3 )" "$( yes '#' | head -n 10 | xargs )" "$( tput sgr0 )" ;
            fi

            skippedLines=() ;

            echo "$REPLY" ;
        done
    done

    return $OK ;
} ;

function __main() {
    __validateSessionState  || return $ERR ;
    __maybeVivifySessionDir || return $ERR ;

    if [ ! "$STY" -a "$SESSION_HOME" ] ; then
        local screenRc="$SESSION_HOME/screenrc" ;

        if [ ! -e "$screenRc" ] ; then
            __echoScreenRc "$SESSION_NAME" "$SESSION_HOME" "0" > "$screenRc" ;
        fi

        exec screen -c "$screenRc" ;
        return ; # Never reached.
    else
        screen -X setenv SESSION_NAME "$SESSION_NAME" ;
    fi

    __validateWindowState   || return $ERR ;

    mkdir -p $WINDOW_HOME ;

    if [ "$CHECKPOINT_WAIT_SECONDS" ] ; then
        __readyForCheckpoint || return $ERR ;
    fi

    __maybeRetitleWindow  || return $ERR ;
    __maybeRenumberWindow || return $ERR ;

    if [ "$RESTORE_FROM" ] ; then
        if __loadWindowState "$SESSION_NAME" "$SESSION_HOME" "$RESTORE_FROM" ; then
            return $OK ;
        else
            return $ERR ;
        fi
    fi

    WINDOW_HISTORY_FILE="$WINDOW_HOME/$HISTORY_BASENAME" ;
    WINDOW_TITLE_FILE="$WINDOW_HOME/$TITLE_BASENAME" ;
    WINDOW_CHDIR_FILE="$WINDOW_HOME/$CHDIR_BASENAME" ;
#    WINDOW_SCREENLOG_FILE="$WINDOW_HOME/$SCREENLOG_BASENAME" ;
    WINDOW_HARDCOPY_FILE="$WINDOW_HOME/$HARDCOPY_BASENAME" ;
    WINDOW_ENV_FILE="$WINDOW_HOME/$ENV_BASENAME" ;

    export HISTFILE="$WINDOW_HISTORY_FILE" ;
    export SESSION_HOME SESSION_NAME  ;
    export WINDOW_HOME WINDOW_NUMBER WINDOW_TITLE ;

    if [ "$DO_STATUS" ] ; then
        __echoStatus ; return $OK ;
    fi

    if [ "$DO_HARDCOPY_DUMP" ] ; then
        __dumpHardcopyFiles ${WINDOW_HOME}/${HARDCOPY_BASENAME}.* $WINDOW_HARDCOPY_FILE ; return $OK ;
    fi

    __saveWindowState || return $ERR ;
} ;

function __session() {
    declare -x    SCRIPT_DIR="$( dirname $0 )" ;
    declare -x    SCRIPT_NAME="$( basename $0 )" ;
    declare -x -i NOOP=2 ERR=1 OK=0 ;

    declare -x DO_STATUS='' WRITE_SCREENRC='' COMMIT_SESSION='' ;
    declare -x VIVIFY='' RETITLE_TO='' RENUMBER_TO='' OPT_SESSION='' ;
    declare -x RESTORE_FROM='' CHECKPOINT_WAIT_SECONDS='' ;
    declare -x LOAD_SAVED_HARDCOPY='yes' DO_HARDCOPY_DUMP='' ;
    declare -x MOVED_WINDOW_NUMBER='' MOVED_WINDOW_HISTFILE='' ;

    declare -x MV_CMD='mv' ;

    declare -x -a SESSION_VARS=( SESSION_NAME SESSION_HOME
        WINDOW WINDOW_NUMBER WINDOW_HOME WINDOW_TITLE HISTFILE) ;

    declare -x FRIDGE_DIR="$HOME/.screen/sessions" ;

    declare -x CHDIR_BASENAME='chdir' ;
    declare -x TITLE_BASENAME='title' ;
    declare -x HISTORY_BASENAME='history' ;
    declare -x ENV_BASENAME='env' ;
    declare -x HARDCOPY_BASENAME='hardcopy' ;

    declare -x WINDOWRC_BASENAME='windowrc' ; ## Sourced before screen is created.
    declare -x WINDOWLOGIN_BASENAME='window_login' ; ## Source after screen is created.

    ## Run main program code in a subshell so any `exit' thrown will not cause
    ## the sourcing shell to exit.

    ( __getOptions $* && __main $* ) ;
} ;

touchLib ${BASH_SOURCE[0]} ; fi ;

## vim: ft=sh:expandtab:tabstop=4

