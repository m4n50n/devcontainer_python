#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/workspace/app"
MAIN_FILE="$APP_DIR/src/main.py"
RELOAD_DIR="$APP_DIR"
DEBUG_PORT="${DEBUG_PORT:-5678}"

log() { echo "[start] $*"; }

have_py() {
  python - "$@" <<'PY'
import importlib, sys
ok = True
for m in sys.argv[1:]:
    try:
        importlib.import_module(m)
    except Exception:
        ok = False
        break
sys.exit(0 if ok else 1)
PY
}

if [ ! -f "$MAIN_FILE" ]; then
  log "$MAIN_FILE not found."
  log "Container is running and waiting."
  log "To get started:"
  log "  1) Create /workspace/app/src/main.py with a FastAPI app named 'app'."
  log "  2) Install deps: pip install 'fastapi[standard]'"
  log "  3) Restart the container."
  exec tail -f /dev/null
fi

# Wait for dependencies installed by init.sh (up to ~120s)
for i in $(seq 1 60); do
  if have_py fastapi uvicorn; then
    break
  fi
  if [ "$i" -eq 1 ]; then
    log "Waiting for FastAPI/Uvicorn to be installed (init may still be running)..."
  fi
  sleep 2
done

if ! have_py fastapi uvicorn; then
  log "FastAPI/Uvicorn not installed after waiting."
  log "Run inside the container: pip install 'fastapi[standard]'"
  exec tail -f /dev/null
fi

RUN_DEBUG=0
if [ "${DEBUG:-0}" = "1" ]; then
  if have_py debugpy; then
    RUN_DEBUG=1
  else
    log "DEBUG=1 but 'debugpy' is not installed. Falling back to non-debug mode."
    log "Tip: pip install debugpy  # then restart the container"
  fi
fi

if [ "$RUN_DEBUG" = "1" ]; then
  log "Starting FastAPI with debugpy on :${DEBUG_PORT}..."
  exec python -m debugpy --listen 0.0.0.0:${DEBUG_PORT} \
       -m uvicorn app.src.main:app \
       --host 0.0.0.0 --port 8001 --reload \
       --reload-dir "$RELOAD_DIR" \
       --reload-exclude "*.log" --reload-exclude "__pycache__" --reload-exclude ".git" \
       --workers 1 --timeout-keep-alive 2 --reload-delay 0.25 --log-level debug
else
  log "Starting FastAPI (no debug)..."
  exec uvicorn app.src.main:app \
       --host 0.0.0.0 --port 8001 --reload \
       --reload-dir "$RELOAD_DIR" \
       --reload-exclude "*.log" --reload-exclude "__pycache__" --reload-exclude ".git" \
       --workers 1 --timeout-keep-alive 2 --reload-delay 0.25 --log-level debug
fi
