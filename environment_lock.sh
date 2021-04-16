#!/bin/bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

docker run \
	--entrypoint=bash \
	--rm \
	-v "$DIR/environment.yml":/environment.yml \
	-v "$DIR/conda-linux-64.lock":/conda-linux-64.lock \
	continuumio/miniconda3 -c "conda install -c conda-forge conda-lock && conda-lock -f environment.yml -p linux-64"
