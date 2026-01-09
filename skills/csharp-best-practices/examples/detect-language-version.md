# Detecting the Effective C# Version

## Precedence Example

1. csproj LangVersion
2. Directory.Build.props
3. Imported props/targets
4. TFM inference
5. SDK evidence (diagnostics only)

## Sample

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Effective language version: C# 12
