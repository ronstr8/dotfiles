
if ! pingLib ${BASH_SOURCE[0]} ; then

requireLib 'status' ;

function git-current-branch() {
	git rev-parse --abbrev-ref HEAD 2>/dev/null
##	git branch --no-color 2> /dev/null | awk '/^\*/ { print $2 }'
} ;

function git-cat-changed() {
    declare substring=${1:?Missing required arg of file substring} ;
    declare isDead=$2 ;

#   git whatchanged --no-abbrev | awk '$5 == "D" { printf("git cat-file -p %8.8s # %s\n", $3, $NF); }'

    declare -i maxCommits=9 ;
    declare    awkScript="${isDead:+\$5 == \"D\" &&} /$substring/ { print \$3 }" ;
    declare    commitFinder="git whatchanged --no-abbrev | awk '$awkScript' | head -n $maxCommits" ;

    echo "$commitFinder" ;

    declare -a commits=() ;
    read -a commits < <( eval $commitFinder ) ;

#   while read ; do
#       [[ $REPLY =~ $pattern ]] && sha[${#sha[@]}]="$REPLY" ;
#   done < <( git whatchanged --no-abbrev -n$maxCommits | awk "$awkScript" ) ;

    declare commit ;

    for commit in "${commits[@]}" ; do
        git-cat-file -p "$commit" | less ; # vim -R -c 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim'
    done
} ;

function git-dead-cat() {
    git-cat-changed "$1" 1 ;
} ;

function git-unmerged() {
    git status | awk 'BEGIN { unmerged=0; } /^# Unmerged paths:/ { unmerged=1; } unmerged && $NF ~ /\// { print $NF }' ;
} ;

function git-publish() {
    declare featureBranch="${1}" ;
    declare mergingBranch="${2:-demo/develop}" ;
    declare currentBranch=$( git-current-branch ) ;

    declare yesPattern='^[Yy]([Ee][Ss])?$' ;

    declare    promptMsg ;
    declare -i switchToMergingBranch=1 ;

    if [[ -z "$featureBranch" ]] ; then
        if [[ $currentBranch == $mergingBranch ]] ; then
            echo -e "${FUNCNAME}: No explicit feature branch and current is branch to be published." 1>&2 ;
            echo -e "${FUNCNAME}: Are you resuming a previous publishing attempt?  If so, try:" 1>&2 ;
            echo -e "\t${FUNCNAME} $featureBranch $mergingBranch" 1>&2 ;

            return $RV_FAILURE ;
        fi

        featureBranch="$currentBranch" ;
        promptMsg="Ready to publish your «$featureBranch» to «$mergingBranch»? (Yes/No) " ; 
    elif [[ $currentBranch == $mergingBranch ]] ; then
        echo -e "${FUNCNAME}: Current branch «$currentBranch» is the branch to be published." 1>&2 ;
        echo -e "${FUNCNAME}: Assuming merge issues with «$featureBranch» have been resolved." 1>&2 ;

        promptMsg="Ready to verify merge of «$featureBranch» and publish «$mergingBranch»? (Yes/No) " ; 
        switchToMergingBranch=0 ;
    fi

    ## TODO Refactor the confirmation prompt logic into a reusable function.

    while read -p "$promptMsg" ; do
        case "$REPLY" in
            YES)
                break ;;
            NO)
                echo "Aborting." >&2 ;
                return $RV_NOOP ;;
            *)
                echo -e "${FUNCNAME}: Please enter YES or NO." 1>&2 ;
        esac
    done

    ## XXX The implied --prune option here might be presumptious.

    if ! git fetch --all --prune ; then
        echo -e "${FUNCNAME}: Failed to update working copy metadata using fetch --all." 1>&2 ;

        return $RV_FAILURE ;
    fi


    if (( switchToMergingBranch )) ; then
        read -p "Continue w/«git checkout $mergingBranch»? " && [[ $REPLY =~ "$yesPattern" ]] || return $RV_NOOP ; ## DEBUG

        if ! git checkout "$mergingBranch" ; then
            echo -e "${FUNCNAME}: Failed to checkout «$mergingBranch»." 1>&2 ;
            echo -e "\tForget to commit? Try: git commit -a -m 'Issue #XXXXX: Stuff changed in $featureBranch.'" 1>&2 ;

            return $RV_FAILURE ;
        fi

        read -p "Continue w/«git pull»? " && [[ $REPLY =~ "$yesPattern" ]] || return $RV_NOOP ; ## DEBUG

        if ! git pull ; then
            echo -e "${FUNCNAME}: Failed to pull up-to-date «$mergingBranch»." 1>&2 ;

            return $RV_FAILURE ;
        fi
    fi

    read -p "Continue w/«git merge $featureBranch»? " && [[ $REPLY =~ "$yesPattern" ]] || return $RV_NOOP ; ## DEBUG

    if ! git merge "$featureBranch" ; then
        echo -e "${FUNCNAME}: Failed to merge «$featureBranch» into «$mergingBranch»." 1>&2 ;
        echo -e "${FUNCNAME}: Fix/commit unresolved issues, then try:" 1>&2 ;
        echo -e "\t${FUNCNAME} $featureBranch $mergingBranch" 1>&2 ;

        return $RV_FAILURE ;
    fi

    ## TODO A loop over merge/pull/push until all is resolved?

    read -p "Continue w/«git pull && git push»? " && [[ $REPLY =~ "$yesPattern" ]] || return $RV_NOOP ; ## DEBUG

    if ! git pull && git push ; then
        echo -e "${FUNCNAME}: Failed to pull updates and push merged changes to «$mergingBranch»." 1>&2 ;

        return $RV_FAILURE ;
    fi

    read -p "Continue w/«git checkout $featureBranch»? " && [[ $REPLY =~ "$yesPattern" ]] || return $RV_NOOP ; ## DEBUG

    if ! git checkout "$featureBranch" ; then
        echo -e "${FUNCNAME}: Failed to return to «$featureBranch»." 1>&2 ;

        ## XXX Just informational, although it does indicate a problem.
    fi

    git status ;
} ;



