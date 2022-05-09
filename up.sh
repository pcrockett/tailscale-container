#!/usr/bin/env sh

set -eu

logged_in_file=/var/lib/tailscale/logged-in

if [ ! -f "${logged_in_file}" ]; then
    /usr/local/bin/tailscale up \
        --advertise-exit-node \
        --authkey "${TAILSCALE_AUTH_KEY}" \
        --hostname "${TAILSCALE_HOSTNAME}"
    touch "${logged_in_file}"
else
    /usr/local/bin/tailscale up --advertise-exit-node
fi
