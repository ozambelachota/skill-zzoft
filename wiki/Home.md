# Skills Zzoft - Wiki

Bienvenido a la documentacion de las skills personalizadas de OpenCode para los proyectos del CITE.

## Que es una Skill de OpenCode?

Una skill es un paquete modular que extiende las capacidades del agente de IA (OpenCode/Claude Code) con conocimiento especializado, workflows y herramientas. Pensalo como una "guia de onboarding" para un dominio especifico: transforma al agente de proposito general en un agente especializado.

### Que proveen las Skills?

- **Workflows especializados**: Procedimientos multi-paso para dominios especificos
- **Conocimiento de dominio**: Patrones de arquitectura, convenciones y reglas del equipo
- **Recursos empaquetados**: Scripts, referencias y templates reutilizables

## Skills disponibles

| Skill | Descripcion | Pagina |
|-------|-------------|--------|
| `dotnet-clean-cqrs` | Microservicios .NET 9.0 con Clean Architecture + CQRS | [Ver documentacion](Skill-dotnet-clean-cqrs) |
| `java-hexagonal-secure` | Java Spring Boot con Hexagonal Architecture + DB segura | [Ver documentacion](Skill-java-hexagonal-secure) |

## Guias

- [Guia de Instalacion paso a paso (Windows, Mac, Linux)](Guia-de-Instalacion)

## Como se activan las Skills?

Las skills se activan **automaticamente** cuando el agente detecta contexto relevante. Por ejemplo:

- Si le pedis "crea un microservicio en .NET con CQRS", se activa `dotnet-clean-cqrs`
- Si le pedis "crea un servicio Java con arquitectura hexagonal", se activa `java-hexagonal-secure`

Tambien podes activarlas manualmente desde OpenCode escribiendo `/skill` y seleccionando la que necesites.

## Estructura de una Skill

```
nombre-skill/
├── SKILL.md          # Archivo principal (requerido)
├── assets/           # Templates, scripts de build, etc.
├── references/       # Documentacion de referencia
└── scripts/          # Scripts ejecutables
```
