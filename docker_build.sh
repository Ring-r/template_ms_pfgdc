#!/bin/bash

set -euo pipefail

IMAGE_NAME=$( basename "$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(git rev-parse --short HEAD)

docker build \
	--label git-branch=$GIT_BRANCH \
	--label git-commit=$GIT_COMMIT \
	--tag "$IMAGE_NAME" \
	.
