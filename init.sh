#!/usr/bin/env sh

set -eu

/usr/local/bin/tailscale up \
    --advertise-exit-node \
    --authkey "${TAILSCALE_AUTH_KEY}" \
    --hostname "${TAILSCALE_HOSTNAME}"
