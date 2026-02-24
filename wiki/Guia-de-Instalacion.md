# Guia de Instalacion de Skills - Paso a Paso

Esta guia explica como instalar y configurar las skills de OpenCode en **Windows**, **macOS** y **Linux**.

---

## Prerequisitos

Antes de instalar las skills, asegurate de tener:

1. **Git** instalado ([descargar](https://git-scm.com/downloads))
2. **OpenCode** instalado y configurado (con un proveedor de LLM activo)
3. Acceso al repositorio de skills

### Verificar que OpenCode esta instalado

```bash
opencode --version
```

Si no lo tenes instalado, seguir la documentacion oficial de OpenCode.

---

## Paso 1: Clonar el repositorio de skills

### Windows (PowerShell)

```powershell
cd $env:USERPROFILE\Documents
git clone https://github.com/ozambelachota/skill-zzoft.git
```

### macOS (Terminal)

```bash
cd ~/Documents
git clone https://github.com/ozambelachota/skill-zzoft.git
```

### Linux (Terminal)

```bash
cd ~/Documents
git clone https://github.com/ozambelachota/skill-zzoft.git
```

---

## Paso 2: Crear el directorio de skills (si no existe)

OpenCode busca skills en las siguientes ubicaciones (en orden de prioridad):

| Prioridad | Ubicacion | Alcance |
|-----------|-----------|---------|
| 1 | `.opencode/skills/<nombre>/SKILL.md` | Proyecto (solo para ese repo) |
| 2 | `~/.config/opencode/skills/<nombre>/SKILL.md` | Global (todos los proyectos) |
| 3 | `.claude/skills/<nombre>/SKILL.md` | Proyecto (compatibilidad Claude) |
| 4 | `~/.claude/skills/<nombre>/SKILL.md` | Global (compatibilidad Claude) |

Para instalacion **global** (recomendado para skills del equipo):

### Windows (PowerShell)

```powershell
# Crear directorio si no existe
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\opencode\skills"

# Verificar que se creo
Test-Path "$env:USERPROFILE\.config\opencode\skills"
# Deberia devolver: True
```

### macOS (Terminal)

```bash
# Crear directorio si no existe
mkdir -p ~/.config/opencode/skills

# Verificar que se creo
ls -la ~/.config/opencode/skills
```

### Linux (Terminal)

```bash
# Crear directorio si no existe
mkdir -p ~/.config/opencode/skills

# Verificar que se creo
ls -la ~/.config/opencode/skills
```

---

## Paso 3: Copiar las skills al directorio de OpenCode

### Windows (PowerShell)

```powershell
# Copiar TODAS las skills
Copy-Item -Recurse -Force "$env:USERPROFILE\Documents\skill-zzoft\skills\*" "$env:USERPROFILE\.config\opencode\skills\"

# Verificar que se copiaron
Get-ChildItem "$env:USERPROFILE\.config\opencode\skills" -Directory
```

Resultado esperado:

```
Directory: C:\Users\TU_USUARIO\.config\opencode\skills

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2/23/2026  12:00 PM                dotnet-clean-cqrs
d-----         2/23/2026  12:00 PM                java-hexagonal-secure
```

### macOS (Terminal)

```bash
# Copiar TODAS las skills
cp -r ~/Documents/skill-zzoft/skills/* ~/.config/opencode/skills/

# Verificar que se copiaron
ls ~/.config/opencode/skills/
```

Resultado esperado:

```
dotnet-clean-cqrs    java-hexagonal-secure
```

### Linux (Terminal)

```bash
# Copiar TODAS las skills
cp -r ~/Documents/skill-zzoft/skills/* ~/.config/opencode/skills/

# Verificar que se copiaron
ls ~/.config/opencode/skills/
```

Resultado esperado:

```
dotnet-clean-cqrs    java-hexagonal-secure
```

---

## Paso 4: Verificar que OpenCode detecta las skills

1. Abri una terminal en cualquier proyecto
2. Inicia OpenCode:

```bash
opencode
```

3. Escribe un prompt que active la skill. Por ejemplo:

```
Crea un microservicio .NET con Clean Architecture y CQRS para gestionar productos
```

Si la skill esta correctamente instalada, OpenCode la cargara automaticamente y seguira los patrones definidos en ella.

---

## Instalacion por proyecto (alternativa)

Si queres que las skills esten disponibles solo en un proyecto especifico en vez de globalmente:

### Windows (PowerShell)

```powershell
cd C:\ruta\a\tu\proyecto
mkdir -Force .opencode\skills
Copy-Item -Recurse -Force "$env:USERPROFILE\Documents\skill-zzoft\skills\*" ".\.opencode\skills\"
```

### macOS / Linux (Terminal)

```bash
cd /ruta/a/tu/proyecto
mkdir -p .opencode/skills
cp -r ~/Documents/skill-zzoft/skills/* .opencode/skills/
```

> **Nota:** Las skills de proyecto tienen prioridad sobre las globales. Si tenes la misma skill en ambas ubicaciones, se usa la del proyecto.

---

## Actualizacion de skills

Cuando se publiquen nuevas versiones de las skills:

### Todos los sistemas operativos

```bash
# Ir al directorio donde clonaste el repo
cd ~/Documents/skill-zzoft    # o donde lo hayas clonado

# Traer los cambios
git pull origin main

# Volver a copiar las skills actualizadas
# (usar el comando de copia de tu sistema operativo del Paso 3)
```

---

## Desinstalacion de una skill

Para remover una skill especifica:

### Windows (PowerShell)

```powershell
# Remover skill dotnet-clean-cqrs
Remove-Item -Recurse -Force "$env:USERPROFILE\.config\opencode\skills\dotnet-clean-cqrs"

# Remover skill java-hexagonal-secure
Remove-Item -Recurse -Force "$env:USERPROFILE\.config\opencode\skills\java-hexagonal-secure"
```

### macOS / Linux (Terminal)

```bash
# Remover skill dotnet-clean-cqrs
rm -rf ~/.config/opencode/skills/dotnet-clean-cqrs

# Remover skill java-hexagonal-secure
rm -rf ~/.config/opencode/skills/java-hexagonal-secure
```

---

## Troubleshooting

### La skill no se activa automaticamente

1. Verifica que el archivo `SKILL.md` existe en la ubicacion correcta:
   ```bash
   # Linux/macOS
   cat ~/.config/opencode/skills/dotnet-clean-cqrs/SKILL.md

   # Windows PowerShell
   Get-Content "$env:USERPROFILE\.config\opencode\skills\dotnet-clean-cqrs\SKILL.md"
   ```

2. Verifica que el frontmatter YAML tiene `name` y `description` correctos

3. Reinicia OpenCode (salir y volver a entrar)

### Error "skill not found"

Asegurate de que la estructura de carpetas sea correcta:

```
~/.config/opencode/skills/
├── dotnet-clean-cqrs/
│   ├── SKILL.md          <-- ESTE ARCHIVO ES OBLIGATORIO
│   └── assets/
│       └── docker-build.sh
└── java-hexagonal-secure/
    ├── SKILL.md          <-- ESTE ARCHIVO ES OBLIGATORIO
    └── references/
        └── structure.md
```

El nombre de la carpeta DEBE coincidir con el campo `name` dentro del frontmatter de `SKILL.md`.

### Los assets no se encuentran

Los paths dentro de `SKILL.md` son relativos al directorio de la skill. Si un asset referencia `assets/docker-build.sh`, el archivo debe estar en:
```
~/.config/opencode/skills/dotnet-clean-cqrs/assets/docker-build.sh
```
