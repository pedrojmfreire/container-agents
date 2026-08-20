#!/bin/bash
set -e


# In these host directories, AI agents run with no restrictions
DEV_ENV_PROJECT_DIRS=(
	"$HOME/Documents/Software"
)


# Base directory for container settings
# Note: This should be an absolute path! Replace before running!
DEV_ENV_CONTAINERS_DIR="./src/containers"


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


# Base directory for user-level AI skills
# BETA: this shares only the directory, doesn't change the format
# Set to empty to disable this feature
DEV_ENV_AI_SKILLS_DIR=
	# Disabled
	# Good starting point to enable: "$HOME/.agents/skills"
