#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/app"
REQ_FILE="/app/api/requirements.txt"

# Detect requirements.txt
if [ ! -f "$REQ_FILE" ]; then
  echo "[init] $REQ_FILE not found; skipping pip install."
  exit 0
fi

# Avoid permission issues with git
git config --global --add safe.directory "$PROJECT_DIR" || true
git config --global --add safe.directory "$PROJECT_DIR/api" || true

# Speed up pip and reduce noise
export PIP_DISABLE_PIP_VERSION_CHECK=1

# Upgrade pip and wheel
python -m pip install --no-cache-dir --upgrade pip wheel

# Install dependencies
echo "[init] Installing dependencies from $REQ_FILE..."
python -m pip install --no-cache-dir --upgrade -r "$REQ_FILE"

echo "[init] Initialization script completed."
