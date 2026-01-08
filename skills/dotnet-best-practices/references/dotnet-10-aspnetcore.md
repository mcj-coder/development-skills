# ASP.NET Core in .NET 10

## Adopt now

- **Identity metrics**
  - Integrate into dashboards/alerts; use to detect auth failures, latency spikes, and abnormal patterns.
- **Blazor static script asset pipeline**
  - Validate CDN/caching behavior and static asset integrity patterns if using Blazor.

## Evaluate

- Re-check middleware/security defaults and hosting behaviors under real ingress topology (reverse proxies, gateways, WAFs).

## Avoid / caution

- Assuming defaults match older versions; explicitly test forwarded headers, HTTPS enforcement, timeouts, and rate limiting.
