#!/usr/bin/env bash
# claude-cleanup.sh — prune Claude session files older than 14 days
# Managed by launchd: ~/Library/LaunchAgents/com.user.claude-cleanup.plist

set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
RETENTION_DAYS=14

find "${CLAUDE_DIR}/projects" -name "*.jsonl" -mtime +${RETENTION_DAYS} -delete 2>/dev/null || true
find "${CLAUDE_DIR}/file-history" -type f -mtime +${RETENTION_DAYS} -delete 2>/dev/null || true
find "${CLAUDE_DIR}/file-history" -type d -empty -delete 2>/dev/null || true
