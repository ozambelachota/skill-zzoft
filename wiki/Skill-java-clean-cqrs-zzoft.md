# Skill: Java Clean CQRS (Zzoft / YALI)

Esta skill ha sido generada para unificar la forma en la que los agentes de IA redactan y estructuran código Java para la empresa **Zzoft** en sus proyectos **YALI**.

## ¿Qué incluye?

- **Estructura de Carpetas:** Asegura que los archivos se depositen bajo un patrón rígido de Arquitectura Hexagonal (`domain`, `application`, `infrastructure`).
- **Nomenclatura y Convenciones:** Forza el uso de interfaces sufijadas en `UseCase` y `RepositoryPort`.
- **Envoltorios (Wrappers):** Las respuestas REST son siempre encapsuladas en `Metadata` y `Data` respetando los códigos HTTP predefinidos (`Constants.HTTP_STATUS_OK`).
- **CQRS:** Obliga a separar conceptualmente las escrituras (Commands) de las lecturas (Queries) al nivel de puertos de entrada (`application/port/in`).

## Instalación

Solo necesitas tener este repositorio cargado en tus Skills de OpenCode y el agente activará este comportamiento cuando hables de "Java", "Yali" o "Clean Architecture" para este contexto de negocio.