## TODO Make the following demo/develop untwister into a function.
## for xFn in www.adblade.com/application/modules/admin/views/scripts/apps/grid/revenue-body.phtml www.adblade.com/application/modules/admin/views/scripts/apps/grid/revenue-sl-body.phtml ; do git diff demo/develop -- $xFn ; done
## git blame to find who/when the conflicting change was made?
## TODO Just change git-publish to prefer changes from current branch (demo/develop) when merging?  How? --ours? --theirs?

function git-set-prompt() {
	#  Customize BASH PS1 prompt to show current GIT repository and branch.
	#  by Mike Stewart - http://MediaDoneRight.com

	#  Bunch-o-predefined colors.  Makes reading code easier than escape sequences.
	#  I don't remember where I found this.  o_O

	# http://mediadoneright.com/content/ultimate-git-ps1-bash-prompt

	# Reset
	Color_Off="\[\033[0m\]"       # Text Reset

	# Regular Colors
	Black="\[\033[0;30m\]"        # Black
	Red="\[\033[0;31m\]"          # Red
	Green="\[\033[0;32m\]"        # Green
	Yellow="\[\033[0;33m\]"       # Yellow
	Blue="\[\033[0;34m\]"         # Blue
	Purple="\[\033[0;35m\]"       # Purple
	Cyan="\[\033[0;36m\]"         # Cyan
	White="\[\033[0;37m\]"        # White

	# Bold
	BBlack="\[\033[1;30m\]"       # Black
	BRed="\[\033[1;31m\]"         # Red
	BGreen="\[\033[1;32m\]"       # Green
	BYellow="\[\033[1;33m\]"      # Yellow
	BBlue="\[\033[1;34m\]"        # Blue
	BPurple="\[\033[1;35m\]"      # Purple
	BCyan="\[\033[1;36m\]"        # Cyan
	BWhite="\[\033[1;37m\]"       # White

	# Underline
	UBlack="\[\033[4;30m\]"       # Black
	URed="\[\033[4;31m\]"         # Red
	UGreen="\[\033[4;32m\]"       # Green
	UYellow="\[\033[4;33m\]"      # Yellow
	UBlue="\[\033[4;34m\]"        # Blue
	UPurple="\[\033[4;35m\]"      # Purple
	UCyan="\[\033[4;36m\]"        # Cyan
	UWhite="\[\033[4;37m\]"       # White

	# Background
	On_Black="\[\033[40m\]"       # Black
	On_Red="\[\033[41m\]"         # Red
	On_Green="\[\033[42m\]"       # Green
	On_Yellow="\[\033[43m\]"      # Yellow
	On_Blue="\[\033[44m\]"        # Blue
	On_Purple="\[\033[45m\]"      # Purple
	On_Cyan="\[\033[46m\]"        # Cyan
	On_White="\[\033[47m\]"       # White

	# High Intensty
	IBlack="\[\033[0;90m\]"       # Black
	IRed="\[\033[0;91m\]"         # Red
	IGreen="\[\033[0;92m\]"       # Green
	IYellow="\[\033[0;93m\]"      # Yellow
	IBlue="\[\033[0;94m\]"        # Blue
	IPurple="\[\033[0;95m\]"      # Purple
	ICyan="\[\033[0;96m\]"        # Cyan
	IWhite="\[\033[0;97m\]"       # White

	# Bold High Intensty
	BIBlack="\[\033[1;90m\]"      # Black
	BIRed="\[\033[1;91m\]"        # Red
	BIGreen="\[\033[1;92m\]"      # Green
	BIYellow="\[\033[1;93m\]"     # Yellow
	BIBlue="\[\033[1;94m\]"       # Blue
	BIPurple="\[\033[1;95m\]"     # Purple
	BICyan="\[\033[1;96m\]"       # Cyan
	BIWhite="\[\033[1;97m\]"      # White

	# High Intensty backgrounds
	On_IBlack="\[\033[0;100m\]"   # Black
	On_IRed="\[\033[0;101m\]"     # Red
	On_IGreen="\[\033[0;102m\]"   # Green
	On_IYellow="\[\033[0;103m\]"  # Yellow
	On_IBlue="\[\033[0;104m\]"    # Blue
	On_IPurple="\[\033[10;95m\]"  # Purple
	On_ICyan="\[\033[0;106m\]"    # Cyan
	On_IWhite="\[\033[0;107m\]"   # White

	# Various variables you might want for your PS1 prompt instead
	Time12h="\T"
	Time12a="\@"
	PathShort="\w"
	PathFull="\W"
	NewLine="\n"
	Jobs="\j"


	# This PS1 snippet was adopted from code for MAC/BSD I saw from: http://allancraig.net/index.php?option=com_content&view=article&id=108:ps1-export-command-for-git&catid=45:general&Itemid=96
	# I tweaked it to work on UBUNTU 11.04 & 11.10 plus made it mo' better
	## <rstraight> And I tweaked it to make it even mo' better.

	NormalColor="$IBlue"
	CleanBranch="$White"
	DirtyBranch="$URed$BWhite"

	export PS1="\n$NormalColor«\D{%F %T}» $PathShort$Color_Off\n "'$( gitStatus=$( git status 2>/dev/null ) && [[ "$gitStatus" =~ "nothing to commit" ]] && echo "'$CleanBranch'$( __git_ps1 " [%s]" )" || echo "'$DirtyBranch'$( __git_ps1 " {%s}" )" ) '"$NormalColor\u@\h\$$Color_Off "

## 	export PS1="\n$IBlack«\D{%F %T}» $PathShort$Color_Off\n "'$(git branch &>/dev/null;\
## 	if [ $? -eq 0 ]; then \
## 	  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
## 	  if [ "$?" -eq "0" ]; then \
## 		# @4 - Clean repository - nothing to commit
## 		echo "'$White'"$(__git_ps1 " (%s)"); \
## 	  else \
## 		# @5 - Changes to working tree
## 		echo "'$UWhite$BWhite'"$(__git_ps1 " {%s}"); \
## 	  fi)"; \
## 	fi)'" $IBlack\u@\h\$$Color_Off "

##	export PS1="\n$IBlack«\D{%F %T}» $PathShort$Color_Off"'$(git branch &>/dev/null;\
##	if [ $? -eq 0 ]; then \
##	  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
##	  if [ "$?" -eq "0" ]; then \
##		# @4 - Clean repository - nothing to commit
##		echo "'$Green'"$(__git_ps1 " (%s)"); \
##	  else \
##		# @5 - Changes to working tree
##		echo "'$IRed'"$(__git_ps1 " {%s}"); \
##	  fi)"; \
##	fi)'"\n$IBlack \u@\h\$$Color_Off "

##	export PS1=$IBlack$Time12h$Color_Off'$(git branch &>/dev/null;\
##	if [ $? -eq 0 ]; then \
##	  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
##	  if [ "$?" -eq "0" ]; then \
##		# @4 - Clean repository - nothing to commit
##		echo "'$Green'"$(__git_ps1 " (%s)"); \
##	  else \
##		# @5 - Changes to working tree
##		echo "'$IRed'"$(__git_ps1 " {%s}"); \
##	  fi) '$BYellow$PathShort$Color_Off'\$ "; \
##	else \
##	  # @2 - Prompt when not in GIT repo
##	  echo " '$Yellow$PathShort$Color_Off'\$ "; \
##	fi)'
}

