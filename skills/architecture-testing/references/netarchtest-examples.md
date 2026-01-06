# NetArchTest Examples

## Installation

```bash
dotnet add package NetArchTest.Rules
```

## Common Boundary Tests

### Domain Has No External Dependencies

```csharp
[Fact]
public void Domain_Should_Not_Reference_Infrastructure()
{
    var result = Types.InAssembly(typeof(DomainMarker).Assembly)
        .ShouldNot()
        .HaveDependencyOn("Infrastructure")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```

### Controllers Only in Presentation

```csharp
[Fact]
public void Controllers_Should_Only_Be_In_Presentation()
{
    var result = Types.InCurrentDomain()
        .That()
        .HaveNameEndingWith("Controller")
        .Should()
        .ResideInNamespace("Presentation")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```

### Application Layer Depends Only on Domain

```csharp
[Fact]
public void Application_Should_Only_Depend_On_Domain()
{
    var result = Types.InAssembly(typeof(ApplicationMarker).Assembly)
        .ShouldNot()
        .HaveDependencyOn("Infrastructure")
        .And()
        .ShouldNot()
        .HaveDependencyOn("Presentation")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```

## Brownfield: Permissive Tests with Suppressions

```csharp
[Fact]
public void Domain_Should_Not_Reference_Infrastructure_Except_Legacy()
{
    var result = Types.InAssembly(typeof(DomainMarker).Assembly)
        .That()
        .DoNotResideInNamespace("Domain.Legacy") // Suppress legacy code
        .ShouldNot()
        .HaveDependencyOn("Infrastructure")
        .GetResult();

    Assert.True(result.IsSuccessful);
}
```

## ArchUnit (Java Alternative)

```java
@ArchTest
static final ArchRule domain_should_not_depend_on_infrastructure =
    noClasses()
        .that().resideInAPackage("..domain..")
        .should().dependOnClassesThat()
        .resideInAPackage("..infrastructure..");
```

## CI Integration

Add to your test project and run as part of normal test suite:

```bash
dotnet test --filter "Category=Architecture"
```

Tests fail build if boundaries violated.
