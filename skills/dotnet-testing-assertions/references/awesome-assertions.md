# Reference: AwesomeAssertions

## Recommended library

- AwesomeAssertions (open source)

## Examples

Equivalence:

```csharp
result.Should().BeEquivalentTo(expected);
```

Exceptions:

```csharp
action.Should().Throw<InvalidOperationException>();
```

## Notes

- Prefer structural assertions for contract tests.
- Avoid brittle assertions that over-specify implementation details.
