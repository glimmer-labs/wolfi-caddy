FROM cgr.dev/chainguard/wolfi-base:latest

RUN mkdir -p /data /config

ENV XDG_DATA_HOME=/data \
    XDG_CONFIG_HOME=/config
    
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

COPY rootfs/ /
RUN chmod +x /usr/local/bin/*

RUN apk add --no-cache caddy

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]