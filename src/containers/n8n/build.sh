#!/bin/bash
set -e

cp -f ../_shared/bootstrap-hosts.sh .
trap 'rm       ./bootstrap-hosts.sh' EXIT

MY_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$MY_DIR/../_shared/build-common.sh"

container build --no-cache --file Dockerfile        \
	--tag agent-n8n                                 \
	--target "$TARGET"                              \
	--build-arg AGENT_USER="$USER"                  \
	--build-arg AGENT_HOME="$HOME"                  \
	.
