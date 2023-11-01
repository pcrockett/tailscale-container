## Tailscale Container

**Work in progress**

---

**UPDATE 2023-11-01:** The build is currently not working because of
[an upstream issue with Tailscale](https://github.com/tailscale/tailscale/issues/9902). It should
be a trivial problem to fix though. Even if Tailscale never gets around to it, it might be a good
idea to build my own container from scratch for reliability.

---

Use Podman / Docker to run a Tailscale exit node. There are several possible advantages to doing this:

* Run the Tailscale daemon as a non-admin user
* Run an exit node in a cloud-hosted container (i.e. Heroku, fly.io, etc.)
* Run without modifying any of the host's network settings (iptables, routes, etc.)
* Run multiple isolated instances of the Tailscale daemon for different people on the same device

The downsides:

* The container uses user-mode networking, so it may not be quite as fast
* It's really only good for using as an exit node, (or with a couple small modifications, a subnet router)

### Dependencies

* `make`
* [Podman](https://podman.io/) (however you can change the runtime to Docker by adjusting the
`CONTAINER_RUNTIME` variable at the top)

### Getting Started

1. Copy the `.env.example` file to `.env`
2. [Generate an auth key in your Tailscale account settings](https://login.tailscale.com/admin/settings/keys) (tip: don't make the key reusable or ephemeral)
3. Copy / paste that key into the `.env` file
4. Run `make build run init`
5. Go to Tailscale account settings, [find your device](https://login.tailscale.com/admin/machines), edit route settings, and turn on "Use as exit node"

From now on, you just need to do `make run` to start the container.

To update and restart a running Tailscale container: `make update restart`

### Running as a systemd service

_This only works if you're using Podman. If you're using Docker... pull requests welcome._

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

That should do it. Updating the container now should be the same as in the _Getting Started_ section, except instead of `make update
restart`, you should do `make update restart-service`.

### TODO

* [x] Get working on Raspberry Pi
* [x] Systemd service file plus `make install`
* [ ] Get working on fly.io
* [ ] Docker Compose?

### References

https://tailscale.com/blog/kubecon-21/

Based on the official [Tailscale image](https://hub.docker.com/r/tailscale/tailscale).
