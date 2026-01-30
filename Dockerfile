FROM cgr.dev/chainguard/wolfi-base:latest

ENV XDG_DATA_HOME=/data
ENV XDG_CONFIG_HOME=/config
    
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /app

COPY rootfs/ /
RUN chmod +x /usr/local/bin/*
RUN add-glimmer-labs-repo

RUN apk add --no-cache caddy

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]