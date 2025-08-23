FROM cgr.dev/chainguard/wolfi-base:latest

ENV XDG_DATA_HOME=/data
ENV XDG_CONFIG_HOME=/config
    
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /app

RUN apk add --no-cache caddy curl

COPY rootfs/ /
RUN chmod +x /usr/local/bin/*

HEALTHCHECK CMD curl -f http://localhost:2019/metrics || exit 1

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]