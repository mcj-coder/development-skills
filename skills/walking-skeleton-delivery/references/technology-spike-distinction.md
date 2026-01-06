# Technology Spike vs Walking Skeleton

## Key Distinctions

| Aspect         | Technology Spike                  | Walking Skeleton                 |
| -------------- | --------------------------------- | -------------------------------- |
| **Purpose**    | Answer a question                 | Prove architecture works E2E     |
| **Outcome**    | Knowledge (throwaway code)        | Foundation (production code)     |
| **Quality**    | Quick and dirty is acceptable     | Production-quality required      |
| **Scope**      | Narrow (one technology/question)  | Broad (entire E2E slice)         |
| **Deployment** | Optional (local often sufficient) | Required (proves pipeline works) |
| **Tests**      | Optional (manual validation OK)   | Required (BDD acceptance test)   |
| **Lifetime**   | Days, then discard                | Permanent foundation             |
| **Risk focus** | "Can we do X?"                    | "Does our architecture work?"    |

## When to Use Which

### Use Technology Spike When

- Single technology question: "Does gRPC work with our stack?"
- No architecture decision: Just learning
- Throwaway is acceptable: Code won't be kept
- Timeline: < 1 day investigation

**Example:** "Can we use EventStoreDB with .NET 8?"

```bash
# Spike: Quick throwaway code
mkdir grpc-spike
cd grpc-spike
dotnet new console
# Quick implementation to test one thing
# Delete when done
```

### Use Walking Skeleton When

- Architecture validation: "Does our design work E2E?"
- Multiple technologies: Need to prove integration
- Foundation code: Will be built upon
- Deployment matters: Need to prove pipeline
- Timeline: 2-4 days

**Example:** "Build order service with gRPC and PostgreSQL"

```bash
# Skeleton: Production-quality foundation
mkdir order-service
cd order-service
# Full project structure
# CI/CD pipeline
# BDD tests
# Keeps and extends
```

## Hybrid Approach: Spike Then Skeleton

When facing unfamiliar technologies:

### Phase 1: Technology Spike (Day 1)

**Goal:** Answer specific technology questions

```markdown
Questions to answer:

- Can we configure gRPC in .NET 8?
- Can we connect to EventStoreDB?
- Do these technologies integrate?

Spike outcome:

- Yes/No answers with evidence
- Pain points identified
- Decision: Proceed or pivot
```

### Phase 2: Walking Skeleton (Days 2-4)

**Goal:** Build production foundation using proven technologies

```markdown
Skeleton scope (informed by spike):

- gRPC service definition (spike proved this works)
- EventStoreDB integration (spike proved this works)
- E2E acceptance test
- Deployment pipeline
```

### Decision Framework

```text
Question: "Should I spike or skeleton?"

                        +------------------------+
                        | Is there a specific    |
                        | technology question?   |
                        +------------------------+
                                   |
                    Yes ___________+___________ No
                      |                        |
            +------------------+      +------------------+
            | Spike first      |      | Go directly to   |
            | (1 day max)      |      | walking skeleton |
            +------------------+      +------------------+
                      |
            +------------------+
            | Did spike prove  |
            | technology works?|
            +------------------+
                      |
            Yes ______+______ No
              |             |
    +------------------+ +------------------+
    | Proceed to       | | Pivot technology |
    | walking skeleton | | or escalate      |
    +------------------+ +------------------+
```

## Common Mistakes

### Mistake 1: Spike That Becomes Skeleton

**Symptom:** "The spike is working, let's just extend it"

**Problem:** Spike code quality is not production quality.

**Fix:** Discard spike. Start skeleton fresh using spike learnings.

### Mistake 2: Skeleton Without Spike (High Risk Tech)

**Symptom:** "Let's build the skeleton with EventSourcing and CQRS"

**Problem:** Unknown technology risks buried in skeleton timeline.

**Fix:** Spike unfamiliar technologies first. Then skeleton with proven tech.

### Mistake 3: Endless Spiking

**Symptom:** "One more spike to be sure..."

**Problem:** Spikes don't prove architecture works E2E.

**Fix:** Set spike time limit (1 day). Then proceed to skeleton.

### Mistake 4: Skeleton Without Deployment

**Symptom:** "Skeleton works locally, deployment can come later"

**Problem:** Deployment problems discovered late cause major delays.

**Fix:** Deployment IS part of the skeleton. Not optional.

## Summary

| Scenario                         | Approach          |
| -------------------------------- | ----------------- |
| New tech, no experience          | Spike -> Skeleton |
| Familiar tech, new architecture  | Skeleton directly |
| Single technology question       | Spike only        |
| Need to prove E2E flow           | Skeleton required |
| Distributed system design        | Skeleton required |
| "Can we use X?" question         | Spike             |
| "Does our design work?" question | Skeleton          |

**Rule of thumb:** If you're building on the result, it's a skeleton. If you're discarding the result, it's a spike.
