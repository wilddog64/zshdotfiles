# Progress — ~/.zsh dotfiles

## Recently Completed

- [x] Cline scan + `.clinerules` generated (2026-03-20) — layout, conventions, envrc pattern, security + agent rules captured
- [x] `memory-bank/activeContext.md` created (2026-03-20) — canonical structure + operating patterns documented
- [x] `scripts/claude-cleanup.sh` added (2026-03-20) — prunes `~/.claude` sessions + file-history older than 14 days; managed by launchd (`com.user.claude-cleanup`, runs daily at 3am, logs via `logger`)

## Pending

- [ ] Fix `.clinerules` inaccuracy — `direnvrc` listed in layout but removed (was Claude cleanup, superseded by launchd)
- [ ] Modernize scripts lacking `set -euo pipefail` — low priority, do when touching those files
- [ ] Review secret handling in local shell env files — migrate sensitive values to non-committed mechanisms
