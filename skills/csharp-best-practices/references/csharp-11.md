# C# 11 Best Practices (.NET 7) — Delta vs C# 10

## Standards added or changed

- Prefer `required` for configuration/options and DTOs that must be initialized.
- Prefer raw string literals for embedded JSON/regex/templates to reduce escaping bugs.
- Prefer list patterns where they increase clarity over manual indexing.
- Use `file` types for helpers intended to be private to a single file.

## New language patterns

### `required` members

Use `required` to enforce initialization at construction time without constructor boilerplate:

```csharp
public sealed class EmailOptions
{
    public required string SmtpHost { get; init; }
    public int Port { get; init; } = 587;
}

// Usage - compiler enforces SmtpHost is set
var options = new EmailOptions { SmtpHost = "mail.example.com" };
```

### Raw string literals

Use raw string literals (triple quotes) for embedded JSON, regex, or templates to avoid
escaping nightmares:

```csharp
var payload = """
    {
        "name": "example",
        "value": 123,
        "nested": {
            "path": "C:\\Users\\name"
        }
    }
    """;

// Also works for regex patterns
var pattern = """^\d{3}-\d{2}-\d{4}$""";
```

### List patterns

Use list patterns for concise collection matching:

```csharp
// Prefer - clear and declarative
if (args is [var first, .., var last])
{
    Console.WriteLine($"First: {first}, Last: {last}");
}

// Over manual indexing - verbose and error-prone
if (args.Length >= 2)
{
    Console.WriteLine($"First: {args[0]}, Last: {args[^1]}");
}

// Pattern matching with specific values
return numbers switch
{
    [] => "empty",
    [var single] => $"single: {single}",
    [var first, var second] => $"pair: {first}, {second}",
    [var head, .. var tail] => $"head: {head}, rest: {tail.Length} items"
};
```

### `file` scoped types

Use `file` modifier for helper types that should be private to a single file:

```csharp
// Only visible within this file - prevents accidental cross-file usage
file sealed class LocalHelper
{
    public static string Format(string input) => input.Trim().ToUpperInvariant();
}

// Particularly useful for source generators and implementation details
file record struct TempResult(bool Success, string Message);
```

## Tooling and enforcement

| Category         | Tool / Guidance                              | Notes                                   |
| ---------------- | -------------------------------------------- | --------------------------------------- |
| Required members | IDE0280 - Use 'required' modifier            | Enable as suggestion; promote over time |
| Raw strings      | IDE0071 - Simplify interpolated string       | Enable to catch escaped string issues   |
| List patterns    | IDE0220 - Add explicit cast in list patterns | Enable for safer pattern matching       |
| File types       | No built-in analyzer                         | Use code review for appropriate scoping |
