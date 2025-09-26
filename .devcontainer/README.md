# FastAPI Quickstart (Dev Container)

Estas instrucciones funcionan con el `start.sh` actual (arranca Uvicorn cuando exista `/app/api/src/main.py`).

**Prerrequisitos**
- Docker / Docker Desktop
- VS Code + extensión **Dev Containers**
- Abrir el repo en *Dev Container* (Rebuild and Reopen)

## 1. Estructura mínima
Ejecuta esto **dentro del contenedor**:

```bash
mkdir -p /app/api/src
touch /app/api/__init__.py /app/api/src/__init__.py
```

## 2. Crea main.py
Ruta: `/app/api/src/main.py`.

> Nota: el import path que usa Uvicorn es `api.src.main:app`. Mantén estos nombres de carpetas/archivo.

```python
from fastapi import FastAPI

app = FastAPI(title="Example API")

@app.get("/")
async def root():
    return {"hello": "world"}

@app.get("/health")
async def health():
    return {"status": "ok"}
```

## 3. Dependencias
Opción A (persistente): crea `/app/requirements.txt`:

```text
fastapi[standard]
debugpy
```

Opción B (rápida en esta sesión):

`pip install 'fastapi[standard]' debugpy`

## 4. Reinicia
- VS Code: Dev Containers → Rebuild and Reopen in Container
- O desde host/WSL: docker compose restart python

## 5. Probar
```bash
curl -s http://localhost:8001/ | jq .
curl -s http://localhost:8001/health | jq .
```

#### Docs
Swagger: http://localhost:8001/docs
ReDoc: http://localhost:8001/redoc

## 6. Debug
Con DEBUG=1 y debugpy instalado, puedes Attach al puerto 5678 desde VS Code.

---

### Estructura esperada:
```text
/app
 ├─ requirements.txt
 └─ api/
    ├─ __init__.py
    └─ src/
       ├─ __init__.py
       └─ main.py    # define `app`
```

### Problemas comunes

- *Mensaje*: `[start] /app/api/src/main.py not found.`
*Solución*: Crea el archivo como en el paso 2 y reinicia el contenedor.

- *Mensaje*: `[start] fastapi/uvicorn are not installed.`
*Solución*: Si usas Opción A, espera a que termine el init.sh (verás “Installing dependencies…” en la terminal). Si no, ejecuta `pip install 'fastapi[standard]'` y verifica `python -c "import fastapi, uvicorn; print('OK')"`

- *No veo nada en el puerto 8001*:
Asegúrate de estar en el Dev Container y que el puerto 8001 esté reenviado (VS Code → Pestaña Ports).
