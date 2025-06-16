FROM cgr.dev/chainguard/wolfi-base:latest

RUN adduser -u 82 www-data -D

COPY rootfs/ /
RUN chmod +x /usr/local/bin/*
