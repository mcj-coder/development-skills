# Reference: Strongly Typed IDs (Source Generation)

## Recommended library

- StronglyTypedId (open source, source generator)

## Minimal example

```csharp
using StronglyTypedIds;

[StronglyTypedId]
public partial struct CustomerId;
```

Usage in the domain:

```csharp
public sealed class Customer
{
    public CustomerId Id { get; }

    public Customer(CustomerId id) => Id = id;
}
```

Boundary conversions (explicit):

```csharp
Guid dbId = customer.Id.Value;
CustomerId id = CustomerId.From(dbId);
```

## Notes

- Prefer explicit boundary conversions over implicit operators.
- Treat serialization and persistence as adapters: the domain keeps strong types.
