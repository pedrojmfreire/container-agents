#!/bin/bash
set -e


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


# Run the actual default command (CMD)
# ===========================================================================

home_dir=""

for dir in /Users/*/ /home/*/
do
	[[ "$dir" == "/home/root/" ]]  &&  continue
	home_dir="${dir%/}"
	break
done

AGENT_HOME="${home_dir:-/home/agent}"
AGENT_USER="${AGENT_HOME##*/}"

exec setpriv               \
	--reuid="$AGENT_USER"  \
	--regid="$AGENT_USER"  \
	--init-groups          \
	env                    \
	HOME="$AGENT_HOME"     \
	USER="$AGENT_USER"     \
	LOGNAME="$AGENT_USER"  \
	"$@"
