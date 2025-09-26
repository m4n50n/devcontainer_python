#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/app"

# Detect requirements.txt
if [ ! -f "$PROJECT_DIR/requirements.txt" ]; then
  echo "[init] requirements.txt not found in $PROJECT_DIR; skipping pip install."
  exit 0
fi

# Avoid permission issues with git
git config --global --add safe.directory "$PROJECT_DIR" || true

# Speed up pip and reduce noise
export PIP_DISABLE_PIP_VERSION_CHECK=1

# Upgrade pip and wheel
python -m pip install --no-cache-dir --upgrade pip wheel

# Install dependencies
echo "[init] Installing dependencies from requirements.txt..."
python -m pip install --no-cache-dir --upgrade -r "$PROJECT_DIR/requirements.txt"

echo "[init] Initialization script completed."
