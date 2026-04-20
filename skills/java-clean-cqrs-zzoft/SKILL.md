---
name: java-clean-cqrs-zzoft
description: >
  Generates Java 21 + Spring Boot 4.x microservices for Zzoft/ForestChain using strict Clean Architecture + CQRS + reactive WebFlux/R2DBC.
  Trigger: When creating/refactoring Java microservices with domain/application/infrastructure boundaries, command-query separation, and non-blocking flows.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "4.0"
---

## When to Use

- Building or refactoring ForestChain/Zzoft microservices with Spring Boot `4.x` and Java `21`.
- Enforcing Clean Architecture boundaries (`domain`, `application`, `infrastructure`) and CQRS.
- Designing reactive REST APIs (`WebFlux`) with reactive persistence (`R2DBC + PostgreSQL`).
- Standardizing response contracts (`ApiResponse + Metadata`) and global exception mapping.

## Critical Patterns

### 1) Mandatory Pre-Flight: Validate Baseline FIRST

Before generating code, inspect `build.gradle` or `build.gradle.kts`:

| Validation | Expected | Action if missing |
|---|---|---|
| Spring Boot plugin | `org.springframework.boot` | Stop generation and align first |
| Boot version | `4.x` | Upgrade/downgrade to approved baseline |
| Java version | `21` | Align toolchain/source compatibility |
| Reactive web stack | `spring-boot-starter-webflux` | Add dependency |
| Reactive data stack | `spring-boot-starter-data-r2dbc` + `r2dbc-postgresql` | Add dependencies |
| Validation | `spring-boot-starter-validation` | Add dependency |
| Blocking stack in request flow | no JDBC/JPA in reactive flow | Remove or isolate blocking adapters |

Non-negotiable rule: if baseline is wrong, DO NOT scaffold handlers/controllers yet.

### 2) Mandatory Package Structure (ForestChain Reference)

Use this structure as default:

- `domain/model` -> entities and value objects, no Spring annotations.
- `domain/repository` -> repository contracts (ports), framework-free interfaces.
- `application/command` -> immutable command records.
- `application/query` -> immutable query records.
- `application/handler` -> command/query handlers (use-case orchestration).
- `application/exception` -> application-level exceptions.
- `infrastructure/web/controller` -> separate command controllers and query controllers.
- `infrastructure/web/dto/request` -> request DTOs with boundary validation.
- `infrastructure/web/dto/response` -> response DTOs and wrappers.
- `infrastructure/web/mapper` -> domain <-> web DTO mapping.
- `infrastructure/web/exception` -> `GlobalExceptionHandler`.
- `infrastructure/persistence/entity` -> DB entities.
- `infrastructure/persistence/repository` -> Spring Data R2DBC repositories.
- `infrastructure/persistence/mapper` -> domain <-> persistence mapping.
- `infrastructure/persistence/adapter` -> repository adapter implementations.
- `infrastructure/config` -> OpenAPI, CORS, DB init, client beans.
- `shared` -> constants and cross-cutting shared helpers.

### 3) Dependency Rule (Strict)

| Layer | Can depend on |
|---|---|
| `domain/*` | Java standard library only |
| `application/*` | `domain/*` |
| `infrastructure/*` | `application/*`, `domain/*` |

Never invert this direction. Domain never imports Spring, R2DBC, Swagger, or HTTP classes.

### 4) CQRS Naming and Separation Rules

- Commands: `Create<Entity>Command`, `Update<Entity>Command`, `Delete<Entity>Command`.
- Queries: `Get<Entity>ByIdQuery`, `GetAll<Entity>sQuery`, `Search<Entity>sQuery`.
- Handlers: `<Entity>CommandHandler`, `<Entity>QueryHandler`.
- Controllers: `<Entity>CommandController` for `POST/PUT/DELETE`, `<Entity>QueryController` for `GET`.
- Do not mix command and query responsibilities in one handler method.

### 5) Reactive-Only Rule (NO BLOCKING)

- Use `Mono<T>`/`Flux<T>` end-to-end in handlers, adapters, and controllers.
- Forbidden in request flow: `.block()`, `.toFuture().get()`, `Thread.sleep`, blocking JDBC/JPA.
- Use explicit operators: `map`, `flatMap`, `switchIfEmpty`, `defaultIfEmpty`, `onErrorMap`, `zip`.
- For not-found semantics, use `switchIfEmpty(Mono.error(...))`.

### 6) Persistence and Data Model Standards

- PostgreSQL with R2DBC and snake_case schema naming.
- IDs should use `UUID` (DB-generated when possible, e.g., `gen_random_uuid()`).
- Soft delete standard: `estado VARCHAR(1)` with `'1'` active and `'0'` inactive.
- Include audit fields when required: `usuario_creacion`, `fecha_creacion`, `usuario_modificacion`, `fecha_modificacion`.
- Keep persistence entities in infrastructure only; never leak them into domain or application.

