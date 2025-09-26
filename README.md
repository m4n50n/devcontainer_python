# Usar WSL como root en VS Code / Terminal

## 📌 ¿Por qué hacer esto?
En algunas ocasiones (por ejemplo, al trabajar con contenedores, proyectos montados en carpetas protegidas o al configurar permisos en `/var/www/html`) es útil que la distribución de **WSL** abra la sesión directamente como `root`.  
De esta manera no es necesario usar `sudo` continuamente ni encontrarse con errores de permisos.

⚠️ **Advertencia**: usar siempre `root` puede ser inseguro. Lo ideal es hacerlo solo en entornos de desarrollo o cuando sabes exactamente lo que necesitas.

---

## 🔍 ¿Cómo saber qué comando usar?
Cada distribución de Ubuntu instalada en Windows tiene su propio **ejecutable**.  
Para verlos, abre **PowerShell** y ejecuta:

```powershell
Get-Command *ubuntu*
```

Si tu distro es Ubuntu-22.04, el comando será:

```powershell
ubuntu2204 config --default-user root
```

De esta manera, al conectar con *WSL* desde *VSCode*, por ejemplo, entrará como root directamente.