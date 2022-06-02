.PHONY: pull build run init stop update restart lint
IMAGE_NAME = tailscale-exit
CONTAINER_NAME = tailscaled
CONTAINER_RUNTIME = podman
VOLUME_NAME = tailscaled-state

pull:
	"${CONTAINER_RUNTIME}" pull docker.io/tailscale/tailscale:stable

build:
	"${CONTAINER_RUNTIME}" build --tag "${IMAGE_NAME}" .

run:
	"${CONTAINER_RUNTIME}" run --rm --detach \
		--env-file .env \
		--name "${CONTAINER_NAME}" \
		--volume "${VOLUME_NAME}:/var/lib/tailscale" \
		"${IMAGE_NAME}"

init:
	"${CONTAINER_RUNTIME}" exec "${CONTAINER_NAME}" init.sh

stop:
	"${CONTAINER_RUNTIME}" stop "${CONTAINER_NAME}"

update: pull build

restart: stop run

lint:
	hadolint Dockerfile
