#!/bin/bash
set -e

if ! container system status &>/dev/null
then
  container system start
fi

# container system property set build.rosetta false
if [ ! -f ~/.config/container/config.toml ]
then
	echo "Run parent 'build-all.sh' to create '~/.config/container/config.toml'."
	exit 0
fi

cp -f ../bootstrap-hosts.sh .

container build --no-cache -t agent-opencode .

rm ./bootstrap-hosts.sh
