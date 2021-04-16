#!/bin/bash

set -euo pipefail

IMAGE_NAME=$( basename "$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")

docker run -p 8000:8000 --rm $IMAGE_NAME
