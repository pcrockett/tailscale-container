FROM docker.io/tailscale/tailscale:stable
COPY ./up.sh ./run.sh /usr/local/bin/
CMD ["/usr/local/bin/run.sh"]
