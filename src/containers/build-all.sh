#!/bin/bash
set -e

for d in ./*/
do
	if [ -f "$d/build.sh" ]  &&  [ -f "$d/Dockerfile" ]  &&  [ ! -f "$d/DO-NOT-BUILD" ]
	then
		( cd "$d"  &&  bash build.sh "$@" )
	fi
done
