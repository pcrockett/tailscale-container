IMAGE_NAME = tailscale-exit
CONTAINER_NAME = tailscaled
CONTAINER_RUNTIME = podman
VOLUME_NAME = tailscaled-state
SERVICE_NAME = container-tailscaled

pull:
	"${CONTAINER_RUNTIME}" pull docker.io/tailscale/tailscale:stable
.PHONY: pull

build:
	"${CONTAINER_RUNTIME}" build --tag "${IMAGE_NAME}" .
.PHONY: build

run: build
	"${CONTAINER_RUNTIME}" run --rm --detach \
		--env-file "$(shell pwd)/.env" \
		--name "${CONTAINER_NAME}" \
		--volume "${VOLUME_NAME}:/var/lib/tailscale" \
		"${IMAGE_NAME}"
.PHONY: run

init:
	"${CONTAINER_RUNTIME}" exec "${CONTAINER_NAME}" init.sh
.PHONY: init

stop:
	"${CONTAINER_RUNTIME}" stop "${CONTAINER_NAME}"
.PHONY: stop

status:
	"${CONTAINER_RUNTIME}" exec "${CONTAINER_NAME}" /usr/local/bin/tailscale status
.PHONY: status

update: pull build
.PHONY: update

restart: stop run
.PHONY: restart

restart-service:
	# Assumption: You have already run `make install` successfully
	systemctl restart --user "${SERVICE_NAME}.service"
.PHONY: restart-service

lint:
	hadolint Dockerfile
	shellcheck *.sh
.PHONY: lint

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
		> "${HOME}/.config/systemd/user/${SERVICE_NAME}.service"
	systemctl daemon-reload --user
	podman stop "${CONTAINER_NAME}"
	systemctl enable --user --now "${SERVICE_NAME}.service"
.PHONY: install

uninstall:
	# Undo the `install` target
	systemctl disable --user --now "${SERVICE_NAME}.service"
	rm -f "${HOME}/.config/systemd/user/${SERVICE_NAME}.service"
	systemctl daemon-reload --user
.PHONY: uninstall
