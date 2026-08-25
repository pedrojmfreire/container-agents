#!/bin/bash
set -e

# Author:  Pedro Freire  http://www.pedrofreire.com
# License: Apache 2.0    https://www.apache.org/licenses/LICENSE-2.0.txt


# User-defined script configuration
# ===========================================================================

HOST_DNS_ALIAS=host.container.internal


# Parse the hosts to append to /etc/hosts
# ===========================================================================

if [ -f /etc/host-aliases.txt ]
then
	HOST_IP_ALIAS=$(getent hosts $HOST_DNS_ALIAS | awk '{print $1}' | head -n1)

	if [ -n "$HOST_IP_ALIAS" ]
	then
		while read -r name; do
			[ -z "$name" ] && continue
			sed -i "/[[:space:]]${name//./\\.}\$/d" /etc/hosts
			echo "$HOST_IP_ALIAS  $name" >> /etc/hosts
		done < /etc/host-aliases.txt
	fi
fi


# Determine AGENT_HOME and AGENT_USER
# ===========================================================================

home_dir=""

for dir in /Users/*/ /home/*/
do
	[ -d "$dir" ]  ||  continue
	[[ "$dir" == "/home/root/" ]]  &&  continue
	home_dir="${dir%/}"
	break
done

AGENT_HOME="${home_dir:-/home/agent}"
AGENT_USER="${AGENT_HOME##*/}"


# Scan all skills shells and add executable bit
# ===========================================================================

for skills_dir in                          \
    "$AGENT_HOME/.codex/skills"            \
    "$AGENT_HOME/.claude/skills"           \
    "$AGENT_HOME/.gemini/skills"           \
    "$AGENT_HOME/.vibe/skills/"            \
    "$AGENT_HOME/.config/opencode/skills"  \
    "$AGENT_HOME/.agents/skills"
do
    [ -d "$dir" ]  ||  continue

    for scripts_dir in "$skills_dir"/*/scripts
    do
		[ -d "$scripts_dir" ] || continue

		find "$scripts_dir" -type f ! -executable -exec sh -c '
			for file do
				IFS= read -r firstline < "$file" || continue
				case "$firstline" in
					"#!"*) chmod +x "$file" ;;
				esac
			done
		' sh {} +
	done
done


# Run the actual default command (CMD)
# ===========================================================================

exec setpriv               \
	--reuid="$AGENT_USER"  \
	--regid="$AGENT_USER"  \
	--init-groups          \
	env                    \
	HOME="$AGENT_HOME"     \
	USER="$AGENT_USER"     \
	LOGNAME="$AGENT_USER"  \
	"$@"