### 7) API Contract Standards

- Successful responses should be wrapped in `ApiResponse<T>` with `metadata` and `data`.
- Error responses should use a standardized `ErrorResponse` payload.
- Typical status mapping: `201` create, `200` read/update, `204` delete, `404` not found, `422` business rule violation.
- Request DTO validation at boundary (`@Valid`, Jakarta validation annotations).

### 8) Integration Policy Between Microservices

- Default and preferred synchronous integration: reactive `WebClient` adapter in `infrastructure`.
- For new integrations, prefer typed HTTP interfaces with `@HttpExchange` backed by `WebClient`.
- Always define an outbound contract in `domain/repository` or dedicated application port interface.
- Configure timeout, retry, and error mapping in adapter/config layer.
- Map remote DTOs to domain-safe models before they reach handlers.
- Kafka is optional by architecture decision: only generate event publishing/consumption when explicitly required by the use case; prefer Outbox pattern for reliability.

### 9) Docker and Operability Baseline

- New microservices must include `Dockerfile` and `docker-compose.yml` examples.
- Expose `8080` in container and map externally as needed.
- Include actuator health endpoint and document access URLs.

## Code Examples

### A) Command and Query Records

```java
package com.forestchain.catalogo_service.application.command;

import java.util.UUID;

public record CreateCatalogCommand(UUID companyId, String name, String status) {
}
```

```java
package com.forestchain.catalogo_service.application.query;

import java.util.UUID;

public record GetCatalogByIdQuery(UUID id) {
}
```

### B) Reactive Query Handler Pattern

```java
package com.forestchain.catalogo_service.application.handler;

import com.forestchain.catalogo_service.application.exception.CatalogNotFoundException;
import com.forestchain.catalogo_service.application.query.GetCatalogByIdQuery;
import com.forestchain.catalogo_service.domain.model.Catalog;
import com.forestchain.catalogo_service.domain.repository.CatalogRepository;
import reactor.core.publisher.Mono;

public class CatalogQueryHandler {

    private final CatalogRepository catalogRepository;

    public CatalogQueryHandler(CatalogRepository catalogRepository) {
        this.catalogRepository = catalogRepository;
    }

    public Mono<Catalog> handle(GetCatalogByIdQuery query) {
        return catalogRepository.findById(query.id())
            .switchIfEmpty(Mono.error(new CatalogNotFoundException(query.id())));
    }
}
```

### C) Response Wrapper Pattern

```java
package com.forestchain.catalogo_service.infrastructure.web.dto.response;

public record ApiResponse<T>(Metadata metadata, T data) {
}
```

### D) Command Controller / Query Controller Separation

```java
package com.forestchain.catalogo_service.infrastructure.web.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/catalogs")
public class CatalogCommandController {
    // POST/PUT/DELETE endpoints only
}
```

```java
package com.forestchain.catalogo_service.infrastructure.web.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/catalogs")
public class CatalogQueryController {
    // GET endpoints only
}
```

### E) WebClient Typed Client Pattern

```java
package com.forestchain.catalogo_service.infrastructure.client;

import org.springframework.web.service.annotation.GetExchange;
import org.springframework.web.service.annotation.HttpExchange;
import reactor.core.publisher.Mono;

@HttpExchange("/companies")
public interface CompanyHttpClient {
    @GetExchange("/{id}")
    Mono<CompanyClientResponse> getById(String id);
}
```

```java
package com.forestchain.catalogo_service.infrastructure.config;

import com.forestchain.catalogo_service.infrastructure.client.CompanyHttpClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.service.invoker.HttpServiceProxyFactory;
import org.springframework.web.service.invoker.WebClientAdapter;

@Configuration
public class CompanyClientConfig {

    @Bean
    CompanyHttpClient companyHttpClient(WebClient.Builder builder) {
        WebClient client = builder.baseUrl("http://company-service").build();
        HttpServiceProxyFactory factory = HttpServiceProxyFactory
            .builderFor(WebClientAdapter.create(client))
            .build();
        return factory.createClient(CompanyHttpClient.class);
    }
}
```

## Commands

```bash
# Validate baseline
./gradlew -q dependencies --configuration runtimeClasspath

# Run tests
./gradlew test

# Quality checks
./gradlew check

# Run locally
./gradlew bootRun
```

## Resources

- Project reference: `ForestChain.Catalogo.Api`.
- Architecture reference: `Arquitectura_Backend_FORESTCHAIN.docx`.
- Templates and checklists: see `assets/` and `references/`.
