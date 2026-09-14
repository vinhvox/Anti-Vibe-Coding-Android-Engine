---
name: implementation-planning
description: Phase 4 workflow to transform an approved architecture blueprint into a persistent Living Feature Spec saved directly in project repo under docs/plans/feature_<name>.md.
triggers:
  - "implementation planning"
  - "lập kế hoạch triển khai"
  - "tạo execution plan"
prerequisites:
  - ".antigravity/workflow/01-requirement-analysis.md"
  - ".antigravity/workflow/02-codebase-analysis.md"
  - ".antigravity/workflow/03-architecture-design.md"
next_step: ".antigravity/workflow/05-feature-development.md"
---
# 04-implementation-planning.md

# Purpose

This document defines the implementation planning workflow.

Implementation planning transforms an approved architecture into a structured execution plan saved as a **Living Feature Spec** under `docs/plans/feature_<feature_name>.md` inside the project codebase.

The objective is to minimize implementation risk, eliminate plan fragmentation, ensure Git version control of feature specs, and enable seamless feature iteration.

Implementation should begin only after a complete living plan has been created or updated.

---

# Philosophy

Planning reduces complexity.

One Feature = One Living Spec File (`docs/plans/feature_<feature_name>.md`).

Never create fragmented plan files. Update existing specs with revision changelogs.

---

# Core Principles

Always:

Save plans directly to `docs/plans/feature_<feature_name>.md` in project root.

Plan before implementing.

Break work into small tasks.

Implement incrementally.

Validate after each milestone.

Avoid large unstructured changes.

---

# Planning Workflow

Every implementation must follow this workflow.

```text
Architecture
      │
      ▼
Identify Components
      │
      ▼
Determine Dependencies
      │
      ▼
Define Implementation Order
      │
      ▼
Split into Tasks
      │
      ▼
Estimate Risk
      │
      ▼
Validation Plan
      │
      ▼
Ready for Implementation
```

---

# Step 1 — Identify Components

List all components that will be created or modified.

Examples:

- Screen
- ViewModel
- UiState
- UiAction
- UseCase
- Repository
- API
- DAO
- Mapper
- Navigation
- DI Module
- Tests

Distinguish between:

New Components

Modified Components

Reused Components

---

# Step 2 — Identify Dependencies

Determine dependencies between components.

Example:

```text
API
    │
    ▼
Repository
    │
    ▼
UseCase
    │
    ▼
ViewModel
    │
    ▼
Screen
```

Dependencies determine implementation order.

---

# Step 3 — Define Implementation Order

Implement from the lowest stable layer upward.

Preferred order:

Infrastructure

↓

Data

↓

Domain

↓

Presentation

↓

Navigation

↓

Testing

Avoid building UI before business logic exists.

---

# Step 4 — Split into Tasks

Break implementation into small independent tasks.

Each task should:

- Have one responsibility.
- Be independently testable.
- Be independently reviewable.
- Be reversible.

Prefer many small tasks over one large task.

---

# Step 5 — Define Milestones

Group related tasks into milestones.

Example:

Milestone 1

Data Layer

Milestone 2

Domain Layer

Milestone 3

Presentation

Milestone 4

Navigation

Milestone 5

Testing

Each milestone should produce a working state.

---

# Step 6 — Risk Assessment

For each task identify:

- Technical Risk
- Performance Risk
- Security Risk
- Regression Risk

High-risk tasks should be implemented first when practical.

---

# Step 7 — Validation Strategy

Define validation after each milestone.

Examples:

- Build succeeds
- Unit tests pass
- UI renders
- Navigation works
- API responds correctly
- Database behaves correctly

Do not wait until the end to validate.

---

# Step 8 — Rollback Strategy

Identify how to recover if implementation fails.

Examples:

- Git revert
- Feature flag
- Disable module
- Restore previous implementation

Plan for recovery before implementation.

---

# Step 9 — Documentation Plan

Determine whether documentation updates are required.

Possible updates:

- README
- Architecture
- API
- Changelog
- Migration Notes

Documentation is part of implementation.

---

# Complexity Assessment

Estimate implementation complexity.

Levels:

Low

Medium

High

Very High

Consider:

- Number of modules
- Dependencies
- Business rules
- UI complexity
- Integration effort

---

# Plan File Storage Rule & SDD Tri-Artifact Suite

Every task MUST follow the **Spec-Driven Development (SDD)** standard and maintain persistent artifacts.

Plan files must be saved under the project plan directory:

`./.antigravity/plan/<task_name>_plan.md` OR `docs/plans/feature_<feature_name>_plan.md`

For complex features, the Tri-Artifact Suite is maintained:
- `feature_<name>_spec.md` (What & Why: Requirements, 5-State Matrix, Gherkin criteria)
- `feature_<name>_plan.md` (How: Architecture layer mapping, MVI contracts, DTOs, file touchpoints)
- `feature_<name>_tasks.md` (Execution: Dependency-ordered checklist with test commands)

Do NOT overwrite plan files of previous tasks.

---

# Deliverables

Implementation planning should produce:

- **Dedicated Architecture Plan (`plan.md` / `feature_<name>_plan.md`)**
- **Ordered Task Checklist (`tasks.md` / `feature_<name>_tasks.md`)**
- Component List & Dependency Graph
- Layer Implementation Sequence (`Data` $\rightarrow$ `Domain` $\rightarrow$ `Presentation` $\rightarrow$ `Tests`)
- Risk Assessment (Stack/Heap, 16KB, Vitals)
- Validation Plan with explicit `./gradlew` commands
- Rollback Plan

---

# Review Checklist

Before implementation:

□ Spec contract (`spec.md`) verified & approved

□ Components identified

□ Dependencies mapped

□ Layer implementation order defined (Data -> Domain -> UI)

□ Tasks split with verification commands

□ 5-State UI Matrix accounted for in plan

□ Risks assessed (Memory, Vitals, 16KB)

□ Validation plan defined

□ Rollback planned

□ Documentation considered

---

# Anti-patterns

Do not:

Implement everything at once.

Do not:

Skip planning.

Do not:

Create oversized pull requests.

Do not:

Ignore dependencies.

Do not:

Delay testing until the end.

Do not:

Leave rollback undefined.

---

# Decision Priority

When planning implementation:

1. Correct dependency order

2. Small independent tasks

3. Continuous validation

4. Low implementation risk

5. Easy rollback

6. High maintainability

---

# Final Rule

Implementation quality is determined before coding begins.

A structured implementation plan produces predictable, maintainable, and reliable software.