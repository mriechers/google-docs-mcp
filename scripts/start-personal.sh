#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export GOOGLE_CREDENTIALS_PATH="$SCRIPT_DIR/../credentials/personal/credentials.json"
export GOOGLE_TOKEN_PATH="$SCRIPT_DIR/../credentials/personal/token.json"
exec node "$SCRIPT_DIR/../index.js"
