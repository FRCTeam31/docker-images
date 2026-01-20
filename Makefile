DOCKER_USER?=FRCTeam31

.PHONY: usage update build push

usage:
	@echo "Run make update, make build, and make push"

update:
	docker pull docker.io/ubuntu:24.04

build:
	cd roborio-cross-ubuntu-shrunner && \
		docker build -t ${DOCKER_USER}/roborio-cross-ubuntu-shrunner:2026 -f Dockerfile.2026 .

push:
	docker push ${DOCKER_USER}/roborio-cross-ubuntu-shrunner:2026
