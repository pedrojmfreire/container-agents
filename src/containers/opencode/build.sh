#!/bin/bash
set -e

MY_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$MY_DIR/../_shared/build-common-code-agents.sh"

container build --no-cache --file Dockerfile.build  \
	--tag agent-opencode                            \
	--target "$TARGET"                              \
	--build-arg AGENT_USER="$USER"                  \
	--build-arg AGENT_HOME="$HOME"                  \
	.
