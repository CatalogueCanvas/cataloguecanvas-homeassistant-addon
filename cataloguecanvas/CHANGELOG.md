# Changelog

All notable changes to the CatalogueCanvas Home Assistant add-on are documented here.

## 0.1.0

### Added
- Initial Home Assistant add-on wrapping the upstream `ghcr.io/cataloguecanvas/cataloguecanvas` image.
- Configuration page exposing admin credentials, branding, secure-cookie toggle, LLM allowed hosts, and maximum upload size.
- Web UI on port 8000 (direct access; Ingress not supported by the upstream app).
- Persistent data (`catalogue.db`, `storage/`, `secret.key`) in the add-on `/data` volume, included in Home Assistant backups.
- Host media mounts: `/media` and `/share` (read/write) and `/homeassistant` (read-only) so libraries can point at existing host media.
