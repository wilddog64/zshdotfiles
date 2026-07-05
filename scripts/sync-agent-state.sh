#!/usr/bin/env bash
# sync-agent-state.sh <target_dir>
# Generic script to sync agent directories (claude, gemini, etc.)
# Logic: Stage changes, commit with project context, and push if ahead.

set -euo pipefail

TARGET_DIR="${1:-}"

# Guard: target directory required
if [[ -z "$TARGET_DIR" ]]; then
  echo "[sync-agent] error: no target directory provided"
  exit 1
fi

# Resolve the physical path of the target directory (cross-platform)
if ! PHYSICAL_DIR=$(cd -P "$TARGET_DIR" 2>/dev/null && pwd); then
  echo "[sync-agent] error: directory $TARGET_DIR does not exist"
  exit 1
fi

AGENT_NAME="$(basename "$PHYSICAL_DIR" | sed 's/^\.//')"
PROJECT_NAME="$(basename "${OLDPWD:-unknown}")"

# Guard: must be a git repo
if [[ ! -d "$PHYSICAL_DIR/.git" ]]; then
  echo "[$AGENT_NAME-sync] warning: $PHYSICAL_DIR is not a git repo — skipping"
  exit 0
fi

cd "$PHYSICAL_DIR"

# Stage trackable changes
# We use a broad pattern but allow for specific agent files
git add . ':(exclude)image-cache' 2>/dev/null || true

# Defense-in-depth: never commit credentials or volatile runtime state, even if the
# target dir lacks a .gitignore for them. Unstage anything matching a sensitive pattern.
while IFS= read -r _f; do
  case "$_f" in
    *oauth*token*|*oauth*creds*|*.pem|*.key|*.p12|*.pfx|*id_rsa|*id_dsa|\
    .env|*/.env|*.env|*.log|*.db|*.db-shm|*.db-wal|*token.json|*credentials.json)
      git reset -q -- "$_f" 2>/dev/null || true
      echo "[$AGENT_NAME-sync] skipped sensitive/runtime file: $_f"
      ;;
  esac
done < <(git diff --cached --name-only 2>/dev/null)

# If ggshield is available, block the sync on any detected secret in staged changes.
if command -v ggshield >/dev/null 2>&1 && ! git diff --cached --quiet; then
  ggshield secret scan pre-commit >/dev/null 2>&1
  _gg_rc=$?
  if [[ $_gg_rc -eq 1 ]]; then
    echo "[$AGENT_NAME-sync] ABORT: ggshield detected a secret in staged changes — not committing"
    git reset -q 2>/dev/null || true
    exit 1
  fi
fi

# Only commit if there are staged changes
if ! git diff --cached --quiet; then
  git commit -m "chore: sync on $(date '+%Y-%m-%d %H:%M') — ${PROJECT_NAME}"
  echo "[$AGENT_NAME-sync] committed changes from ${PROJECT_NAME}"
fi

# Guard: remote 'origin' must be configured for push
if ! git remote get-url origin &>/dev/null; then
  echo "[$AGENT_NAME-sync] info: no remote 'origin' configured — local sync only"
  exit 0
fi

# Push if ahead of remote
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM" 2>/dev/null || echo "")

if [[ "$LOCAL" != "$REMOTE" ]]; then
  # Check if we are actually ahead
  if [[ $(git rev-list origin/main..HEAD --count 2>/dev/null || echo 0) -gt 0 ]]; then
    git push origin main
    echo "[$AGENT_NAME-sync] pushed to origin main"
  fi
fi
