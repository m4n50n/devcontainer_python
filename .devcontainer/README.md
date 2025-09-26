# FastAPI Quickstart (Dev Container)

Estas instrucciones funcionan con el `start.sh` actual (arranca Uvicorn cuando exista `/workspace/app/src/main.py`).

**Prerrequisitos**
- Docker / Docker Desktop
- VS Code + extensión **Dev Containers**
- Abrir el repo en *Dev Container* (Rebuild and Reopen)

## 1. Estructura mínima

Ejecuta esto **dentro del contenedor**:

```bash
mkdir -p /workspace/app/src
```

## 2. Crea main.py

Ruta: `/workspace/app/src/main.py`.

> Nota: el import path que usa Uvicorn es `app.src.main:app`. Mantén estos nombres de carpetas/archivo.

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

Opción A (persistente - recomendado): debes crear `/workspace/app/requirements.txt` antes de hacer el rebuild para que `init.sh` lo detecte e instale:

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
/workspace
 └─ app/
    ├─ requirements.txt
    └─ src/
       └─ main.py    # define `app`
```

### /workspace/app/requirements.txt – Ejemplo:

```txt
# Web framework
fastapi[standard]

# Development tools
black>=23.0.0  # Code formatter
isort>=5.12.0  # Import sorting
debugpy>=1.6.0  # Debugging tool
```

### Problemas comunes

- *Mensaje*: `[start] /workspace/app/src/main.py not found.`
*Solución*: Crea el archivo como en el paso 2 y reinicia el contenedor.

- *Mensaje*: `[start] fastapi/uvicorn are not installed.`
*Solución*: Asegúrate de que exista `/workspace/app/requirements.txt` y que `init.sh` lo haya instalado. Si no, ejecuta `pip install 'fastapi[standard]' debugpy` y verifica con `python -c "import fastapi, uvicorn; print('OK')"`.

- *No veo nada en el puerto 8001*:
Asegúrate de estar en el Dev Container y que el puerto 8001 esté reenviado (VS Code → Pestaña Ports).
