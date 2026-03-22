# Java Clean Architecture (Hexagonal) & CQRS for Zzoft / YALI

Esta skill ha sido diseñada específicamente para generar y mantener microservicios en Java (Spring Boot) siguiendo los estándares y convenciones de los proyectos YALI / Zzoft de la empresa.

## Características Principales

1. **Arquitectura Hexagonal (Clean Architecture)**:
   Alinea completamente la estructura de carpetas a:
   - `domain/model`: Lógica de negocio pura.
   - `application/port/in`: Interfaces de casos de uso separados (Comandos y Consultas).
   - `application/port/out`: Interfaces de repositorios (Puertos de salida).
   - `application/service`: Implementaciones de los casos de uso.
   - `infrastructure/adapter/rest`: Controladores web, manejo de errores y DTOs envolventes (`Metadata`, `Data`).
   - `infrastructure/adapter/persistence`: Entidades JPA, mappers (`toDomain`, `fromDomain`) y repositorios Spring Data.

2. **Patrón CQRS**:
   Separación estricta de las operaciones de lectura y escritura a través de puertos específicos (ej. `CreateCompanyUseCase`, `GetCompanyUseCase`).

3. **Estandarización de Respuestas**:
   Todo controlador retorna los datos envueltos en un objeto base con estado y mensaje (`Metadata`) y un bloque de datos (`Data`), como se acostumbra en los proyectos YALI.

## ¿Cómo utilizar esta skill?

Si utilizas **OpenCode**, el asistente cargará automáticamente esta skill si le indicas que:
> "Crea un nuevo servicio Java utilizando Clean Architecture para Zzoft"
> "Aplica el patrón CQRS de YALI en este controlador"

También puedes llamarla manualmente usando la sintaxis de OpenCode para importar la skill `java-clean-cqrs-zzoft`.