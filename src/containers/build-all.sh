#!/bin/bash
set -e

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
EOF
	container system stop
	container system start
fi


for d in ./*/
do
	if [ -f "$d/build.sh" ]  &&  [ -f "$d/Dockerfile" ]  &&  [ ! -f "$d/DO-NOT-BUILD" ]
	then
		( cd "$d"  &&  bash build.sh )
	fi
done
