# Active Context — ~/.zsh dotfiles

## Snapshot (2026-03-20)

Repository was scanned to refresh operating rules and working context for future edits.

## Repo Purpose

Personal zsh-first dotfiles for macOS + Ubuntu, including shell startup, aliases,
functions, scripts, direnv glue, and terminal/tmux/tool configuration.

## Current Canonical Structure

- Root startup/config: `zshrc`, `zprofile`, `zshenv`, `aliases`, `direnvrc`
- Reusable shell helpers: `functions/*.sh`
- User-invoked automation: `scripts/*`
- Direnv source-of-truth: `envrc/*.envrc` (symlinked into project repos)
- AI memory/state: `memory-bank/activeContext.md`

## Confirmed Operating Patterns

1. **Direnv layering**
   - `envrc/personal.envrc`:
     - macOS: runs `~/.local/bin/sync-claude ~/.claude` + `~/.local/bin/sync-gemini ~/.gemini`
     - non-macOS: runs only `~/.local/bin/sync-gemini ~/.gemini`
   - `envrc/k3d-manager.envrc`:
     - `source_up`
     - appends local `bin/` to `PATH`
     - sets `git config core.hooksPath scripts/hooks`
     - exports `AGENT_LINT_GATE_VAR` and `AGENT_LINT_AI_FUNC`

2. **Script inventory highlights**
   - Sync: `scripts/sync-agent-state.sh`, `scripts/sync-claude`, `scripts/sync-gemini`
   - Clipboard/tmux: `scripts/yank`, `scripts/put`, `scripts/yanks`
   - Safety/sanitization: `scripts/sanitize.sh`, `sanitize.sed`
   - Session helper: `scripts/tmx`

3. **Style conventions observed**
   - Most automation scripts use strict mode (`set -euo pipefail` / `set -eu`)
   - Naming is generally short and hyphenated
   - Root files include legacy + modern config; preserve behavior unless asked to refactor

## Maintenance Notes

- Prefer `~/.local/bin` over legacy `~/bin` references in new/updated work.
- Keep project-specific direnv behavior in `envrc/*.envrc`, not `direnvrc`.
- Treat `services-output/` as sensitive output; sanitize before sharing.

## Follow-up Items (non-blocking)

- If touched later, modernize scripts lacking strict mode or quoting hardening.
- Review secret handling in local shell env files and migrate sensitive values to
  non-committed/local mechanisms.
