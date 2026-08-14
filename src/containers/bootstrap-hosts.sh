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

exec setpriv --reuid=agent --regid=agent --init-groups env HOME=/home/agent USER=agent LOGNAME=agent "$@"
