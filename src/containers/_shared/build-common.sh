#!/bin/bash
set -e

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
else
	TARGET=playwright
fi

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

cat Dockerfile ../_shared/playwright-Dockerfile-tail > Dockerfile.build
cp -f   ../_shared/bootstrap-hosts.sh ../_shared/playwright-cli-config.json .
trap 'rm         ./bootstrap-hosts.sh          ./playwright-cli-config.json ./Dockerfile.build' EXIT
