# Reference: Specification Pattern

## Recommended library

- Ardalis.Specification (open source)

## Example

```csharp
using Ardalis.Specification;

public sealed class ActiveCustomersSpec : Specification<Customer>
{
    public ActiveCustomersSpec()
    {
        Query.Where(c => c.IsActive);
    }
}
```

Usage:

```csharp
var customers = await repository.ListAsync(new ActiveCustomersSpec(), cancellationToken);
```

## Notes

- Prefer composing specs over scattering LINQ throughout handlers/controllers.
- Keep IQueryable usage inside infrastructure boundaries where practical.
