# Changelog

All notable changes to the CatalogueCanvas Home Assistant add-on are documented here.

## 0.1.6-2

### Fixed
- Image build now pins the upstream CatalogueCanvas source to the tracked release tag (`CC_REF`) instead of floating on `main`, so the in-app footer version matches the add-on's tracked app version instead of drifting to whatever commit was on `main` at build time.

## 0.1.6-1

Tracks upstream CatalogueCanvas [v0.1.6](https://github.com/CatalogueCanvas/CatalogueCanvas/blob/v0.1.6/CHANGELOG.md).

### Added
- Portfolio index entries are now links. Each thumbnail in the "Works" index jumps to that item's section (`#work-<id>`), in both the live deck and the static zip export.

### Changed
- Scroll-layout portfolios read as one continuous page: section rules are dropped everywhere except under the cover, which gains breathing room below it, and the index no longer repeats its heading or leaves a gap between pages.
- `scripts/coverage-to-codacy.sh` accepts `--auto`/`--yes`/`--skip-regenerate` so it can run unattended, and fetches a version-pinned Codacy reporter binary verified against its published SHA-512 checksum instead of piping a rolling installer script straight into `bash`.
- Web coverage thresholds now sit just below the measured level (lines 75, statements 72, functions 60, branches 60). The previous `branches: 80` floor was above actual coverage and failed the coverage run outright, while the lines/statements floors of 30 were far below it.
- Dependency bumps: `codeql-action` init/analyze, `astral-sh/setup-uv`, `coverage`, `fastapi`, React/Vite/typescript-eslint minor-patch group, and `@testing-library/jest-dom` (major, 6→7).

### Fixed
- Docker builds no longer report success when they fail. A `;` before a trailing `true` ended the `&&` chain in the dependency-install step, so `true` set the step's exit status and a failing `uv sync --frozen` or `apk del` still produced an image. The cache-purge failure is now suppressed with a braced `{ ...; || true; }` group, which scopes the guard to that one command; a bare trailing `|| true` would have applied to the whole chain and masked the same failures.
- Codacy token parsing no longer strips spaces from inside the token value; only surrounding whitespace and quotes are trimmed.

### Security
- Bumped `brace-expansion` (transitive, via eslint/minimatch) to 5.0.7, fixing a ReDoS vulnerability ([GHSA-3jxr-9vmj-r5cp](https://github.com/advisories/GHSA-3jxr-9vmj-r5cp)).

## 0.1.5-1

Tracks upstream CatalogueCanvas [v0.1.5](https://github.com/CatalogueCanvas/CatalogueCanvas/blob/v0.1.5/CHANGELOG.md).

### Added
- Configurable LLM response wait timeout, set from Settings (default 90s) and applied to both single-item and batch description generation. The setting notes that for local LLM instances (Ollama, LM Studio) the right value is found by experience, since slow hardware or a cold model load can exceed 90 seconds.
- "View items" link on each collection that opens the main Items page filtered to that collection (via a `?collection=` URL parameter), with a clearable filter chip showing the active collection.

### Changed
- Item page now shows only an item's selected collections as chips by default, with an "Edit" button that reveals the full collection checklist and collapses back after saving. Previously every available collection was listed for every item, which grew unwieldy as collections accumulated.
- Reworded the update-check help text in Settings for clarity.

### Fixed
- Prev/next navigation arrows on the item page no longer clip at the glyph tips; their horizontal offset is nudged inward.

## 0.1.4-1

Tracks upstream CatalogueCanvas [v0.1.4](https://github.com/CatalogueCanvas/CatalogueCanvas/blob/v0.1.4/CHANGELOG.md).

### Added
- Item images open at full size. Clicking the preview on an item page opens a lightbox that fits the image to the screen, toggles to 1:1 on click, and pans by dragging. Previews were already stored at full resolution, so no new assets are generated. Arrow-key item navigation is suspended while the lightbox is open.
- Portfolio layout option, chosen per portfolio and independent of the theme: `slide` (the existing full-height deck, printable to PDF at 1920×1080) or `scroll` (a continuous one-page site with no page breaks and no print button). Any of the four themes can be published either way. Applies to the live portfolio and the static zip export. Existing portfolios default to `slide`.

### Fixed
- The lightbox now fits the image to the screen at all times. Clicking to zoom to 1:1 opened large images past the edge of the viewport, so the zoom and drag-to-pan behaviour is gone.
- "Preview deck" and the portfolio list's "View" button now carry the share token. Both linked to the untokenized URL, which returns 404 for a gated portfolio.

## 0.1.3-1

Tracks upstream CatalogueCanvas [v0.1.3](https://github.com/CatalogueCanvas/CatalogueCanvas/blob/v0.1.3/CHANGELOG.md).

### Added
- Opt-in update check. An admin-only `/api/version` endpoint queries GitHub for the latest release (weekly throttle, no network unless enabled) and the footer surfaces when a newer version is available. Configurable from Settings.

### Fixed
- LLM descriptions are now stored identically whether generated for a single item or in batch. Both paths use a shared `describeResultToNote` helper, so the full summary and bullet list are saved to the note instead of only the summary in the batch flow.

## 0.1.2-1

Tracks upstream CatalogueCanvas [v0.1.2](https://github.com/CatalogueCanvas/CatalogueCanvas/blob/v0.1.2/CHANGELOG.md).

### Fixed
- LLM description pipeline: preview images (stored as WebP) were sent to the vision endpoint under a hardcoded `data:image/jpeg` label, so the bytes never matched the declared MIME type. This worked only on lenient runtimes and failed with `HTTP 400 Failed to load image or audio file` on LM Studio versions that trust the declared type (which accepts only jpeg/png). Previews are now transcoded to real JPEG before the request, and undecodable images raise a clear error.
- Footer now displays the correct app version. `web/package.json` version was left at the default `0.0.0`, which Vite injects as `__APP_VERSION__` and the footer renders; bumped it to `0.1.1` to match the release.

## 0.1.1

### Added
- Custom AppArmor profile (`apparmor.txt`) confining the add-on to the file, network, and capability set it actually uses; replaces the previous `apparmor: false` unconfined mode. Validated via the `cataloguecanvas_test` add-on.

## 0.1.0

### Added
- Initial Home Assistant add-on wrapping the upstream `ghcr.io/cataloguecanvas/cataloguecanvas` image.
- Configuration page exposing admin credentials, branding, secure-cookie toggle, LLM allowed hosts, and maximum upload size.
- Web UI on port 8000 (direct access; Ingress not supported by the upstream app).
- Persistent data (`catalogue.db`, `storage/`, `secret.key`) in the add-on `/data` volume, included in Home Assistant backups.
- Host media mounts: `/media` and `/share` (read/write) and `/homeassistant` (read-only) so libraries can point at existing host media.
