#!/bin/bash
set -e

if [ -n "$TARGET" ]
then
	if [ ".$1" == ".-h" ]  ||  [ ".$1" == ".--help" ]
	then
		echo "Usage: build.sh [-b|-h|--base|--help]"
		echo
		echo "-b, --base  Build the base image, rather than the default Playwright-compatible image which adds 900Mb."
		echo "-h, --help  This help."
		exit 0
	fi

	if [ ".$1" == ".-b" ]  ||  [ ".$1" == ".--base" ]
	then
		TARGET=base
	fi
fi

if ! container system status &>/dev/null
then
  container system start
fi

# container system property set build.rosetta false
if [ ! -f ~/.config/container/config.toml ]
then
	mkdir -p ~/.config/container
	cat >> ~/.config/container/config.toml << 'EOF'
[build]
rosetta = false
[dns]
domain = "container"
EOF
	container system stop
	container system start
fi
