# Skill: java-hexagonal-secure

Genera servicios Java Spring Boot con Arquitectura Hexagonal (Ports & Adapters) y configuracion segura de base de datos.

## Cuando se activa

- Cuando pedis crear un nuevo servicio Java Spring Boot
- Cuando pedis refactorizar un servicio existente a Arquitectura Hexagonal
- Cuando pedis configurar acceso a base de datos o cambios de schema

## Arquitectura que genera

La skill fuerza la estructura de paquetes Hexagonal (Ports & Adapters):

```
src/main/java/com/<empresa>/<app>/<servicio>
├── MsServiceApplication.java
├── domain/
│   └── model/
│       └── (Entidades, Value Objects)
├── application/
│   ├── port/
│   │   ├── input/    (Puertos Driving - interfaces de entrada)
│   │   └── output/   (Puertos Driven - interfaces de salida)
│   └── service/
│       └── (Implementacion de Use Cases)
└── infrastructure/
    ├── adapter/
    │   ├── input/    (Controllers, Queue Listeners)
    │   └── output/   (JPA Repositories, Feign Clients)
    ├── config/
    │   └── (Configuracion Spring)
    └── util/
```

### Regla de dependencias

```
Infrastructure (Adapters)
    |
    v
Application (Ports + Services)
    |
    v
Domain (Entities, Value Objects)
```

- **Domain**: SIN dependencias de frameworks. Logica de negocio pura.
- **Application**: Define los puertos (interfaces). Implementa los use cases.
- **Infrastructure**: Implementa los puertos con tecnologias concretas (JPA, REST, etc).

## Configuracion segura de BD (CRITICO)

La skill **prohibe** usar `spring.jpa.hibernate.ddl-auto=update` o `create` en servicios de produccion.

### Flujo obligatorio

1. **Solicitar scripts SQL** al usuario (DDL y DML)
2. **Ubicar scripts** segun el approach:
   - Con **Flyway**: `src/main/resources/db/migration/`
   - Manual: `src/main/resources/sql/`
3. **Verificar** que `application.yml` referencia los scripts

### Ejemplo de configuracion con Flyway

```yaml
# application.yml
spring:
  jpa:
    hibernate:
      ddl-auto: validate  # SOLO validar, NUNCA update/create
  flyway:
    enabled: true
    locations: classpath:db/migration
```

## Dependencias estandar

| Dependencia | Proposito |
|-------------|-----------|
| `spring-boot-starter-web` | REST API |
| `spring-boot-starter-data-jpa` | Persistencia |
| `spring-boot-starter-validation` | Validacion de DTOs |
| `spring-boot-starter-security` | Autenticacion (si aplica) |
| `lombok` | Reducir boilerplate |
| `postgresql` | Driver de BD (o el que corresponda) |

## Reglas de pureza del Domain

- El paquete `domain` **NO** debe depender de Spring ni de librerias de persistencia
- Las anotaciones JPA son aceptables SOLO si es pragmaticamente inevitable
- Se prefiere separar Domain Models de JPA Entities usando **Mappers**

### Ejemplo: Separacion Domain Model vs JPA Entity

```java
// domain/model/Product.java - Puro, sin JPA
public class Product {
    private Long id;
    private String name;
    private BigDecimal price;

    // Constructor, getters, logica de negocio
    public void applyDiscount(BigDecimal percentage) {
        this.price = this.price.multiply(
            BigDecimal.ONE.subtract(percentage)
        );
    }
}

// infrastructure/adapter/output/persistence/entity/ProductEntity.java
@Entity
@Table(name = "products")
public class ProductEntity {
    @Id @GeneratedValue
    private Long id;
    private String name;
    private BigDecimal price;

    // Mappers
    public Product toDomain() { ... }
    public static ProductEntity fromDomain(Product p) { ... }
}
```

## Ejemplo de uso con OpenCode

```
Prompt: "Crea un microservicio Java Spring Boot para el modulo de ventas
con arquitectura hexagonal. Usa PostgreSQL como base de datos."
```

La skill va a:

1. Crear la estructura de paquetes hexagonal
2. Pedir los scripts SQL de inicializacion de la BD
3. Generar las entidades de dominio SIN dependencias de framework
4. Crear los puertos (interfaces) en application
5. Implementar los adaptadores en infrastructure
6. Configurar `application.yml` con `ddl-auto: validate`
