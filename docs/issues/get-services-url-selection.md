# get-services URL selection issue

**Date:** 2026-06-18

`get-services` was only returning one URL per service directory in some cases because it selected the first `host:` match it found while scanning the directory. For charts that include a shared placeholder host in `values.yaml`, that placeholder was chosen instead of the environment-specific ingress host.

**Fix**

Updated `~/.zsh/scripts/get-services` to prefer `values-<service>.yaml` when present, and fall back to `values.yaml` only when needed.

**Result**

`marketing-search-batch` now returns the full set of environment URLs, and `cache-service` still returns the expected multi-region list.
