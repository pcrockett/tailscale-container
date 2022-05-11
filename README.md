## Tailscale Container

Use Podman / Docker to run a Tailscale exit node.

The advantage to using this container is that it doesn't require `CAP_NET_RAW`, `CAP_NET_ADMIN`, mounting
`/dev/net/tun`, or running in host networking mode with privileges.

The downside: The container uses user-mode networking, so it may not be quite as performant, and it's really only good
for using as an exit node or subnet router.

### Dependencies

The Makefile uses [podman](https://podman.io/), however you can change the runtime to Docker by adjusting the
`CONTAINER_RUNTIME` variable at the top.

### Getting Started

1. Copy the `.env.example` file to `.env`
2. Generate an auth key in your Tailscale account settings (recommended: don't make the key reusable or ephemeral)
3. Copy / paste that key into the `.env` file
4. Run `make build run up`
5. Once your container shows up in your Tailscale account device list, go into its route settings and confirm you want to allow it to be an exit node.

From now on, you just need to do `make run` to start the container.

To update and restart a running Tailscale container: `make update-restart`

### TODO

* [ ] Docker Compose
* [ ] Systemd service file plus `make install`
* [ ] Get working on Raspberry Pi

### References

https://tailscale.com/blog/kubecon-21/

Based on the official [Tailscale image](https://hub.docker.com/r/tailscale/tailscale).
