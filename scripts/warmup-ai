#!/usr/bin/env bash

# This script is used to warm up the gpt-oss:20b model by sending a request to the API.
model_name="$1:-gpt-oss:20b"
curl http://localhost:11434/api/generate -d "{\"${model_name}\":\"gpt-oss:20b\",\"prompt\":\"ready\",\"options\\":{\"num_ctx\":4096},\"keep_alive\":\"12h\"}" >/dev/null 2>&1 &
