# Local Scripts

Place cross-platform helper scripts in this directory and let the helper sync them into your PATH.

## Usage

Run `~/.zsh/scripts/sync-local-bin` to recreate symlinks inside `~/.local/bin`. The script:

- Creates `~/.local/bin` if it does not exist (override with `LOCAL_BIN_DIR=/custom/path`).
- Links every executable in `~/.zsh/scripts/` (including `sync-local-bin` itself) into the target directory.
- Removes stale links that previously pointed at `~/.zsh/scripts/` but no longer exist.

Keep Windows-only wrappers in `office/win/` (symlink that folder to `~/bin`). This split keeps office tooling optional while letting the shared repo host portable utilities.
