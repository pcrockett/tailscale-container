.PHONY: pull build run up stop update-restart lint
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

up:
	"${CONTAINER_RUNTIME}" exec "${CONTAINER_NAME}" up.sh

stop:
	"${CONTAINER_RUNTIME}" stop "${CONTAINER_NAME}"

update-restart: pull build stop run

lint:
	hadolint Dockerfile
