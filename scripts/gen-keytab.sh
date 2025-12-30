#!/usr/bin/env bash
# run in WSL (interactive for your AD password once)
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"

ktutil <<-EOF
addent -password -p chengkai.liang@pactific.costcotravel.com -k 1 -e aes256-cts-hmac-sha1-96
# enter your AD password when prompted
wkt $SCRIPT_DIR/../scratch/chengkai.keytab
quit
EOF
chmod 600 $SCRIPT_DIR/../scratch/chengkai.keytab
chown $(id -u):$(id -g) $SCRIPT_DIR/../scratch/chengkai.keytab
