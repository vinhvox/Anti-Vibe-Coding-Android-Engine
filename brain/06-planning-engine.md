# 06-planning-engine.md

# Planning Engine

## Purpose

The Planning Engine transforms validated engineering decisions into a structured implementation plan.

It does not determine what should be built.

It determines how the approved solution should be executed.

Planning begins only after the Decision Engine has successfully completed.

---

# Philosophy

A plan is an execution roadmap.

A plan is not an implementation.

A plan should reduce uncertainty,

not increase complexity.

---

# Responsibilities

The Planning Engine must:

- Build an implementation roadmap.
- Break work into manageable phases.
- Identify dependencies.
- Estimate risks.
- Produce implementation milestones.
- Prepare execution tasks.

The Planning Engine must never:

- Change engineering decisions.
- Introduce new assumptions.
- Select new technologies.
- Generate source code.

---

# Inputs

Receive:

- User Request
- Clarification Result
- Assumption Result
- Decision Result
- Project Memory
- Existing Architecture

---

# Preconditions

Execution may continue only if:

✓ Clarification Status = READY

✓ Assumption Status = READY

✓ Decision Status = READY

If any prerequisite fails:

STOP.

Return control to the previous Brain Engine.

---

# Planning Process

Execute the following sequence.

---

## Step 1 — Define Objective

Identify:

- Goal
- Deliverables
- Scope
- Constraints

---

## Step 2 — Identify Work Items

Break implementation into logical tasks.

Examples:

Architecture

↓

Data Layer

↓

Domain Layer

↓

Presentation Layer

↓

Testing

↓

Documentation

Tasks should be:

Independent

Traceable

Reviewable

---

## Step 3 — Identify Dependencies

Determine:

Task dependencies

Module dependencies

Library dependencies

External services

Configuration requirements

No task should begin before its dependencies are satisfied.

---

## Step 4 — Define Execution Order

Arrange tasks in execution sequence.

Prefer:

Foundation

↓

Core Logic

↓

UI

↓

Testing

↓

Optimization

↓

Documentation

Never implement UI before the underlying business logic is stable.

---

## Step 5 — Risk Analysis

Identify:

Technical risks

Architecture risks

Performance risks

Security risks

Migration risks

Testing risks

Each risk should include a mitigation strategy.

---

## Step 6 — Validation

Verify that the plan:

Aligns with project architecture.

Respects engineering rules.

Uses existing project patterns.

Can be implemented incrementally.

Supports testing.

Supports future maintenance.

---

# Planning Rules

Every task must have:

Purpose

Dependencies

Expected outcome

Completion criteria

Tasks should be small enough to review independently.

---

# Output

Every execution must produce:

```yaml
status:
  READY | BLOCKED

objective:
  ...

implementation_phases:

  - Foundation

  - Data Layer

  - Domain Layer

  - Presentation Layer

  - Testing

  - Documentation

dependencies:

  - ...

risks:

  - ...

milestones:

  - ...

estimated_complexity:
  Low | Medium | High

confidence:
  90

next_engine:
  Execution Engine
```

---

# Blocking Conditions

Stop immediately if:

Decision is not approved.

Architecture is inconsistent.

Critical dependencies are unknown.

Required project patterns cannot be identified.

Major implementation risks remain unresolved.

---

# Success Criteria

The Planning Engine succeeds when:

Implementation order is defined.

Dependencies are identified.

Risks are documented.

Execution tasks are organized.

The Execution Engine can begin without ambiguity.

---

# Anti-patterns

Never:

Write implementation code.

Change approved decisions.

Create new assumptions.

Skip dependency analysis.

Ignore architecture.

Plan tasks without completion criteria.

---

# Engine Contract

## Input

- User Request
- Decision Result
- Project Context

## Output

- Implementation Plan

## Next Engine

Execution Engine

---

# Final Rule

The Planning Engine exists to transform validated decisions into a structured, executable, and reviewable engineering plan.

It prepares implementation,

but never performs implementation.

Planning Engine is NOT allowed to execute directly.

Planning Engine may execute ONLY IF

Clarification.status == READY

AND

Decision.status == READY

AND

Confidence.status == READY