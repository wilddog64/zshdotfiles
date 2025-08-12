#!/usr/bin/env bash

# time_info=$(curl -sS http://localhost:11434/api/ps | jq -r '.models[].expires_at')
# epoch_time=$(echo $time_info | jq -Rr 'fromdateiso8601 | todate | strftime("%Y-%m-%d %H:%M:%S")')
# expired_epoch_time=$(curl -sS http://localhost:11434/api/ps |
# jq -r '
#   .models[].expires_at
#   | sub("\\.[0-9]+"; "")            # drop fractional seconds (strptime can’t take them)
#   | sub("Z$"; "+0000")              # Z -> +0000 for BSD strptime
#   | sub(":(?=\\d\\d$)"; "")         # -07:00 -> -0700  (remove the last colon)
#   | strptime("%Y-%m-%dT%H:%M:%S%z")
#   | mktime
#   ')

# query ollma api/ps endpoint to get the model's expiration time
expired_time=$(curl -sS http://localhost:11434/api/ps | jq -r '.models[].expires_at')

# if we got an empty response, then model is expired so
# we have to make a wake up call, and set expired time to 12 hours
if [[ -z "$expired_epoch_time" ]]; then
   echo "model expired already, make a wakeup call"
   curl http://localhost:11434/api/generate -d "{\"${MODEL_NAME}\":\"gpt-oss:20b\",\"prompt\":\"ready\",\"options\\":{\"num_ctx\":4096},\"keep_alive\":\"12h\"}" >/dev/null 2>&1 &
fi
