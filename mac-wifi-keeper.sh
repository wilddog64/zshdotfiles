#!/usr/bin/env bash

set -euo pipefail

IF=en0
SSID_WANT='MeshHome'
GATEWAY_WANT='192.168.1.1'

# return current gateway ip address
current_gw() {
    /sbin/route get default | awk '/gateway/ {print $2}'
}

# rejoin the SSID if the gateway is not as expected
rejoin_ssid() {
    echo "Rejoining SSID $SSID_WANT..."
    sleep 2
    eetworksetup -setairportnetwork "$IF" "$SSID_WANT" || true
 }

# initial check and rejoin if necessary
[[ "$(current_gw) != $GATEWAY_WANT" ]] && rejoin_ssid

# monitor the gateway and rejoin if it changes
while true; do
   old=$(current_gw)
   while [[ $(current_gw) == "$old" ]]; do sleep 5; done
   [[ "$(current_gw)" != "$GATEWAY_WANT" ]] && rejoin_ssid
done
