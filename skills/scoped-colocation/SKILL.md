---
name: scoped-colocation
description: Use when organizing code structure, creating new features, or reviewing file placement to keep related code together by scope and reduce cognitive load.
---

# Scoped Colocation

## Overview

**Keep related code together by scope.** Scoped colocation organizes files by feature or domain
rather than technical layer, reducing navigation overhead and making the codebase self-documenting.

**Principle:** Code that changes together should live together. When you modify a feature, you
should not need to navigate across multiple unrelated directories.

**REQUIRED BACKGROUND:** superpowers:verification-before-completion

## When to Use

**Always triggered for:**

- Creating new features or components
- Reviewing or refactoring existing file structure
- Discussing project organization patterns
- Onboarding to an unfamiliar codebase
- Adding tests, styles, or related assets to existing features

## Core Patterns

### Pattern 1: Feature-Scoped Directories

Organize by feature/domain, not by technical concern:

```text
# Anti-pattern: Technical layers
src/
  controllers/
    OrderController.cs
    CustomerController.cs
  services/
    OrderService.cs
    CustomerService.cs
  models/
    Order.cs
    Customer.cs

# Preferred: Feature-scoped
src/
  Orders/
    OrderController.cs
    OrderService.cs
    Order.cs
    OrderTests.cs
  Customers/
    CustomerController.cs
    CustomerService.cs
    Customer.cs
    CustomerTests.cs
```

### Pattern 2: Test Colocation

Tests live next to the code they test:

```text
# Anti-pattern: Separate test tree
src/
  Components/
    Button.tsx
tests/
  Components/
    Button.test.tsx

# Preferred: Colocated tests
src/
  Components/
    Button.tsx
    Button.test.tsx
```

### Pattern 3: Asset Colocation

Related assets (styles, types, fixtures) stay with their component:

```text
src/
  Features/
    Dashboard/
      Dashboard.tsx
      Dashboard.module.css
      Dashboard.types.ts
      Dashboard.test.tsx
      dashboard-fixtures.json
```

### Pattern 4: Shared Code Extraction

Extract only when genuinely shared (used in 3+ places):

```text
src/
  Features/
    Orders/
      ... (feature-specific code)
    Customers/
      ... (feature-specific code)
  Shared/
    Components/
      Button.tsx        # Used by Orders, Customers, Reports
    Utils/
      formatDate.ts     # Used across multiple features
```

**Rule:** Do not prematurely extract. Keep code in features until sharing becomes necessary.

## Decision Framework

### When to Colocate

- Code is used by only one feature
- Code changes when the feature changes
- Understanding requires feature context
- Tests and implementation evolve together

### When to Extract to Shared

- Code is used by 3 or more features
- Code is stable and unlikely to change per-feature
- Code represents a cross-cutting concern (auth, logging)
- Code is a foundational utility (date formatting, validation)

### Colocation Hierarchy

```text
1. Same file (functions, types)
2. Same directory (component + test + styles)
3. Feature directory (all feature-related code)
4. Domain directory (related features grouped)
5. Shared (cross-cutting, stable, reusable)
```

## Required Actions

### When Creating New Code

1. Identify the owning feature or domain
2. Place code in that feature's directory
3. Colocate tests with implementation
4. Colocate related assets (styles, types, fixtures)
5. Only extract if truly shared (3+ consumers)

### When Reviewing Code Placement

1. Check if code is used by only one feature
2. If single-feature, move to that feature's directory
3. Verify tests are colocated
4. Check for orphaned files in wrong directories

### When Refactoring Structure

1. Identify features/domains in the codebase
2. Group related files by feature
3. Move single-feature code out of "shared" directories
4. Keep genuinely shared code in shared locations
5. Update imports and references

## Red Flags - STOP

- Creating a new `utils/` or `helpers/` file for single-feature code
- Placing tests in a separate `__tests__/` tree far from implementation
- Adding feature-specific code to a "common" or "shared" directory
- Organizing primarily by file type (all controllers together, all models together)
- Premature extraction ("might need this elsewhere")

**All mean:** Consider if the code belongs in a feature directory instead.

## Benefits

| Benefit              | Description                                    |
| -------------------- | ---------------------------------------------- |
| Reduced navigation   | Related files in same directory                |
| Self-documenting     | Directory structure reveals feature boundaries |
| Easier deletion      | Remove feature by deleting one directory       |
| Clear ownership      | Obvious which team owns which code             |
| Simpler imports      | Shorter, more intuitive import paths           |
| Better encapsulation | Feature internals hidden from other features   |

## Language-Specific Examples

### React/TypeScript

```text
src/
  features/
    auth/
      LoginForm.tsx
      LoginForm.test.tsx
      LoginForm.module.css
      useAuth.ts
      useAuth.test.ts
      auth.types.ts
    dashboard/
      Dashboard.tsx
      Dashboard.test.tsx
      DashboardWidget.tsx
      useDashboardData.ts
```

### .NET (C#)

```text
src/
  Features/
    Orders/
      CreateOrderCommand.cs
      CreateOrderCommandHandler.cs
      CreateOrderCommandTests.cs
      OrderRepository.cs
      OrderDto.cs
    Customers/
      GetCustomerQuery.cs
      GetCustomerQueryHandler.cs
      CustomerService.cs
```

### Python

```text
src/
  features/
    orders/
      __init__.py
      routes.py
      service.py
      models.py
      test_orders.py
    customers/
      __init__.py
      routes.py
      service.py
      models.py
      test_customers.py
```

## Exceptions

Certain code legitimately belongs in shared/common locations:

- **Framework configuration** (startup, middleware setup)
- **Cross-cutting infrastructure** (logging, caching, auth middleware)
- **Domain primitives** used across all features (Money, DateRange)
- **Build/deployment configuration** (CI/CD, Docker)

These exceptions should be documented in the project's architecture documentation.

## Verification Checklist

Before declaring structure complete:

- [ ] Feature code lives in feature directories
- [ ] Tests are colocated with implementation
- [ ] Related assets are in same directory
- [ ] Shared code is genuinely shared (3+ consumers)
- [ ] No premature extraction to utils/helpers
- [ ] Directory structure reflects feature boundaries
