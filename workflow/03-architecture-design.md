---
name: architecture-design
description: Phase 3 workflow to transform analyzed requirements and codebase inspection into a maintainable, scalable, and testable architecture blueprint.
triggers:
  - "architecture design"
  - "thiết kế kiến trúc"
  - "thiết kế giải pháp"
prerequisites:
  - ".antigravity/workflow/01-requirement-analysis.md"
  - ".antigravity/workflow/02-codebase-analysis.md"
next_step: ".antigravity/workflow/04-implementation-planning.md"
---
# 03-architecture-design.md

# Purpose

This document defines the architecture design workflow.

Architecture design transforms analyzed requirements into a maintainable, scalable, and testable implementation plan.

Implementation must never begin before the architecture has been defined.

---

# Philosophy

Architecture is the blueprint of implementation.

Good architecture minimizes future complexity.

Implementation should follow architecture.

Architecture should never evolve accidentally.

---

# Core Principles

Always:

Design before implementing.

Reuse before creating.

Minimize coupling.

Maximize cohesion.

Separate responsibilities.

Respect module boundaries.

---

# Architecture Design Workflow

Every implementation follows this sequence.

```text
Requirement Analysis
        │
        ▼
Codebase Analysis
        │
        ▼
Identify Affected Layers
        │
        ▼
Design Solution
        │
        ▼
Validate Against Rules
        │
        ▼
Review Dependencies
        │
        ▼
Ready for Planning
```

---

# Step 1 — Identify Affected Modules

Determine which modules require modification.

Possible modules:

- app
- feature
- core
- domain
- data
- designsystem
- benchmark

Avoid unnecessary module changes.

---

# Step 2 — Identify Affected Layers

Determine affected layers.

Possible layers:

Presentation

Domain

Data

Infrastructure

Core

Design only the layers that require changes.

---

# Step 3 — Define Responsibilities

Every class should have one responsibility.

Examples:

Screen

↓

Render UI

ViewModel

↓

Manage UI state

UseCase

↓

Business logic

Repository

↓

Coordinate data

RemoteDataSource

↓

Network

LocalDataSource

↓

Local storage

DAO

↓

Database

---

# Step 4 — Design Data Flow

Define complete data flow.

Example:

```text
UI
│
▼
ViewModel
│
▼
UseCase
│
▼
Repository
│
├────► Remote
│
└────► Local
```

Data should move in one direction.

---

# Step 5 — Design State Flow

Define UI state lifecycle.

Typical flow:

Loading

↓

Success

↓

Error

↓

Empty

↓

Retry

Avoid undefined states.

---

# Step 6 — Design Navigation

Determine:

- Destination
- Entry point
- Arguments
- Result handling
- Back navigation
- Deep links

Navigation should remain independent from business logic.

---

# Step 7 — Design Dependencies

Verify dependency direction.

Allowed:

Presentation

↓

Domain

↓

Data

↓

Infrastructure

Never reverse dependency direction.

---

# Step 8 — Design Reuse

Determine reusable components.

Examples:

Composable

UseCase

Repository

Mapper

Extension

Utilities

Reuse before creating.

---

# Step 9 — Design Error Handling

Define:

- Failure sources
- Recovery strategy
- Retry
- User feedback
- Logging

Errors should be handled consistently.

---

# Step 10 — Design Performance

Consider:

- Recomposition
- Memory
- Startup
- Lazy loading
- Database
- Network
- Background work

Performance is part of architecture.

---

# Step 11 — Design Security

Review:

- Sensitive data
- Permissions
- Storage
- API
- Encryption
- Logging

Security should be built into the design.

---

# Step 12 — Design Testability

Every layer should be testable.

Verify:

- Dependency Injection
- Fake implementations
- Isolation
- Deterministic behavior

Avoid tightly coupled components.

---

# Architecture Validation

Validate against:

- Engineering Rules
- Design System
- Navigation Rules
- Dependency Rules
- Error Handling Rules
- Testing Rules

Architecture must satisfy all applicable rules.

---

# Impact Analysis

Identify impacts.

Examples:

- UI
- Navigation
- Repository
- API
- Database
- Background Tasks

Document architectural changes.

---

# Deliverables

Architecture design should produce:

- Module Plan
- Layer Plan
- Dependency Diagram
- Data Flow
- State Flow
- Navigation Plan
- Error Strategy
- Test Strategy

---

# Review Checklist

Before implementation:

□ Modules identified

□ Layers defined

□ Responsibilities assigned

□ Data Flow designed

□ State Flow designed

□ Navigation designed

□ Dependencies validated

□ Error strategy defined

□ Performance considered

□ Security reviewed

□ Testability ensured

---

# Anti-patterns

Do not:

Start coding before design.

Do not:

Mix responsibilities.

Do not:

Create cyclic dependencies.

Do not:

Bypass Domain layer.

Do not:

Duplicate architecture.

Do not:

Ignore module boundaries.

---

# Decision Priority

When designing architecture:

1. Maintainability

2. Simplicity

3. Scalability

4. Testability

5. Performance

6. Security

7. Reusability

---

# Final Rule

Architecture is the contract between requirements and implementation.

A clear architecture reduces bugs, improves maintainability, and enables long-term scalability.