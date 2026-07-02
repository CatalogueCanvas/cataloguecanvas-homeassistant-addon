# CatalogueCanvas Home Assistant Add-on

![CatalogueCanvas](logo.png)

[![GitHub Release](https://img.shields.io/github/v/release/CatalogueCanvas/cataloguecanvas-homeassistant-addon)](https://github.com/CatalogueCanvas/cataloguecanvas-homeassistant-addon/releases)
[![License](https://img.shields.io/github/license/CatalogueCanvas/cataloguecanvas-homeassistant-addon)](LICENSE)
[![GitHub Issues](https://img.shields.io/github/issues/CatalogueCanvas/cataloguecanvas-homeassistant-addon)](https://github.com/CatalogueCanvas/cataloguecanvas-homeassistant-addon/issues)

A Home Assistant add-on that runs [CatalogueCanvas](https://github.com/CatalogueCanvas/CatalogueCanvas), a self-hosted manager for your creative files (artwork, generative code, design assets) organised into catalogues and portfolios.


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
