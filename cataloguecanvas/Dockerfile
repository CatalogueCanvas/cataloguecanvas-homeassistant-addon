ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG S6_OVERLAY_VERSION=3.2.0.2

# s6-overlay supervision wrapper; runs as root since Supervisor mounts /data root-owned.
USER root

# hadolint ignore=DL3008,DL3018
RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
      apk add --no-cache bash coreutils jq openssl ca-certificates xz curl; \
    elif command -v apt-get >/dev/null 2>&1; then \
      apt-get update; \
      apt-get install -y --no-install-recommends bash coreutils jq openssl ca-certificates xz-utils curl; \
      rm -rf /var/lib/apt/lists/*; \
    else \
      echo "Unsupported base image: missing apk/apt-get"; \
      exit 1; \
    fi

# Install s6-overlay, mapping BUILD_ARCH to the s6-overlay release architecture.
RUN set -eux; \
    case "${BUILD_ARCH}" in \
      amd64) S6_ARCH="x86_64" ;; \
      aarch64) S6_ARCH="aarch64" ;; \
      *) echo "Unsupported BUILD_ARCH for s6-overlay: ${BUILD_ARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/s6-overlay-noarch.tar.xz \
      "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz"; \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz; \
    curl -fsSL -o /tmp/s6-overlay-arch.tar.xz \
      "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz"; \
    tar -C / -Jxpf /tmp/s6-overlay-arch.tar.xz; \
    rm -f /tmp/s6-overlay-noarch.tar.xz /tmp/s6-overlay-arch.tar.xz; \
    ln -s /command/with-contenv /usr/bin/with-contenv

COPY run.sh /run.sh
COPY rootfs /

RUN chmod +x /run.sh \
    && chmod +x /etc/s6-overlay/s6-rc.d/cataloguecanvas/run \
    && chmod +x /etc/s6-overlay/s6-rc.d/cataloguecanvas/finish

WORKDIR /app/server

# USER must be last so it wins over the upstream base image's `USER appuser`.
USER root
ENTRYPOINT ["/init"]
CMD []
