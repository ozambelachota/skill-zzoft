# Skill: java-hexagonal-secure

Genera servicios Java Spring Boot con Arquitectura Hexagonal (Ports & Adapters) y configuracion segura de base de datos.

**Compatible con:** OpenCode | Claude Code | Codex

## Cuando se activa

La skill se activa automaticamente cuando le pedis al agente:

- Crear un nuevo servicio Java Spring Boot
- Refactorizar un servicio existente a Arquitectura Hexagonal
- Configurar acceso a base de datos o cambios de schema en Java

### Invocacion manual

| Agente | Comando |
|--------|---------|
| OpenCode | `/skill` y seleccionar `java-hexagonal-secure` |
| Claude Code | `/java-hexagonal-secure` |
| Codex | `$java-hexagonal-secure` |

---

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

---

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

### Ejemplo de migracion Flyway

```sql
-- V1__create_products_table.sql
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Dependencias estandar

| Dependencia | Proposito |
|-------------|-----------|
| `spring-boot-starter-web` | REST API |
| `spring-boot-starter-data-jpa` | Persistencia |
| `spring-boot-starter-validation` | Validacion de DTOs |
| `spring-boot-starter-security` | Autenticacion (si aplica) |
| `lombok` | Reducir boilerplate |
| `postgresql` | Driver de BD (o el que corresponda) |
| `flyway-core` | Migraciones de BD |

---

## Reglas de pureza del Domain

- El paquete `domain` **NO** debe depender de Spring ni de librerias de persistencia
- Se prefiere separar Domain Models de JPA Entities usando **Mappers**

### Ejemplo: Separacion Domain Model vs JPA Entity

```java
// domain/model/Product.java - Puro, sin JPA
public class Product {
    private Long id;
    private String name;
    private BigDecimal price;

    public void applyDiscount(BigDecimal percentage) {
        this.price = this.price.multiply(
            BigDecimal.ONE.subtract(percentage)
        );
    }
}
```

```java
// infrastructure/adapter/output/persistence/entity/ProductEntity.java
@Entity
@Table(name = "products")
@Data
@NoArgsConstructor
public class ProductEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private BigDecimal price;

    public Product toDomain() {
        return new Product(id, name, price);
    }

    public static ProductEntity fromDomain(Product p) {
        ProductEntity entity = new ProductEntity();
        entity.setId(p.getId());
        entity.setName(p.getName());
        entity.setPrice(p.getPrice());
        return entity;
    }
}
```

### Ejemplo: Puerto e implementacion

```java
// application/port/output/ProductRepository.java (Puerto)
public interface ProductRepository {
    Product save(Product product);
    Optional<Product> findById(Long id);
    List<Product> findAll();
}
```

```java
// infrastructure/adapter/output/persistence/ProductRepositoryAdapter.java
@Component
@RequiredArgsConstructor
public class ProductRepositoryAdapter implements ProductRepository {
    private final JpaProductRepository jpaRepository;

    @Override
    public Product save(Product product) {
        ProductEntity entity = ProductEntity.fromDomain(product);
        return jpaRepository.save(entity).toDomain();
    }

    @Override
    public Optional<Product> findById(Long id) {
        return jpaRepository.findById(id).map(ProductEntity::toDomain);
    }

    @Override
    public List<Product> findAll() {
        return jpaRepository.findAll().stream()
            .map(ProductEntity::toDomain)
            .collect(Collectors.toList());
    }
}
```

---

## Ejemplos de uso

### Ejemplo basico

```
Crea un microservicio Java Spring Boot para el modulo de ventas
con arquitectura hexagonal. Usa PostgreSQL como base de datos.
```

### Ejemplo avanzado

```
Necesito un servicio Java para gestionar el inventario de madera comercial.
Debe tener:
- Entidad MaderaComercial con: id, especie, volumen, calidad, lote
- Arquitectura hexagonal con puertos y adaptadores
- PostgreSQL con Flyway para migraciones
- Endpoints: crear, listar, buscar por especie, actualizar calidad
- No usar ddl-auto=update
```

### Lo que el agente genera

1. Estructura de paquetes hexagonal completa
2. Solicitar los scripts SQL de inicializacion
3. Entidades de dominio SIN dependencias de framework
4. Puertos (interfaces) en application
5. Adaptadores en infrastructure con JPA entities separadas
6. Configurar `application.yml` con `ddl-auto: validate`
7. Controllers REST en infrastructure/adapter/input
