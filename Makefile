.PHONY: pull build run init stop update restart lint install uninstall
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
		--env-file "$(shell pwd)/.env" \
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

install:
	# Install the container as a non-root systemd service.
	#
	# Several assumptions here:
	#
	# * Container is currently running via `make run`
	# * We're currently logged in under a non-root user account
	# * CONTAINER_RUNTIME is "podman"
	#
	# Once installed, we will stop the currently running container
	# and restart it via systemd.
	#
	mkdir --parent ~/.config/systemd/user
	podman generate systemd --new --name "${CONTAINER_NAME}" \
		> ~/.config/systemd/user/container-tailscaled.service
	systemctl daemon-reload --user
	podman stop "${CONTAINER_NAME}"
	systemctl enable --user --now container-tailscaled.service

uninstall:
	# Undo the `install` target
	systemctl disable --user --now container-tailscaled.service
	rm -f ~/.config/systemd/user/container-tailscaled.service
	systemctl daemon-reload --user
