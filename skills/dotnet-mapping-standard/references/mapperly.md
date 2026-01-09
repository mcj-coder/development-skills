# Reference: Source-Generated Mapping (Mapperly)

## Recommended library

- Mapperly (open source, source generator)

## Example: DTO -> Domain

```csharp
using Riok.Mapperly.Abstractions;

public sealed record CustomerDto(Guid Id, string Email, string Name);

public sealed class Customer
{
    public CustomerId Id { get; }
    public EmailAddress Email { get; }
    public string Name { get; }

    public Customer(CustomerId id, EmailAddress email, string name)
    {
        Id = id;
        Email = email;
        Name = name;
    }
}

[Mapper]
public partial class CustomerMapper
{
    public partial Customer Map(CustomerDto dto);

    private static CustomerId Map(Guid id) => CustomerId.From(id);
    private static EmailAddress Map(string email) => EmailAddress.From(email);
}
```

## Example: Domain -> DTO (reciprocal)

```csharp
[Mapper]
public partial class CustomerMapper
{
    public partial CustomerDto Map(Customer customer);

    private static Guid Map(CustomerId id) => id.Value;
    private static string Map(EmailAddress email) => email.Value;
}
```

## Static mapper preferred (no customisation)

If there is **no customisation** of the mapping logic (no injected dependencies, no runtime
state), prefer a **static mapper** so there is no need to instantiate a mapper type or
register it in DI.

```csharp
[Mapper]
public static partial class CustomerMapper
{
    public static partial CustomerDto ToDto(Customer customer);
    public static partial Customer FromDto(CustomerDto dto);

    private static Guid Map(CustomerId id) => id.Value;
    private static CustomerId Map(Guid id) => CustomerId.From(id);

    private static string Map(EmailAddress email) => email.Value;
    private static EmailAddress Map(string email) => EmailAddress.From(email);
}
```

Call site:

```csharp
var dto = CustomerMapper.ToDto(customer);
```

## Only inject when the mapper has injected dependencies

Inject a mapper only if the mapper itself depends on external collaborators (tenant/user
context, clock, lookups, feature flags/options). Otherwise, keep mapping static/pure.

### Review heuristic: mapper DI gating

- If you see an injected mapper, verify the mapper has constructor dependencies.
- If it does not, remove DI usage and convert to a static mapper.
