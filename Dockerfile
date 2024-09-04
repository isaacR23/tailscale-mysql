FROM debian:latest

# Install necessary packages
RUN apt-get update \
    && apt-get install -y mariadb-server ca-certificates iptables \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Copy the startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Run on container startup.
ENTRYPOINT ["/app/start.sh"]