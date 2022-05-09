#!/usr/bin/env sh

set -eu

/usr/local/bin/tailscaled -tun=userspace-networking
