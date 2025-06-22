FROM cgr.dev/chainguard/wolfi-base:latest

ENV XDG_DATA_HOME=/data \
    XDG_CONFIG_HOME=/config

RUN mkdir -p /data /config
RUN adduser -u 82 www-data -D

COPY rootfs/ /
RUN chmod +x /usr/local/bin/*

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]