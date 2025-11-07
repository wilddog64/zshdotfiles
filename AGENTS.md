# Repository Guidelines

## Project Structure & Module Organization
Core shell profiles (`zshrc`, `zprofile`, `zshenv`) sit at the repo root; edit them only when changing login behavior. Topical config folders (`aliases/`, `functions/`, `bindingkeys/`, `smartcd_*`) keep reusable snippets organized by shell feature. Place automation under `scripts/` and keep helper completions in `fzf-shell/` or alongside the tool (for example `yq.complete.zsh`). Hardware-specific assets such as `aerospace.toml` and `starship.toml` belong at top level to stay easy to symlink into `$HOME`.

## Build, Test, and Development Commands
- `source ./zshrc` reloads the main profile without starting a new shell—use after editing core settings.
- `./scripts/tmx <session>` wraps tmux presets; update it before committing tmux tweaks.
- `./scripts/sanitize.sh <file>` strips secrets from captured logs; run it prior to sharing artifacts.

## Coding Style & Naming Conventions
Write portable POSIX shell when possible; otherwise pin the interpreter on the shebang and include `set -euo pipefail` near the top. Favor two-space indentation and keep lines under 100 characters to match existing dotfiles. Name scripts with short hyphenated verbs (`mac-wifi-keeper`, `net-refresh`), and suffix executables with `.sh` only when they must be invoked via `sh`. Zsh helper files should use the `.zsh` suffix and expose functions via lowercase snake_case names.

## Testing Guidelines
Lint shell changes with `shellcheck scripts/<file>` and syntax-check zsh sources using `zsh -n <file>` before running them interactively. For interactive helpers, provide a dry-run flag or echo mode (see `scripts/put`) so reviewers can validate behavior without side effects. Keep ad-hoc tests in `scripts/warmup-ai` or temporary scratch files and delete them before opening a PR.

## Commit & Pull Request Guidelines
Follow the existing history: concise, imperative subject lines under ~60 characters (e.g., `add socat support to both yank and put`). Reference affected areas in the subject, then add detail in the body if needed. PRs should describe the shell entry points touched, list manual test steps (e.g., `source zshrc && yank foo`), and include screenshots only when UI-facing tools like `alacritty.toml` or `aerospace.toml` change.

## Security & Configuration Tips
Never commit secrets harvested from `services-output/`; sanitize with `scripts/sanitize.sh` and store credentials in your password manager. Use `scripts/vault_encrypt.sh <file>` for configs that must live in git but contain sensitive values, and document the decrypt command in the PR so others can reproduce your setup safely.
