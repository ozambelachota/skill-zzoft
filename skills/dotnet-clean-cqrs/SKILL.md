---
name: dotnet-clean-cqrs
description: >
  Generates .NET Core microservices following Clean Architecture and CQRS patterns.
  Trigger: When user asks to create a .NET service, use Clean Architecture, or implement CQRS.
license: Apache-2.0
metadata:
  author: harold
  version: "1.0"
---

## When to Use

- Creating new .NET microservices or APIs.
- Refactoring existing .NET applications to Clean Architecture.
- Implementing CQRS pattern (Commands and Queries segregation).
- Setting up Docker build scripts for .NET services.

## Critical Patterns

### 1. Clean Architecture Structure

Must follow this folder structure:

- `src/Domain`: Entities, Enums, Interfaces, Value Objects (No dependencies).
- `src/Application`: CQRS (Commands/Queries), DTOs, Interfaces, Validators (Depends on Domain).
- `src/Infrastructure`: Persistence (EF Core), External Services, File System (Depends on Application).
- `src/API`: Controllers, Middleware, Configuration (Depends on Application & Infrastructure).

### 2. CQRS Pattern

- **Commands**: Modify state. Must return `Result<T>` or `Unit`. Located in `Application/{Feature}/Commands`.
- **Queries**: Read state. Must return `Result<T>`. Located in `Application/{Feature}/Queries`.
- **Handlers**: Implement `IRequestHandler<TCommand, TResult>`.
- **Validation**: Use FluentValidation with MediatR pipeline behaviors.

### 3. Docker Support (MANDATORY)

- **ALWAYS** generate a `docker-build.sh` script in the project root.
- Use the template provided in `assets/docker-build.sh`.
- The script must support `build`, `run`, `stop`, `logs`, `clean` commands.

## Code Examples

### Command Handler

```csharp
public class CreateItemCommandHandler : IRequestHandler<CreateItemCommand, Result<int>>
{
    private readonly IRepository<Item> _repository;
    public CreateItemCommandHandler(IRepository<Item> repository) => _repository = repository;

    public async Task<Result<int>> Handle(CreateItemCommand request, CancellationToken token)
    {
        var item = new Item(request.Name);
        await _repository.AddAsync(item, token);
        return item.Id;
    }
}
```

### Query Handler

```csharp
public class GetItemQueryHandler : IRequestHandler<GetItemQuery, Result<ItemDto>>
{
    private readonly IReadRepository<Item> _repository;
    public GetItemQueryHandler(IReadRepository<Item> repository) => _repository = repository;

    public async Task<Result<ItemDto>> Handle(GetItemQuery request, CancellationToken token)
    {
        var item = await _repository.GetByIdAsync(request.Id, token);
        return item is null ? Result.Failure<ItemDto>(Error.NotFound) : item.ToDto();
    }
}
```

## Commands

```bash
# Create solution
dotnet new sln -n ProjectName

# Create projects
dotnet new classlib -n ProjectName.Domain
dotnet new classlib -n ProjectName.Application
dotnet new classlib -n ProjectName.Infrastructure
dotnet new webapi -n ProjectName.API

# Add references
dotnet add ProjectName.Application reference ProjectName.Domain
dotnet add ProjectName.Infrastructure reference ProjectName.Application
dotnet add ProjectName.API reference ProjectName.Application ProjectName.Infrastructure

# Add to solution
dotnet sln add **/*.csproj
```

## Resources

- **Docker Script Template**: See [assets/docker-build.sh](assets/docker-build.sh) for the mandatory build script.
