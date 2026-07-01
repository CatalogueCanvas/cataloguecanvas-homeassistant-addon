ARG BUILD_FROM
FROM ${BUILD_FROM}

# Wrap the upstream CatalogueCanvas image so Home Assistant can inject its
# options. The upstream base (python:3.14-alpine) has no bashio, so run.sh
# reads /data/options.json with the Python interpreter already in the image.
#
# Run as root (the Home Assistant add-on default): the Supervisor owns /data
# and mounts add-on volumes root-owned, so the upstream appuser (uid 1000)
# cannot read /data/options.json nor write the session key. run.sh redirects
# the app's persistent data to the add-on config volume via CC_DATA_DIR.
USER root
COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /app/server
ENTRYPOINT []
CMD ["/run.sh"]
