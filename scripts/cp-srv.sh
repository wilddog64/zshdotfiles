# Serve Mac clipboard (pbpaste) on 127.0.0.1:7365
nohup socat TCP-LISTEN:7365,bind=127.0.0.1,fork SYSTEM:"pbpaste" \
  >/tmp/yank.log 2>&1 &  echo $! > ~/.cache/yank808.pid

# Accept data and copy to Mac clipboard (pbcopy) on 127.0.0.1:7366
nohup socat TCP-LISTEN:7366,bind=127.0.0.1,fork SYSTEM:"pbcopy" \
  >/tmp/paste.log 2>&1 &  echo $! > ~/.cache/paste808.pid

AUTOSSH_GATETIME=0 AUTOSSH_LOGFILE=~/.autossh-ubuntu.log \
autossh -M 0 -N -f ubuntu \
  -o ExitOnForwardFailure=yes \
  -R 127.0.0.1:7365:127.0.0.1:7365 \
  -R 127.0.0.1:7366:127.0.0.1:7366
