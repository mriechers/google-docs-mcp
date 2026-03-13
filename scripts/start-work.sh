#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export GOOGLE_CREDENTIALS_PATH="$SCRIPT_DIR/../credentials/work/credentials.json"
export GOOGLE_TOKEN_PATH="$SCRIPT_DIR/../credentials/work/token.json"
exec node "$SCRIPT_DIR/../index.js"
