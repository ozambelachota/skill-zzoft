# Skill: dotnet-clean-cqrs

Genera microservicios .NET 9.0 siguiendo Clean Architecture y el patron CQRS (Command Query Responsibility Segregation).

## Cuando se activa

- Cuando pedis crear un nuevo microservicio o API en .NET
- Cuando pedis refactorizar una app .NET existente a Clean Architecture
- Cuando pedis implementar el patron CQRS
- Cuando pedis configurar Docker para un servicio .NET

## Arquitectura que genera

La skill fuerza la siguiente estructura de carpetas:

```
src/
├── Domain/           # Entidades, Enums, Interfaces, Value Objects
│                     # SIN dependencias externas
├── Application/      # CQRS (Commands/Queries), DTOs, Interfaces, Validators
│                     # Depende de: Domain
├── Infrastructure/   # Persistencia (EF Core), Servicios Externos
│                     # Depende de: Application
└── API/              # Controllers, Middleware, Configuracion
                      # Depende de: Application + Infrastructure
```

### Regla de dependencias

```
API --> Infrastructure --> Application --> Domain
                              |
                              v
                           Domain
```

- **Domain** no depende de NADA
- **Application** solo depende de Domain
- **Infrastructure** depende de Application (y por transitividad de Domain)
- **API** depende de Application e Infrastructure

## Patron CQRS

### Commands (Escritura)

Modifican estado. Se ubican en `Application/{Feature}/Commands`.

```csharp
public class CreateItemCommand : IRequest<Result<int>>
{
    public string Name { get; set; }
}

public class CreateItemCommandHandler : IRequestHandler<CreateItemCommand, Result<int>>
{
    private readonly IRepository<Item> _repository;

    public CreateItemCommandHandler(IRepository<Item> repository)
        => _repository = repository;

    public async Task<Result<int>> Handle(
        CreateItemCommand request,
        CancellationToken token)
    {
        var item = new Item(request.Name);
        await _repository.AddAsync(item, token);
        return item.Id;
    }
}
```

### Queries (Lectura)

Solo leen estado. Se ubican en `Application/{Feature}/Queries`.

```csharp
public class GetItemQuery : IRequest<Result<ItemDto>>
{
    public int Id { get; set; }
}

public class GetItemQueryHandler : IRequestHandler<GetItemQuery, Result<ItemDto>>
{
    private readonly IReadRepository<Item> _repository;

    public GetItemQueryHandler(IReadRepository<Item> repository)
        => _repository = repository;

    public async Task<Result<ItemDto>> Handle(
        GetItemQuery request,
        CancellationToken token)
    {
        var item = await _repository.GetByIdAsync(request.Id, token);
        return item is null
            ? Result.Failure<ItemDto>(Error.NotFound)
            : item.ToDto();
    }
}
```

### Validacion

Se usa **FluentValidation** con pipeline behaviors de **MediatR**.

## Comandos para crear el proyecto desde cero

```bash
# Crear solucion
dotnet new sln -n MiProyecto

# Crear proyectos por capa
dotnet new classlib -n MiProyecto.Domain
dotnet new classlib -n MiProyecto.Application
dotnet new classlib -n MiProyecto.Infrastructure
dotnet new webapi -n MiProyecto.API

# Agregar referencias entre capas
dotnet add MiProyecto.Application reference MiProyecto.Domain
dotnet add MiProyecto.Infrastructure reference MiProyecto.Application
dotnet add MiProyecto.API reference MiProyecto.Application MiProyecto.Infrastructure

# Agregar todos los proyectos a la solucion
dotnet sln add **/*.csproj
```

## Docker (obligatorio)

La skill SIEMPRE genera un script `docker-build.sh` en la raiz del proyecto con los comandos:

| Comando | Descripcion |
|---------|-------------|
| `./docker-build.sh build` | Construir la imagen Docker |
| `./docker-build.sh run` | Ejecutar el contenedor |
| `./docker-build.sh stop` | Detener el contenedor |
| `./docker-build.sh logs` | Ver logs del contenedor |
| `./docker-build.sh clean` | Limpiar contenedores e imagenes |

## Ejemplo de uso con OpenCode

```
Prompt: "Crea un microservicio en .NET 9 para gestionar el inventario de productos
con Clean Architecture y CQRS. Necesito CRUD completo con validaciones."
```

La skill va a:

1. Crear la estructura de carpetas de Clean Architecture
2. Generar las entidades en Domain
3. Crear Commands y Queries en Application
4. Implementar el repositorio con EF Core en Infrastructure
5. Crear los Controllers en API
6. Generar el `docker-build.sh`
