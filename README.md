# Dockerised ioquake3 server

This repo is set up to automate creating multi-arch Docker images (armv6, armv7, arm64, amd64) for
an [ioquake3](https://github.com/ioquake3/ioq3) server. This is based on
https://www.github.com/jberrenberg/docker-quake3 with a custom wrapper script to run the server with
some default setup and configuration options to make it more usable in e.g. Kubernetes environments.

The finished images are available as 
[florianpiesche/ioquake3-server](https://hub.docker.com/r/florianpiesche/ioquake3-server) and
[ghcr.io/fpiesche/ioquake3-server](https://ghcr.io/fpiesche/ioquake3-server) respectively and
tagged with the commit in the ioquake3 repository they were built from.
