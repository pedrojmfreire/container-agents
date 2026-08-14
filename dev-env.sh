#!/bin/bash
set -e


# In these host directories, AI agents run with no restrictions
DEV_ENV_PROJECTS=(
	"$HOME/Documents/Software"
)


DEV_ENV_LOCALHOST_DNS_ALIAS=host.container.internal
DEV_ENV_LOCALHOST_IP_ALIAS=203.0.113.113
# https://github.com/apple/container/blob/main/docs/host-integration.md#access-a-host-service-from-a-container
# https://github.com/apple/container/blob/main/docs/command-reference.md#container-system-dns-create


DEV_ENV_VM_USER=user
DEV_ENV_VM_HOST=vm.local
DEV_ENV_VM_PORTS=(
	22    # SSH / SFTP
	80    # HTTP
	443   # HTTPS
)
