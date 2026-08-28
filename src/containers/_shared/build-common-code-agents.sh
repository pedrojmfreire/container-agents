#!/bin/bash
set -e

# Default Dockerfile target to build
TARGET=playwright

MY_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$MY_DIR/build-common.sh"


cat Dockerfile ../_shared/playwright-Dockerfile-tail > Dockerfile.build
cp -f   ../_shared/bootstrap-hosts.sh ../_shared/playwright-cli-config.json .
trap 'rm         ./bootstrap-hosts.sh          ./playwright-cli-config.json ./Dockerfile.build' EXIT
