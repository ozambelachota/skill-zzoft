# Guia de Instalacion de Skills - Paso a Paso

Guia completa para instalar las skills de Zzoft en **OpenCode**, **Claude Code** y **Codex (OpenAI)**, en **Windows**, **macOS** y **Linux**.

---

## Prerequisitos

1. **Git** instalado ([descargar](https://git-scm.com/downloads))
2. Al menos uno de los agentes instalado:
   - **OpenCode**: `npm i -g opencode` o ver [docs](https://github.com/sst/opencode)
   - **Claude Code**: `npm i -g @anthropic-ai/claude-code` o ver [docs](https://docs.anthropic.com/en/docs/claude-code/overview)
   - **Codex CLI**: `npm i -g @openai/codex` o `brew install --cask codex` o ver [docs](https://developers.openai.com/codex)

---

## Paso 1: Clonar el repositorio de skills

### Windows (PowerShell)

```powershell
cd $env:USERPROFILE\Documents
git clone https://github.com/ozambelachota/skill-zzoft.git
```

### macOS / Linux (Terminal)

```bash
cd ~/Documents
git clone https://github.com/ozambelachota/skill-zzoft.git
```

---

## Paso 2: Elegir donde instalar

Las skills se pueden instalar de dos formas:

| Alcance | Descripcion | Cuando usar |
|---------|-------------|-------------|
| **Global** | Disponible en TODOS tus proyectos | Recomendado para skills del equipo |
| **Por proyecto** | Solo disponible en ESE proyecto | Para skills especificas de un repo |

### Rutas por agente

#### Instalacion GLOBAL (recomendado)

| Agente | Windows | macOS / Linux |
|--------|---------|---------------|
| OpenCode | `%USERPROFILE%\.config\opencode\skills\` | `~/.config/opencode/skills/` |
| Claude Code | `%USERPROFILE%\.claude\skills\` | `~/.claude/skills/` |
| Codex | `%USERPROFILE%\.agents\skills\` | `~/.agents/skills/` |

#### Instalacion POR PROYECTO

| Agente | Ruta (dentro del proyecto) |
|--------|---------------------------|
| OpenCode | `.opencode/skills/` |
| Claude Code | `.claude/skills/` |
| Codex | `.agents/skills/` |

> **Nota**: Las skills de proyecto tienen prioridad sobre las globales.

---

## Paso 3: Crear directorios e instalar

### Para OpenCode

#### Windows (PowerShell)

```powershell
# Crear directorio global
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\opencode\skills"

# Copiar skills
Copy-Item -Recurse -Force "$env:USERPROFILE\Documents\skill-zzoft\skills\*" "$env:USERPROFILE\.config\opencode\skills\"

# Verificar
Get-ChildItem "$env:USERPROFILE\.config\opencode\skills" -Directory
```

#### macOS / Linux (Terminal)

```bash
# Crear directorio global
mkdir -p ~/.config/opencode/skills

# Copiar skills
cp -r ~/Documents/skill-zzoft/skills/* ~/.config/opencode/skills/

# Verificar
ls ~/.config/opencode/skills/
```

**Resultado esperado:**
```
dotnet-clean-cqrs    java-hexagonal-secure
```

---

### Para Claude Code

#### Windows (PowerShell)

```powershell
# Crear directorio global
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills"

# Copiar skills
Copy-Item -Recurse -Force "$env:USERPROFILE\Documents\skill-zzoft\skills\*" "$env:USERPROFILE\.claude\skills\"

# Verificar
Get-ChildItem "$env:USERPROFILE\.claude\skills" -Directory
```

#### macOS / Linux (Terminal)

```bash
# Crear directorio global
mkdir -p ~/.claude/skills

# Copiar skills
cp -r ~/Documents/skill-zzoft/skills/* ~/.claude/skills/

# Verificar
ls ~/.claude/skills/
```

**Resultado esperado:**
```
dotnet-clean-cqrs    java-hexagonal-secure
```

---

### Para Codex (OpenAI)

#### Windows (PowerShell)

```powershell
# Crear directorio global
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"

# Copiar skills
Copy-Item -Recurse -Force "$env:USERPROFILE\Documents\skill-zzoft\skills\*" "$env:USERPROFILE\.agents\skills\"

# Verificar
Get-ChildItem "$env:USERPROFILE\.agents\skills" -Directory
```

#### macOS / Linux (Terminal)

```bash
# Crear directorio global
mkdir -p ~/.agents/skills

# Copiar skills
cp -r ~/Documents/skill-zzoft/skills/* ~/.agents/skills/

# Verificar
ls ~/.agents/skills/
```

**Resultado esperado:**
```
dotnet-clean-cqrs    java-hexagonal-secure
```

---

### Instalar en los 3 agentes de una vez

Si usas los 3 agentes, podes instalar todo junto:

#### macOS / Linux

```bash
SKILLS_SRC=~/Documents/skill-zzoft/skills

# OpenCode
mkdir -p ~/.config/opencode/skills && cp -r $SKILLS_SRC/* ~/.config/opencode/skills/

# Claude Code
mkdir -p ~/.claude/skills && cp -r $SKILLS_SRC/* ~/.claude/skills/

# Codex
mkdir -p ~/.agents/skills && cp -r $SKILLS_SRC/* ~/.agents/skills/
```

#### Windows (PowerShell)

```powershell
$src = "$env:USERPROFILE\Documents\skill-zzoft\skills\*"

# OpenCode
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\opencode\skills"
Copy-Item -Recurse -Force $src "$env:USERPROFILE\.config\opencode\skills\"

# Claude Code
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills"
Copy-Item -Recurse -Force $src "$env:USERPROFILE\.claude\skills\"

# Codex
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
Copy-Item -Recurse -Force $src "$env:USERPROFILE\.agents\skills\"
```

---

## Paso 4: Verificar la instalacion

### OpenCode

```bash
opencode
# Escribir: "que skills tenes disponibles?"
# O usar /skill para listar
```

### Claude Code

```bash
claude
# Escribir: "que skills hay disponibles?"
# O invocar directamente: /dotnet-clean-cqrs
```

### Codex

```bash
codex
# Escribir /skills para ver la lista
# O invocar: $dotnet-clean-cqrs
```

---

## Paso 5: Probar una skill

Escribe un prompt que active la skill automaticamente:

```
Crea un microservicio en .NET 9 para gestionar inventario de productos
con Clean Architecture y CQRS. Necesito CRUD completo.
```

El agente deberia:
1. Detectar que necesita la skill `dotnet-clean-cqrs`
2. Cargar las instrucciones de la skill
3. Generar el proyecto siguiendo la arquitectura definida

---

## Instalacion por proyecto (alternativa)

Si preferis que las skills esten solo en un proyecto especifico:

### OpenCode

```bash
cd /ruta/a/tu/proyecto
mkdir -p .opencode/skills
cp -r ~/Documents/skill-zzoft/skills/* .opencode/skills/
```

### Claude Code

```bash
cd /ruta/a/tu/proyecto
mkdir -p .claude/skills
cp -r ~/Documents/skill-zzoft/skills/* .claude/skills/
```

### Codex

```bash
cd /ruta/a/tu/proyecto
mkdir -p .agents/skills
cp -r ~/Documents/skill-zzoft/skills/* .agents/skills/
```

---

## Actualizacion de skills

Cuando se publiquen nuevas versiones:

```bash
cd ~/Documents/skill-zzoft
git pull origin main

# Volver a copiar al agente que uses (ver Paso 3)
```

---

## Desinstalacion

### macOS / Linux

```bash
# OpenCode
rm -rf ~/.config/opencode/skills/dotnet-clean-cqrs
rm -rf ~/.config/opencode/skills/java-hexagonal-secure

# Claude Code
rm -rf ~/.claude/skills/dotnet-clean-cqrs
rm -rf ~/.claude/skills/java-hexagonal-secure

# Codex
rm -rf ~/.agents/skills/dotnet-clean-cqrs
rm -rf ~/.agents/skills/java-hexagonal-secure
```

### Windows (PowerShell)

```powershell
# OpenCode
Remove-Item -Recurse -Force "$env:USERPROFILE\.config\opencode\skills\dotnet-clean-cqrs"
Remove-Item -Recurse -Force "$env:USERPROFILE\.config\opencode\skills\java-hexagonal-secure"

# Claude Code
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\skills\dotnet-clean-cqrs"
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\skills\java-hexagonal-secure"

# Codex
Remove-Item -Recurse -Force "$env:USERPROFILE\.agents\skills\dotnet-clean-cqrs"
Remove-Item -Recurse -Force "$env:USERPROFILE\.agents\skills\java-hexagonal-secure"
```

---

## Troubleshooting

### La skill no se activa automaticamente

1. Verificar que `SKILL.md` existe en la ruta correcta del agente
2. Verificar que el frontmatter tiene `name` y `description`
3. Reiniciar el agente (salir y volver a entrar)
4. Probar invocacion manual (`/skill`, `/nombre-skill`, o `$nombre-skill`)

### El nombre de la carpeta no coincide

El nombre de la carpeta **DEBE** coincidir con el campo `name` en el frontmatter de `SKILL.md`:

```
~/.claude/skills/dotnet-clean-cqrs/    <-- nombre carpeta
                 └── SKILL.md
                     name: dotnet-clean-cqrs  <-- debe coincidir
```

### Estructura correcta de archivos

```
# OpenCode
~/.config/opencode/skills/
├── dotnet-clean-cqrs/
│   ├── SKILL.md
│   └── assets/
│       └── docker-build.sh
└── java-hexagonal-secure/
    ├── SKILL.md
    └── references/
        └── structure.md

# Claude Code (misma estructura, diferente ruta)
~/.claude/skills/
├── dotnet-clean-cqrs/
│   └── ...
└── java-hexagonal-secure/
    └── ...

# Codex (misma estructura, diferente ruta)
~/.agents/skills/
├── dotnet-clean-cqrs/
│   └── ...
└── java-hexagonal-secure/
    └── ...
```

### Comparacion rapida entre agentes

| Caracteristica | OpenCode | Claude Code | Codex |
|---------------|----------|-------------|-------|
| Activacion automatica | Si | Si | Si (por defecto) |
| Invocacion manual | `/skill` | `/nombre-skill` | `$nombre-skill` |
| Listar skills | `/skill` | "que skills hay?" | `/skills` |
| Estandar | Agent Skills | Agent Skills | Agent Skills |
| Carpeta global | `~/.config/opencode/skills/` | `~/.claude/skills/` | `~/.agents/skills/` |
| Carpeta proyecto | `.opencode/skills/` | `.claude/skills/` | `.agents/skills/` |
