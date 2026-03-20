#!/usr/bin/env bash
# claude-cleanup.sh — prune Claude session files older than 14 days
# Managed by launchd: ~/Library/LaunchAgents/com.user.claude-cleanup.plist

set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
RETENTION_DAYS=14

log() { echo "[claude-cleanup] $*" | tee /dev/stderr | logger -t claude-cleanup; }

sessions_deleted=$(find "${CLAUDE_DIR}/projects" -name "*.jsonl" -mtime +${RETENTION_DAYS} -print -delete 2>/dev/null | wc -l | tr -d ' ')
history_deleted=$(find "${CLAUDE_DIR}/file-history" -type f -mtime +${RETENTION_DAYS} -print -delete 2>/dev/null | wc -l | tr -d ' ')
find "${CLAUDE_DIR}/file-history" -type d -empty -delete 2>/dev/null || true

log "done — removed ${sessions_deleted} session(s), ${history_deleted} file-history entries (retention: ${RETENTION_DAYS}d)"
