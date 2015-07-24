## All this deprecated in favor of simple block in ~/.bash/agents using the `keychain' utility.
## rons @ 2014-08-12 09:31:44

unset -f __getSshDumpFile ;
function __getSshDumpFile() {
    local envDumpHome="$HOME/.bash/var" ;
    mkdir -p "$envDumpHome" ;

    local envDumpFile="${envDumpHome}/ssh-env.sh" ;
    echo "$envDumpFile" ;
}

unset -f __getSshEnvDump
function __getSshEnvDump() {
    export | grep 'SSH\|DISPLAY'
}


unset -f ssh-env-dump ;
function ssh-env-dump() {
    if [ "$STY" ] ; then
        return ; ## Not when in screen.
    fi

    local envDumpFile="$( __getSshDumpFile )" ;
    __getSshEnvDump > "$envDumpFile"
}

unset -f ssh-env-slurp ;
function ssh-env-slurp() {
    __getSshEnvDump | sed 's/^/OLD: /g;'

    local envDumpFile="$( __getSshDumpFile )" ;
    . "$envDumpFile" ;

    __getSshEnvDump | sed 's/^/NEW: /g;'
}


unset __ssh_agent_knows_key
function __ssh_agent_knows_key() {
	local keyFileName="$1" ;
	ssh-add -l 2>&1 | fgrep --silent "$keyFileName"
}

unset __process_ssh_discovery_result
function __process_ssh_discovery_result() {
	local originOfAgent="$1"
	local keyFileBaseName=""
	local keyFileFullName=""

	local sshAddOut="$( ssh-add -l 2>&1 )" ;
	local sshAddExit="$?"

	if [ "$sshAddExit" != "0" ] ; then 
		if [ "$sshAddOut" =~ 'contact' ] ; then
			echo "→ FAILED to contact $originOfAgent ssh-agent SSH_AGENT_PID=$SSH_AGENT_PID ; SSH_AUTH_SOCK=$SSH_AUTH_SOCK" 1>&2
			return 2
		fi
	fi

	local allPrivateKeyFiles="$( file $HOME/.ssh/* | fgrep 'private key' | fgrep -v RSA1 | cut -d: -f1 )" ;

	for keyFileFullName in $allPrivateKeyFiles ; do ## 'id_dsa-rons-on-adblade-laptop' 'id_dsa-straightre-at-adblade' ; do
		if [ ! -f "$keyFileFullName" ] ; then
			continue ;
		fi

		if ( __ssh_agent_knows_key "$keyFileFullName" ) ; then
			echo "→ OK $keyFileFullName" 1>&2
		else
			ssh-add "$keyFileFullName"
		fi
	done
}

unset -f ssh-agent-sync
function ssh-agent-sync() {
	if [ "$SSH_AGENT_PID" -a -r "$SSH_AUTH_SOCK" ] ; then
#			echo "- DEBUG ssh-agent: SSH_AGENT_PID=$SSH_AGENT_PID ; SSH_AUTH_SOCK=$SSH_AUTH_SOCK" 1>&2
		if ( pgrep ssh-agent | egrep --silent '\<'$SSH_AGENT_PID'\>' ) ; then
#			echo "→ OK ssh-agent: SSH_AGENT_PID=$SSH_AGENT_PID ; SSH_AUTH_SOCK=$SSH_AUTH_SOCK" 1>&2
			__process_ssh_discovery_result 'EXISTING'
			return 0
		fi
	fi

	local sshAgentPid="$( ps | awk '/ssh-agent/ { print $1 }' )"
	local sshAuthSock="$( ls -1trud /tmp/ssh-*/agent.* 2> /dev/null | tail -1 )"

	if [ "$sshAgentPid" -a -r "$sshAuthSock" ] ; then
		export SSH_AGENT_PID="$sshAgentPid"
		export SSH_AUTH_SOCK="$sshAuthSock"

#		echo "→ FOUND ssh-agent: SSH_AGENT_PID=$SSH_AGENT_PID ; SSH_AUTH_SOCK=$SSH_AUTH_SOCK" 1>&2
		__process_ssh_discovery_result 'FOUND'
		return 0
	fi

	eval $( ssh-agent ) > /dev/null
	__process_ssh_discovery_result 'CREATED'
}

unset -f __session_has_active_ssh_agent_with_keys
function __session_has_active_ssh_agent_with_keys() {
	local verbose="${DOT_BASH_VERBOSE}" ;

	ssh-add -l &> /dev/null
	local rv="$?"

	if [ "$rv" == 0 ] ; then
		[ "$verbose" ] && echo "→ Using keyed ssh-agent process from socket $SSH_AUTH_SOCK." 1>&2
		return 0
	elif [ "$rv" == 2 ] ; then
		return $rv
	fi

	if [ ! "$SSH_AGENT_PID" ] ; then
		if [ ! "$SSH_AUTH_SOCK" ] ; then
			[ "$verbose" ] && echo "→ An ssh-agent we thought existed does not." 1>&2
			return 0
		fi
		## Do we really *need* an SSH_AGENT_PID? Fairly easy to find from the socket on a Linux
		## box, but fairly hard on Cygwin.  :/
	fi

	[ "$verbose" ] && echo "→ Adding key(s) to ssh-agent process from $SSH_AUTH_SOCK." 1>&2

	ssh-agent-sync
}

unset -f ssh
function ssh() {
	if __session_has_active_ssh_agent_with_keys ; then
		command ssh $*
		return
	fi

	for sock_fn in $( find /tmp/ssh-* -name 'agent.*' -user "$USER" 2> /dev/null ) ; do
		export SSH_AUTH_SOCK="$sock_fn"

		if __session_has_active_ssh_agent_with_keys ; then
			break
		fi
	done

	command ssh $*
}

## vim: ft=sh
