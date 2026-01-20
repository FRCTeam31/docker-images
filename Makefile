DOCKER_USER?=frcteam31

.PHONY: usage update build push build/base build/shrunner push/base push/shrunner

usage:
	@echo "Run make update, make build, and make push"

update:
	docker pull docker.io/ubuntu:24.04

build: build/base build/shrunner

build/base:
	cd roborio-cross-ubuntu && \
		docker build -t ${DOCKER_USER}/roborio-cross-ubuntu:2026 -f Dockerfile.2026 .

build/shrunner: build/base
	cd roborio-cross-ubuntu-shrunner && \
		docker build -t ${DOCKER_USER}/roborio-cross-ubuntu-shrunner:2026 -f Dockerfile.2026 .

push: push/base push/shrunner

push/base:
	docker push ${DOCKER_USER}/roborio-cross-ubuntu:2026

push/shrunner:
	docker push ${DOCKER_USER}/roborio-cross-ubuntu-shrunner:2026
