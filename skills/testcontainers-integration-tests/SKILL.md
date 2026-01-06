---
name: testcontainers-integration-tests
description: Use when integration tests require real infrastructure (database, message queue, cache) or when mocking infrastructure is insufficient. Defines container lifecycle, test isolation, and performance optimization for Testcontainers-based testing.
---

# Testcontainers Integration Tests

## Overview

Use **real infrastructure in containers** for integration tests. Mocks don't catch SQL bugs
or database-specific issues. Testcontainers provides isolated, repeatable tests with
production-equivalent infrastructure.

**REQUIRED:** superpowers:test-driven-development, superpowers:verification-before-completion

## When to Use

- Integration tests need real database, queue, or cache
- Tests verify database-specific features (JSON, arrays, transactions)
- Mocking infrastructure is insufficient for test confidence
- Tests are flaky due to shared test database state
- Repository uses or should use Testcontainers

## Core Workflow

1. **Identify infrastructure** (database type, version, queue, cache)
2. **Select Testcontainers library** (Java, .NET, Python, Node)
3. **Configure container** with production-matching version
4. **Define lifecycle** (per-class or shared fixture)
5. **Implement isolation** (transactions, cleanup, fresh schema)
6. **Set up schema** (migrations or scripts)
7. **Write tests** against real infrastructure
8. **Optimize for CI** (reuse, parallel, image pre-pull)

See `references/language-setup.md` for language-specific configuration.
See `references/performance-optimization.md` for container reuse strategies.
See `references/ci-cd-integration.md` for CI/CD patterns.

## Quick Reference

| Container  | Use Case        | Image                      |
| ---------- | --------------- | -------------------------- |
| PostgreSQL | Relational DB   | postgres:15                |
| MySQL      | Relational DB   | mysql:8                    |
| MongoDB    | Document DB     | mongo:6                    |
| Redis      | Cache           | redis:7-alpine             |
| RabbitMQ   | Message Queue   | rabbitmq:3.12-management   |
| Kafka      | Event Streaming | confluentinc/cp-kafka:7.4  |

## Red Flags - STOP

- "Mocks are faster" / "H2 is close enough"
- "Shared test database is fine" / "CI doesn't support Docker"
- "Testcontainers is too slow" / "Just add better cleanup"

**All mean: Apply testcontainers-integration-tests with optimizations.**

See `references/performance-optimization.md` for rationalizations table.
