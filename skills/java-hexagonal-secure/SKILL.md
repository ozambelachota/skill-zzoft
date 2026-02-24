---
name: java-hexagonal-secure
description: Generates Java Spring Boot projects with Hexagonal Architecture and enforced secure database configuration. Use when creating or modifying Java services to ensure architectural compliance and secure DB handling.
---

# Java Hexagonal Secure Skill

## Overview

This skill guides the creation and modification of Java Spring Boot microservices, enforcing:
1.  **Hexagonal Architecture (Ports & Adapters)**: Strict separation of Domain, Application, and Infrastructure layers.
2.  **Secure Database Configuration**: Mandatory provision of database initialization scripts (SQL) to prevent uncontrolled schema generation.

## When to Use

- When creating a new Java Spring Boot service.
- When refactoring an existing service to Hexagonal Architecture.
- When configuring database access or schema changes.

## Workflow

### 1. Project Scaffolding (Hexagonal)

Adhere to the following package structure (based on the `yali` reference):

- `com.<company>.<app>.<service>.domain`: Core business logic (Entities, Value Objects). **No Framework Dependencies.**
- `com.<company>.<app>.<service>.application`:
    - `port`: Interfaces defining input (driving) and output (driven) ports.
    - `service`: Implementation of input ports (Use Cases).
- `com.<company>.<app>.<service>.infrastructure`:
    - `adapter`: Implementations of output ports (Repositories, External APIs) and Input Adapters (Controllers).
    - `config`: Spring configuration classes.

**Reference:** See [STRUCTURE.md](references/structure.md) for the detailed file tree.

### 2. Secure Database Configuration

**CRITICAL:** Do NOT rely on `spring.jpa.hibernate.ddl-auto=update` or `create` for production-ready services.

1.  **Request Scripts:** Explicitly ask the user for the SQL initialization scripts (DDL & DML).
    > "Please provide the `schema.sql` and `data.sql` (if applicable) scripts to securely initialize the database."
2.  **Placement:** Store scripts in `src/main/resources/db/migration` (if using Flyway) or `src/main/resources/sql` (if manual).
3.  **Verification:** Verify that `application.yml` is configured to use these scripts or that the user acknowledges the manual execution process.

### 3. Dependencies

Ensure the following standard dependencies are considered:
- `spring-boot-starter-web`
- `spring-boot-starter-data-jpa`
- `spring-boot-starter-validation`
- `spring-boot-starter-security` (if auth required)
- `lombok`
- `postgresql` (or relevant driver)

## Rules

- **Domain Purity:** The domain package must not depend on Spring or Persistence libraries (JPA annotations are acceptable *only* if pragmatically unavoidable, but prefer separating Domain Models from JPA Entities via Mappers).
- **Explicit Configuration:** Avoid "magic" defaults where security is concerned.