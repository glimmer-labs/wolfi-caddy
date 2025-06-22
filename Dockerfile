FROM cgr.dev/chainguard/wolfi-base:latest

ENV CADDY_DATA_DIR=/data \
    CADDY_CONFIG_DIR=/config

RUN mkdir -p /data /config
RUN adduser -u 82 www-data -D

COPY rootfs/ /
RUN chmod +x /usr/local/bin/*
