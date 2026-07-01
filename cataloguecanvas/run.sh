#!/bin/sh
# Home Assistant passes add-on options as JSON at /data/options.json. Translate
# them into the CC_* environment variables the upstream image expects, then hand
# off to the upstream entrypoint (which generates the session key under
# CC_DATA_DIR) and CMD. python is present in the image, so no extra deps needed.
set -e

OPTIONS_FILE="${OPTIONS_FILE:-/data/options.json}"

# Persist the app's data (session key, DB, etc.) on the add-on config volume
# rather than /data. The Supervisor mounts /data root-owned and treats it as
# ephemeral option storage; /config (the addon_config map) is the writable,
# backed-up location for add-on state. CC_DATA_DIR steers the upstream
# entrypoint's `mkdir` + secret.key generation there. The upstream image bakes
# CC_DATA_DIR=/data into its ENV, so this override is unconditional (a `:-`
# default would never fire) — but still lets an explicit override win.
CC_DATA_DIR="${CC_DATA_DIR_OVERRIDE:-/config}"
mkdir -p "$CC_DATA_DIR"
export CC_DATA_DIR

# Fail loud if HA's options file is unreadable — silently swallowing the error
# would hide misconfiguration and leave the app running with empty defaults.
if [ ! -r "$OPTIONS_FILE" ]; then
    echo "[cataloguecanvas] ERROR: cannot read options at $OPTIONS_FILE." \
         "The add-on must run as root so it can read the Supervisor's" \
         "root-owned options file." >&2
    exit 1
fi

# Emit `export KEY=value` lines for each option, safely quoted. A malformed
# file is fatal; missing keys fall back to empty, letting the app apply its
# own defaults. Capture into a variable first: a `python` failure inside a
# command substitution does not reliably abort under `set -e`, so check its
# status explicitly before eval'ing the output.
if ! exports="$(python - "$OPTIONS_FILE" <<'PY'
import json, shlex, sys

path = sys.argv[1]
try:
    with open(path) as fh:
        opts = json.load(fh)
except ValueError:
    sys.stderr.write(f"[cataloguecanvas] ERROR: {path} is not valid JSON\n")
    sys.exit(1)

mapping = {
    "admin_password": "CC_ADMIN_PASSWORD",
    "admin_username": "CC_ADMIN_USERNAME",
    "site_title": "CC_SITE_TITLE",
    "site_author": "CC_SITE_AUTHOR",
    "cookie_secure": "CC_COOKIE_SECURE",
    "llm_allowed_hosts": "CC_LLM_ALLOWED_HOSTS",
    "max_upload_bytes": "CC_MAX_UPLOAD_BYTES",
}

for opt_key, env_key in mapping.items():
    if opt_key not in opts:
        continue
    value = opts[opt_key]
    if isinstance(value, bool):
        value = "true" if value else "false"
    else:
        value = str(value)
    print(f"export {env_key}={shlex.quote(value)}")
PY
)"; then
    exit 1
fi
eval "$exports"

if [ -z "${CC_ADMIN_PASSWORD:-}" ]; then
    echo "[cataloguecanvas] WARNING: admin_password is empty; the app fails closed" \
         "(no admin login) until you set it in the add-on configuration." >&2
fi

exec /usr/local/bin/docker-entrypoint.sh \
    uv run uvicorn cataloguecanvas.main:app --host 0.0.0.0 --port 8000