#   # Generates completion reply with compgen from newline-separated possible
#   # completion words by appending a space to all of them.
#   # It accepts 1 to 4 arguments:
#   # 1: List of possible completion words, separated by a single newline.
#   # 2: A prefix to be added to each possible completion word (optional).
#   # 3: Generate possible completion matches for this word (optional).
#   # 4: A suffix to be appended to each possible completion word instead of
#   #    the default space (optional).  If specified but empty, nothing is
#   #    appended.
#   __gitcomp_nl ()
#   {
#       local IFS=$'\n'
#       COMPREPLY=($(compgen -P "${2-}" -S "${4- }" -W "$1" -- "${3-$cur}"))
#   }

#   unset -f $__GITCOMP_WRAPPER_NAME ; function $__GITCOMP_WRAPPER_NAME {
#       # XXX __git_complete git-publish __git_main
#       # XXX __gitcomp_nl "$( __git_refs )" ;

#       COMPREPLY=($( git-branch -a | fgrep $cur 
#   } ;

#   __git_complete git-publish $__GITCOMP_WRAPPER_NAME ;

#   complete -W "$( git branch --no-color --list ${cur}* )" git-publish ;

# declare -x __GITCOMP_WRAPPER_NAME='__dot_bash_git_branch_comp' ;

unset -f __dot_bash_git_branch_comp ; function __dot_bash_git_branch_comp() {
    declare curr=${COMP_WORDS[COMP_CWORD]}
    declare prev=${COMP_WORDS[COMP_CWORD-1]}

    COMPREPLY=( $( git branch --no-color --all --list ${curr}* | sed -e 's/^*\?[[:space:]]\+//' ) ) ;

    return 0 ;
} ;

complete -F __dot_bash_git_branch_comp git-publish ;

touchLib ${BASH_SOURCE[0]} ; fi ;


