# skill-zzoft

Skills personalizadas de OpenCode para los proyectos del CITE - Zzoft.

## Skills incluidas

| Skill | Descripcion | Tecnologia |
|-------|-------------|------------|
| `dotnet-clean-cqrs` | Genera microservicios .NET 9.0 con Clean Architecture y CQRS | C# / .NET 9.0 |
| `java-hexagonal-secure` | Genera servicios Java Spring Boot con Arquitectura Hexagonal y config segura de BD | Java / Spring Boot |

## Instalacion rapida

```bash
# Clonar el repositorio
git clone https://github.com/ozambelachota/skill-zzoft.git

# Copiar skills al directorio global de OpenCode
# Linux/Mac:
cp -r skill-zzoft/skills/* ~/.config/opencode/skills/

# Windows (PowerShell):
Copy-Item -Recurse skill-zzoft\skills\* $env:USERPROFILE\.config\opencode\skills\
```

## Documentacion

La guia completa de instalacion y uso esta disponible en la [Wiki del repositorio](https://github.com/ozambelachota/skill-zzoft/wiki).

## Estructura del repositorio

```
skill-zzoft/
├── README.md
├── skills/
│   ├── dotnet-clean-cqrs/
│   │   ├── SKILL.md
│   │   └── assets/
│   │       └── docker-build.sh
│   └── java-hexagonal-secure/
│       ├── SKILL.md
│       └── references/
│           └── structure.md
└── wiki/
    ├── Home.md
    ├── Guia-de-Instalacion.md
    ├── Skill-dotnet-clean-cqrs.md
    └── Skill-java-hexagonal-secure.md
```

## Licencia

Uso interno - Zzoft / CITE.
