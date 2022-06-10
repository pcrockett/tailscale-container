## Tailscale Container

**Work in progress**

Use Podman / Docker to run a Tailscale exit node. Run multiple instances for different people, run it in a container in
the cloud, etc.

The advantage to using this container is that it doesn't require `CAP_NET_RAW`, `CAP_NET_ADMIN`, mounting
`/dev/net/tun`, or running in host networking mode with privileges.

The downside: The container uses user-mode networking, so it may not be quite as fast, and it's really only good for
using as an exit node or subnet router.

### Dependencies

The Makefile uses [Podman](https://podman.io/), however you can change the runtime to Docker by adjusting the
`CONTAINER_RUNTIME` variable at the top.

### Getting Started

1. Copy the `.env.example` file to `.env`
2. [Generate an auth key in your Tailscale account settings](https://login.tailscale.com/admin/settings/keys) (tip: don't make the key reusable or ephemeral)
3. Copy / paste that key into the `.env` file
4. Run `make build run init`
5. Go to Tailscale account settings, [find your device](https://login.tailscale.com/admin/machines), edit route settings, and turn on "Use as exit node"

From now on, you just need to do `make run` to start the container.

To update and restart a running Tailscale container: `make update restart`

### Running as a systemd service

If you want the container to:

* start running automatically when your machine has booted
* run under an unprivileged user account
* automatically restart if it crashes for some reason

...then that's not too hard.

1. Log into your machine as the unprivileged user.
2. Get your container set up as in the [Getting Started](#getting-started) section.
3. While the container is running, do `make install`.

You will also need to enable lingering for the user account that the container is running under. As root, run:

```bash
loginctl enable-linger ${YOUR_UNPRIVILEGED_USERNAME}
```

That should do it.

_This only works if you're using Podman. If you're using Docker... pull requests welcome._

### TODO

* [x] Get working on Raspberry Pi
* [x] Systemd service file plus `make install`
* [ ] Get working on fly.io
* [ ] Docker Compose?

### References

https://tailscale.com/blog/kubecon-21/

Based on the official [Tailscale image](https://hub.docker.com/r/tailscale/tailscale).
