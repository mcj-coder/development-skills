# Aspire Testing Patterns

## Test Project Setup

```bash
dotnet new xunit -n Integration.Tests
cd Integration.Tests
dotnet add package Aspire.Hosting.Testing
dotnet add reference ../AppHost/AppHost.csproj
```

## Basic Application Startup Test

```csharp
public class AppHostTests
{
    [Fact]
    public async Task Application_Starts_Successfully()
    {
        var appHost = await DistributedApplicationTestingBuilder
            .CreateAsync<Projects.AppHost>();

        await using var app = await appHost.BuildAsync();
        await app.StartAsync();

        // Verify all resources started
        var resourceStates = app.Services
            .GetRequiredService<ResourceNotificationService>();
        // Assert healthy state
    }
}
```

## Health Endpoint Validation

```csharp
[Fact]
public async Task Api_Health_Endpoint_Returns_Healthy()
{
    var appHost = await DistributedApplicationTestingBuilder
        .CreateAsync<Projects.AppHost>();

    await using var app = await appHost.BuildAsync();
    await app.StartAsync();

    var httpClient = app.CreateHttpClient("api");
    var response = await httpClient.GetAsync("/health");

    Assert.Equal(HttpStatusCode.OK, response.StatusCode);
}
```

## Cross-Component Flow Testing

```csharp
[Fact]
public async Task Order_Flow_Works_End_To_End()
{
    // Start distributed app
    var appHost = await DistributedApplicationTestingBuilder
        .CreateAsync<Projects.AppHost>();
    await using var app = await appHost.BuildAsync();
    await app.StartAsync();

    // POST order to API
    var client = app.CreateHttpClient("order-api");
    var response = await client.PostAsJsonAsync("/orders",
        new { ProductId = 1, Quantity = 5 });
    Assert.Equal(HttpStatusCode.Created, response.StatusCode);

    // Verify worker processed (check database or response)
    await Task.Delay(TimeSpan.FromSeconds(2)); // Wait for async processing
    var order = await client.GetFromJsonAsync<Order>("/orders/1");
    Assert.Equal("Processed", order.Status);
}
```

## Serial Execution for Shared Resources

```csharp
[Collection("AspireIntegration")]
public class OrderApiTests
{
    // Tests in same collection run serially
}

[Collection("AspireIntegration")]
public class PaymentWorkerTests
{
    // Same collection = serial execution
}
```

## Test Data Isolation

```csharp
[Fact]
public async Task CreateOrder_WithUniqueId_IsIsolated()
{
    var testId = Guid.NewGuid().ToString();
    var order = new { ProductId = 1, TestCorrelationId = testId };

    // Create with unique ID
    await client.PostAsJsonAsync("/orders", order);

    // Query only this test's data
    var result = await client.GetFromJsonAsync<Order>(
        $"/orders?correlationId={testId}");
}
```
