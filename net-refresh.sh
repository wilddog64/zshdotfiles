#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$(uname -s)" != "Darwin"  ]]; then
   echo "This script is intended for macOS only." >&2to3
   exit 1
fi

net-refresh() {
  SVC=${1:-"Wi-Fi"}
  IF=${2:-"en0"}

  # Renew DHCP: try high-level helper first, fall back to low-level if needed
  networksetup -setdhcp "$SVC" || sudo ipconfig set "$IF" DHCP
  # Flush caches: DS cache (no sudo), then DNS cache (needs sudo)
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  # Optional: clear ARP entries (no sudo needed; errors are fine to ignore)
  arp -a -d 2>/dev/null || true
  # Optional: nudge Universal Control without toggling Wi-Fi
  pkill -x UniversalControl 2>/dev/null
  open -g /System/Library/CoreServices/UniversalControl.app 2>/dev/null
  echo "Network gently refreshed."
}

net-refresh "$@"
