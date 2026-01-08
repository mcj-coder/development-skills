# C# 11 Best Practices (.NET 7) — Delta vs C# 10

## Standards added or changed

- Prefer `required` for configuration/options and DTOs that must be initialized.
- Prefer raw string literals for embedded JSON/regex/templates to reduce escaping bugs.
- Prefer list patterns where they increase clarity over manual indexing.
- Use `file` types for helpers intended to be private to a single file.

## New language patterns

### `required` members

```csharp
public sealed class EmailOptions
{
    public required string SmtpHost { get; init; }
    public int Port { get; init; } = 587;
}
```

### Raw string literals

```csharp
var payload =
```
