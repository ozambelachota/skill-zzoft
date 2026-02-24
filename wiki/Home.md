# Skills Zzoft - Wiki

Documentacion de las skills personalizadas para los proyectos del CITE.

Estas skills son compatibles con los 3 principales agentes de IA para desarrollo:

| Agente | Proveedor | Estandar |
|--------|-----------|----------|
| [OpenCode](https://github.com/sst/opencode) | Open Source | [Agent Skills](https://agentskills.io) |
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code/skills) | Anthropic | [Agent Skills](https://agentskills.io) |
| [Codex CLI](https://developers.openai.com/codex/skills) | OpenAI | [Agent Skills](https://agentskills.io) |

Los tres siguen el estandar abierto **Agent Skills** — el mismo archivo `SKILL.md` funciona en los tres agentes. Solo cambia la ruta donde se instalan.

## Skills disponibles

| Skill | Descripcion | Tecnologia |
|-------|-------------|------------|
| `dotnet-clean-cqrs` | Microservicios .NET 9.0 con Clean Architecture + CQRS | C# / .NET 9.0 |
| `java-hexagonal-secure` | Java Spring Boot con Hexagonal Architecture + DB segura | Java / Spring Boot |

## Paginas de la Wiki

- [Guia de Instalacion paso a paso](Guia-de-Instalacion) — Windows, macOS y Linux para OpenCode, Claude Code y Codex
- [Skill: dotnet-clean-cqrs](Skill-dotnet-clean-cqrs) — Documentacion y uso
- [Skill: java-hexagonal-secure](Skill-java-hexagonal-secure) — Documentacion y uso

## Repositorio de Skills

El codigo fuente de las skills esta en: [skill-zzoft](https://github.com/ozambelachota/skill-zzoft)

## Como se activan?

Las skills se activan **automaticamente** cuando el agente detecta contexto relevante en tu prompt:

```
# Esto activa dotnet-clean-cqrs automaticamente
"Crea un microservicio .NET con CQRS para gestionar productos"

# Esto activa java-hexagonal-secure automaticamente
"Crea un servicio Java Spring Boot con arquitectura hexagonal"
```

Tambien se pueden invocar manualmente:

| Agente | Invocacion manual |
|--------|-------------------|
| OpenCode | Escribir `/skill` y seleccionar |
| Claude Code | Escribir `/nombre-skill` o preguntar "que skills hay disponibles?" |
| Codex | Escribir `$nombre-skill` o `/skills` para listar |

## Estructura de una Skill

Todas las skills siguen esta estructura (estandar Agent Skills):

```
nombre-skill/
├── SKILL.md          # Instrucciones principales (REQUERIDO)
├── assets/           # Templates, scripts de build
├── references/       # Documentacion de referencia
└── scripts/          # Scripts ejecutables
```

El archivo `SKILL.md` debe tener frontmatter YAML con `name` y `description`:

```yaml
---
name: mi-skill
description: Que hace y cuando debe activarse.
---

Instrucciones para el agente...
```
