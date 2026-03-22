---
name: java-clean-cqrs-zzoft
description: >
  Generates Java Spring Boot microservices following Clean Architecture (Hexagonal) and CQRS patterns adapted for Zzoft (YALI).
  Trigger: When user asks to create a Java service, use Clean Architecture for Zzoft/YALI, or implement CQRS.
license: Apache-2.0
metadata:
  author: harold
  version: "1.0"
---

## When to Use

- Creating new Java Spring Boot microservices for Zzoft / YALI projects.
- Refactoring existing Java applications to Hexagonal/Clean Architecture.
- Implementing CQRS pattern (Segregating Input/Output Ports).

## Critical Patterns

### 1. Hexagonal/Clean Architecture Structure

Must follow this folder structure exactly:

- `domain/model`: Domain Entities (e.g., `Company.java`, `Store.java`). No Spring dependencies here.
- `application/port/in`: Input Ports (Use Case interfaces) for CQRS commands and queries (e.g., `CreateCompanyUseCase.java`, `GetCompanyUseCase.java`).
- `application/port/out`: Output Ports (Repository interfaces) (e.g., `CompanyRepositoryPort.java`).
- `application/service`: Use Case Implementations. Classes annotated with `@Service` implementing the Input Ports.
- `infrastructure/adapter/rest`: Web Controllers (`@RestController`), DTOs (Request/Response/Data/Metadata wrappers), and Builders/Mappers.
- `infrastructure/adapter/rest/exception`: Global exception handlers and custom exceptions.
- `infrastructure/adapter/persistence`: JPA Entities (`@Entity`), Spring Data Repositories, and Repository Adapters that implement the Output Ports.
- `infrastructure/config`: Configuration classes (e.g., OpenAPI, WebConfig, Constants).

### 2. CQRS Pattern (Port/Adapter Style)

- **Commands (Write Operations)**: Use specific use case interfaces (e.g., `CreateCompanyUseCase`, `UpdateCompanyUseCase`). Modifies state.
- **Queries (Read Operations)**: Use specific use case interfaces (e.g., `GetCompanyUseCase`, `GetAllCompanyUseCase`). Reads state.
- **Services**: Group related use cases in a single service class (e.g., `CompanyService implements CreateCompanyUseCase, GetCompanyUseCase`).
- **REST Response Wrapper**: Always wrap responses with `Metadata` (status, message) and `Data` objects.

### 3. Frameworks & Libraries

- **Spring Boot**: For DI, REST, JPA.
- **Lombok**: Use `@Getter`, `@Setter`, `@Builder`, `@AllArgsConstructor`, `@NoArgsConstructor` to reduce boilerplate.
- **OpenAPI/Swagger**: Annotate controllers with `@Operation`, `@ApiResponse`, `@Schema`.
- **Mappers**: Entities should have `toDomain()` and `fromDomain(DomainModel model)` methods, or use static builders.

## Code Examples

### Domain Model

```java
package com.yali.app.company.domain.model;

import java.util.UUID;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Company {
    private UUID id;
    private String nombre;
    private String estado;
    // ...
}
```

### Input Port (Use Case)

```java
package com.yali.app.company.application.port.in;

import com.yali.app.company.domain.model.Company;
import java.util.UUID;

public interface GetCompanyUseCase {
    Company getCompany(UUID id);
}
```

### Service Implementation

```java
package com.yali.app.company.application.service;

import com.yali.app.company.application.port.in.CreateCompanyUseCase;
import com.yali.app.company.application.port.in.GetCompanyUseCase;
import com.yali.app.company.application.port.out.CompanyRepositoryPort;
import com.yali.app.company.domain.model.Company;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class CompanyService implements GetCompanyUseCase, CreateCompanyUseCase {
  
    private final CompanyRepositoryPort repository;

    public CompanyService(CompanyRepositoryPort repository) {
        this.repository = repository;
    }

    @Override
    public Company getCompany(UUID id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Company not found"));
    }

    @Override
    public Company createCompany(Company company) {
        return repository.save(company);
    }
}
```

### Controller

```java
package com.yali.app.company.infrastructure.adapter.rest;

import com.yali.app.company.application.port.in.GetCompanyUseCase;
import com.yali.app.company.domain.model.Company;
import io.swagger.v3.oas.annotations.Operation;
import java.util.UUID;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/companys")
public class CompanyController {

    private final GetCompanyUseCase getCompanyUseCase;

    public CompanyController(GetCompanyUseCase getCompanyUseCase) {
        this.getCompanyUseCase = getCompanyUseCase;
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener una Empresa por ID")
    public ResponseEntity<CompanyResponseDto> getCompany(@PathVariable("id") UUID id) {
        Company company = getCompanyUseCase.getCompany(id);
        
        Metadata metadata = new Metadata("200", "Company found");
        CompanyData data = new CompanyData(CompanyBuilder.buildCompanyResponse(company));
        
        return ResponseEntity.ok(new CompanyResponseDto(metadata, data));
    }
}
```

### Persistence Adapter

```java
package com.yali.app.company.infrastructure.adapter.persistence;

import com.yali.app.company.domain.model.Company;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;
import lombok.*;

@Entity
@Table(name = "companys")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CompanyEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;
    private String nombre;
    private LocalDateTime fechaCreacion;

    @PrePersist
    public void prePersist() {
        this.fechaCreacion = LocalDateTime.now();
    }

    public Company toDomain() {
        Company company = new Company();
        company.setId(this.id);
        company.setNombre(this.nombre);
        return company;
    }

    public static CompanyEntity fromDomain(Company company) {
        return CompanyEntity.builder()
            .id(company.getId())
            .nombre(company.getNombre())
            .build();
    }
}
```
