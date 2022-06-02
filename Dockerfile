FROM docker.io/tailscale/tailscale:stable
COPY ./init.sh ./run.sh /usr/local/bin/
CMD ["/usr/local/bin/run.sh"]
