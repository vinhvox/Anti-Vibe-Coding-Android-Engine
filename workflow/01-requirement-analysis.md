---
name: requirement-analysis
description: Phase 1 workflow to analyze, define scope, constraints, and risks before architecture or code execution.
triggers:
- "phân tích yêu cầu"
- "requirement analysis"
- "bắt đầu feature mới"
next_step: ".antigravity/workflow/02-codebase-analysis.md"
---
# 01-requirement-analysis.md

# Purpose

This document defines the project's requirement analysis workflow.

Every implementation begins with understanding the problem.

The objective is to transform an ambiguous request into a clear, actionable engineering plan.

Implementation must not begin until the requirement is sufficiently understood.

---

# Philosophy

Requirements drive architecture.

Architecture drives implementation.

Implementation should never drive requirements.

Always understand first.

---

# Analysis Principles

Always:

Understand before solving.

Clarify before assuming.

Question before implementing.

Identify constraints early.

Focus on the problem rather than the proposed solution.

---

# Requirement Analysis Workflow

Every request must follow this sequence.

```text
Receive Request
        │
        ▼
Understand Context
        │
        ▼
Identify Goal
        │
        ▼
Determine Scope
        │
        ▼
Identify Constraints
        │
        ▼
Identify Dependencies
        │
        ▼
Detect Risks
        │
        ▼
Validate Understanding
        │
        ▼
Ready for Architecture
```

Never skip a step.

---

# Step 1 — Understand the Context

Determine:

- What problem is being solved?
- Why is it needed?
- Which feature is affected?
- Which users are affected?

Avoid jumping directly to implementation.

---

# Step 2 — Identify the Goal

Define the expected outcome.

Examples:

- New feature
- Bug fix
- Performance improvement
- UI enhancement
- Architecture change
- Refactoring

One request may contain multiple goals.

Separate them.

---

# Step 3 — Determine Scope

Identify:

Included:

- Modules
- Features
- Screens
- Components

Excluded:

- Unrelated modules
- Future work
- Optional improvements

Avoid scope creep.

---

# Step 4 — Identify Constraints

Determine constraints such as:

- Android Version
- Library Requirements
- Architecture Rules
- Performance
- Security
- Offline Support
- Backward Compatibility
- Timeline

Constraints influence implementation decisions.

---

# Step 5 — Identify Dependencies

Inspect:

- Existing Features
- Shared Components
- Navigation
- Repository
- Database
- API
- Permissions
- Background Tasks

Document affected systems.

---

# Step 6 — Identify Risks

Examples:

- Breaking Changes
- Performance Impact
- Memory Usage
- Navigation Complexity
- Database Migration
- Permission Changes
- Network Failure
- UI Regression

Every major risk should be acknowledged.

---

# Step 7 — Detect Missing Information

Identify unanswered questions.

Examples:

- API not defined
- UX undefined
- Business rules unclear
- Edge cases missing
- Acceptance criteria incomplete

Never invent requirements.

---

# Step 8 — Validate Understanding

Summarize:

Problem

Goal

Scope

Constraints

Risks

Dependencies

Confirm the analysis before implementation.

---

# Requirement Categories

Classify every request.

Examples:

Feature

Bug

Refactor

Optimization

Migration

Documentation

Build

Testing

Architecture

Review

The category determines the workflow.

---

# Functional Requirements

Identify:

- User actions
- System behavior
- Expected outputs
- Business rules

Functional requirements describe what the system should do.

---

# Non-functional Requirements

Identify:

- Performance
- Security
- Reliability
- Scalability
- Accessibility
- Maintainability
- Offline capability

These influence architecture.

---

# Acceptance Criteria

Every requirement should define success.

Examples:

✓ Feature works correctly

✓ No regression

✓ Architecture preserved

✓ Tests pass

✓ Performance acceptable

✓ Security maintained

---

# Assumptions

Avoid assumptions whenever possible.

If assumptions are necessary:

- Document them.
- Clearly identify them.
- Minimize their impact.

Never treat assumptions as facts.

---

# Edge Cases

Identify potential edge cases.

Examples:

- Empty input
- Null values
- Large datasets
- Slow network
- Permission denied
- Device rotation
- Process recreation

Consider them during planning.

---

# Reuse Opportunity

Before implementation determine:

Can an existing feature be reused?

Can an existing component be extended?

Can an existing abstraction solve the problem?

Reuse before creating.

---

# Estimation

Estimate:

- Complexity
- Number of affected modules
- Testing effort
- Risk level

Classify complexity:

Low

Medium

High

Very High

---

# Deliverables

Requirement analysis should produce:

- **Living Feature Specification (`spec.md` / `docs/plans/feature_<name>_spec.md`)**:
  - Problem Statement & Goal
  - User Stories & Actors
  - Domain Entities & Boundary Constraints
  - Mandatory 5-State UI/UX Matrix (`Loading`, `Content/Success`, `Empty`, `Error`, `Offline`)
  - Behavioral Acceptance Criteria (Gherkin format: `Given-When-Then`)
  - Non-Functional Constraints (Vitals, 16KB, Stack/Heap)
- Scope, Risks, and Dependencies Mapping

These become the formal input contracts for Architecture Design and Implementation Planning.

---

# Review Checklist

Before leaving this phase:

□ Problem understood

□ Goal identified

□ Scope defined

□ Living Feature Spec (`spec.md`) drafted

□ 5-State UI/UX Matrix mapped

□ Gherkin Acceptance Criteria defined

□ Constraints documented

□ Dependencies identified

□ Risks documented

□ Missing information identified

□ Ready for architecture

---

# Anti-patterns

Do not:

Implement before understanding.

Do not:

Guess business rules.

Do not:

Expand scope unnecessarily.

Do not:

Ignore constraints.

Do not:

Treat assumptions as facts.

Do not:

Mix multiple unrelated requirements.

---

# Decision Priority

When analyzing requirements:

1. Understand the problem

2. Clarify ambiguity

3. Define scope

4. Identify constraints

5. Detect dependencies

6. Assess risks

7. Confirm understanding

Only then proceed to architecture.

---

# Final Rule

A well-understood requirement eliminates most implementation problems.

Quality software begins with precise requirement analysis, not with writing code.