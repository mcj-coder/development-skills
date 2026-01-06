# Aspire.Hosting.Testing API Reference

## Package Installation

```bash
dotnet add package Aspire.Hosting.Testing
```

## Core Classes

### DistributedApplicationTestingBuilder

Creates a test instance of your Aspire AppHost.

```csharp
var appHost = await DistributedApplicationTestingBuilder
    .CreateAsync<Projects.AppHost>();
```

### Building and Starting

```csharp
await using var app = await appHost.BuildAsync();
await app.StartAsync();

// Don't forget to stop
await app.StopAsync();
```

### Creating HTTP Clients

```csharp
// Get client for named service
var apiClient = app.CreateHttpClient("api");
var workerClient = app.CreateHttpClient("worker");

// Use for requests
var response = await apiClient.GetAsync("/health");
```

### Getting Connection Strings

```csharp
var connectionString = await app.GetConnectionStringAsync("postgres");
var rabbitConnection = await app.GetConnectionStringAsync("messaging");
```

### Getting Service Endpoints

```csharp
var endpoint = app.GetEndpoint("api");
// Returns Uri like http://localhost:5001
```

## Environment Configuration

```csharp
var appHost = await DistributedApplicationTestingBuilder
    .CreateAsync<Projects.AppHost>(args =>
    {
        args.Configuration["ConnectionStrings:Database"] = testConnectionString;
    });
```

## Waiting for Resources

```csharp
// Wait for specific resource to be ready
await app.WaitForResourceAsync("postgres",
    KnownResourceStates.Running,
    TimeSpan.FromSeconds(30));
```

## Common Assertions

```csharp
// Health check
var response = await client.GetAsync("/health");
Assert.Equal(HttpStatusCode.OK, response.StatusCode);

// Alive check
var alive = await client.GetAsync("/alive");
Assert.Equal(HttpStatusCode.OK, alive.StatusCode);

// JSON response
var data = await client.GetFromJsonAsync<WeatherForecast[]>("/weather");
Assert.NotEmpty(data);
```

## Debugging Tips

Set environment variable for local debugging:

```bash
ASPIRE_ALLOW_UNSECURED_TRANSPORT=true
```

Access logs via app services:

```csharp
var logger = app.Services.GetRequiredService<ILogger<MyTest>>();
```
