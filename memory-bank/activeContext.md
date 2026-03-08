# Active Context — ~/.zsh dotfiles

## Current Focus (as of 2026-03-08)

Setting up `envrc/` directory to manage per-project direnv configs centrally.
Goal: replace ad-hoc per-project `.envrc` files with symlinks to `~/.zsh/envrc/`.

---

## envrc Setup — Step by Step

| # | Step | Status |
|---|---|---|
| 1 | Create `~/.zsh/envrc/personal.envrc` — common config for all personal projects | pending |
| 2 | Create `~/.zsh/envrc/k3d-manager.envrc` — k3d-manager specific (PATH, core.hooksPath) | pending |
| 3 | Symlink `~/src/gitrepo/personal/.envrc` → `~/.zsh/envrc/personal.envrc` | pending |
| 4 | Symlink `~/src/gitrepo/personal/k3d-manager/.envrc` → `~/.zsh/envrc/k3d-manager.envrc` | pending |
| 5 | Remove old k3d-manager `.envrc` from git tracking | pending |
| 6 | Commit `~/.zsh` dotfiles | pending |

---

## Decisions Made

- `~/.local/bin/` is the target for user binaries — migration from `~/bin/` planned separately
- `personal.envrc` handles `sync-claude` (macOS) / `sync-gemini` (Ubuntu) via `uname -s` check
- `k3d-manager.envrc` will add `git config core.hooksPath scripts/hooks` (for agent_lint wiring)
- Per-repo `.envrc` uses `source_up` to inherit from parent `personal.envrc`
- `.envrc` files inside project repos are gitignored — symlinks only, never committed

---

## What Comes After envrc Setup

- Create `scripts/hooks/pre-commit` in k3d-manager (tracked hook file)
- Wire `_agent_lint` into pre-commit behind `K3DM_ENABLE_AI=1` guard
- `k3d-manager.envrc` sets `git config core.hooksPath scripts/hooks` automatically on `cd`
