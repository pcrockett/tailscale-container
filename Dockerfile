FROM docker.io/golang:1.20-alpine3.17 as builder
# https://tailscale.com/kb/1118/custom-derp-servers/
RUN go install tailscale.com/cmd/derper@main

FROM docker.io/tailscale/tailscale:stable
COPY --from=builder /go/bin/derper /usr/local/bin/
COPY ./init.sh ./run.sh /usr/local/bin/
CMD ["/usr/local/bin/run.sh"]
