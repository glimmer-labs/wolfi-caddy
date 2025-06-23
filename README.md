# Wolfi Caddy

A Docker image based on Wolfi Linux with a script for installing/building Caddy web server with modules easily.

```dockerfile
FROM ghcr.io/laravel-glimmer/wolfi-caddy:latest
```

## Overview

This Docker image provides a lightweight and secure enviroment for executing Caddy web server. It's based on the Wolfi Linux (un)distribution, which is designed specifically for containers.

The image includes a script for easily install Caddy with additional modules quickly as possible, it uses add-package by default to get Caddy with the defined modules.

## Features

- Based on Wolfi Linux (cgr.dev/chainguard/wolfi-base)
- Script for installing Caddy with modules quickly
- Uses `add-package` by default to install Caddy, if it fails it tries with the `download API` directly, if that fails too, it builds Caddy from source using `xcaddy`
- Data and Config dirs default to `/data` and `/config` respectively, making it easier to use with volumes
- Sets default CMD to run caddy using `/etc/caddy/Caddyfile` with `caddyfile` as adapter

## Available script

### dxcaddy

This script is used to install Caddy with additional modules. You can specify the modules you want to include in the Caddy installation. If no modules are specified, it will install/build the default Caddy.

```bash
dxcaddy install <module1> <module2> ...
```

> Modules must be specified in the format `<page>.com/<repository>/<module>`, which is the same format used by `xcaddy`.

## Common Use Cases

### Install Caddy with modules (Multi-stage build)

```dockerfile
FROM ghcr.io/laravel-glimmer/wolfi-caddy:latest as caddy

# Install Caddy with the geoip2 module example
RUN dxcaddy github.com/zhangjiayin/caddy-geoip2

FROM ghcr.io/laravel-glimmer/wolfi-caddy:latest

# Copy the Caddy binary from the previous stage
COPY --link --from=caddy /usr/bin/caddy /usr/bin/caddy

# Run Caddy with a simple Caddyfile (this is the default CMD, here we are overriding it)
ENTRYPOINT ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
```