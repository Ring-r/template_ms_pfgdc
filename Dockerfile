FROM continuumio/miniconda3 as build

COPY conda-linux-64.lock .
RUN \
	conda update -n base -c defaults conda && \
	conda create -p .venv --copy --file conda-linux-64.lock && \
	conda install -c conda-forge conda-pack && \
	conda-pack -p .venv -o /tmp/env.tar && \
	mkdir /venv && \
	cd /venv && \
	tar xf /tmp/env.tar && \
	rm /tmp/env.tar && \
	/venv/bin/conda-unpack


FROM debian:buster AS runtime

RUN \
	export DEBIAN_FRONTEND=nointeractive && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY --from=build /venv /venv

RUN useradd --create-home appuser
USER appuser
WORKDIR /home/appuser/

COPY --chown=appuser . .

SHELL ["/bin/bash", "-c"]

ENTRYPOINT source /venv/bin/activate && \
	gunicorn \
	--access-logfile=- \
	--bind=0.0.0.0:8000 \
	--threads=4 \
	--worker-class=gthread \
	--worker-tmp-dir=/dev/shm \
	--workers=2 \
	src.app:app
