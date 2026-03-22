#!/usr/bin/env bash
# ~/.zsh/scripts/pty-watchdog.sh
# Monitor PTY usage per process and kill any single process exceeding the threshold.
# Designed to catch Gemini CLI PTY leaks that exhaust the macOS PTY pool (kern.tty.ptmx_max=511).
#
# Runs via launchd: ~/Library/LaunchAgents/com.cliang.pty-watchdog.plist

set -euo pipefail

PTY_THRESHOLD="${PTY_THRESHOLD:-100}"
LOG="$HOME/.cache/pty-watchdog.log"
mkdir -p "$(dirname "$LOG")"

_log() { echo "[pty-watchdog] $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG"; }

# Get PTY count per PID, sorted descending
while IFS= read -r line; do
  count=$(echo "$line" | awk '{print $1}')
  proc=$(echo "$line" | awk '{print $2}')
  pid=$(echo "$line" | awk '{print $3}')

  if [[ "$count" -ge "$PTY_THRESHOLD" ]]; then
    tty=$(ps -p "$pid" -o tty= 2>/dev/null | tr -d '[:space:]')
    if [[ "$tty" != "??" && -n "$tty" ]]; then
      _log "SKIP: $proc (PID $pid) holds $count PTYs but has active TTY $tty — skipping"
      continue
    fi
    _log "WARNING: $proc (PID $pid) holds $count PTYs, no TTY (orphaned) — exceeds threshold $PTY_THRESHOLD"
    _log "Killing PID $pid ..."
    kill "$pid" 2>/dev/null && _log "Killed $pid" || _log "Failed to kill $pid (already gone?)"
  fi
done < <(lsof /dev/ptmx 2>/dev/null | awk 'NR>1 {print $1, $2}' | sort | uniq -c | sort -rn | awk '{print $1, $2, $3}')

_log "Check complete."
