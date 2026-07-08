# CatalogueCanvas Home Assistant Add-on

<img src="cataloguecanvas/logo.png" align="right" width=150/>

[![GitHub Release](https://img.shields.io/github/v/release/CatalogueCanvas/cataloguecanvas-homeassistant-addon)](https://github.com/CatalogueCanvas/cataloguecanvas-homeassistant-addon/releases)
[![License](https://img.shields.io/github/license/CatalogueCanvas/cataloguecanvas-homeassistant-addon)](LICENSE)
[![GitHub Issues](https://img.shields.io/github/issues/CatalogueCanvas/cataloguecanvas-homeassistant-addon)](https://github.com/CatalogueCanvas/cataloguecanvas-homeassistant-addon/issues)

A Home Assistant add-on that runs [CatalogueCanvas](https://github.com/CatalogueCanvas/CatalogueCanvas), a self-hosted manager for your creative files (artwork, generative code, design assets) organised into catalogues and portfolios.

## Versioning

The add-on version follows `<app_version>-<n>`, where `<app_version>` is the
[CatalogueCanvas](https://github.com/CatalogueCanvas/CatalogueCanvas) release
it wraps, and `<n>` is a build counter for this add-on:

```
app v0.1.0 released   -> add-on version: 0.1.0-1
add-on-only fix later -> add-on version: 0.1.0-2
app v0.1.1 released   -> add-on version: 0.1.1-1
```

A new app release always resets `<n>` back to `1`. Bumping `<n>` on its own
(same app version) is for add-on-only changes — Dockerfile, s6-overlay,
AppArmor, or config schema updates with no change to the underlying app.

## Add this repository to Home Assistant

[![Add to Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FCatalogueCanvas%2Fcataloguecanvas-homeassistant-addon)

## Manual procedure

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Open the ⋮ menu (top right) and pick **Repositories**.
3. Paste this repository's URL and click **Add**:

   ```
   https://github.com/CatalogueCanvas/cataloguecanvas-homeassistant-addon
   ```

4. Close the dialog. **CatalogueCanvas** now shows up in the store.
5. Install it, set an admin password on the Configuration tab, and start it.

Once it's running, open `http://<your-ha-host>:8000` and log in.

The full setup and configuration notes are in [`cataloguecanvas/DOCS.md`](cataloguecanvas/DOCS.md).
