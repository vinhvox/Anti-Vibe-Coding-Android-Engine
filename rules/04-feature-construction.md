# 04-feature-construction.md

# Purpose

This document defines the mandatory workflow for implementing a new feature.

The goal is to ensure every feature is built consistently, minimizes technical debt, and integrates naturally with the existing architecture.

The agent MUST follow this workflow before generating production code.

---

# Core Principle

Never start implementation by writing UI.

Always understand the project before writing code.

Every feature must be built from the foundation upward.

---

# Feature Development Workflow & Skill Integration

All feature requests MUST execute the 13-Phase Master Workflow defined in `.skills/request-processing-flow.md`.

```text
1. Request & Context Intake
        ↓
2. Skill & Rule Discovery (.rules/ & .skills/)
        ↓
3. Codebase Inspection & Reuse Audit
        ↓
4. Architecture Contract (MVI/UDF & Route)
        ↓
5. Dedicated Plan File Creation (./.antigravity/plan/<task_name>_plan.md)
        ↓
6. User Approval Gate (/plan đồng ý)
        ↓
7. Modular Layered Implementation
        ↓
8. Design System & Theme Mandate Enforcement
        ↓
9. Router & Screen Preview Enforcement
        ↓
10. Empirical Build Verification (./gradlew compileDebugKotlin)
        ↓
11. Walkthrough Artifact Generation (walkthrough.md)
        ↓
12. Memory & Knowledge Update
        ↓
13. Clean & Professional User Reporting
```

Never skip any phase.

---

# Phase 1 — Requirement Analysis

Before creating any file, determine:

- What problem is being solved?
- Who will use this feature?
- What is the expected outcome?
- What are the edge cases?
- What are the acceptance criteria?

If requirements are unclear:

Stop and request clarification.

Never make assumptions for business logic.

---

# Phase 2 — Inspect Existing Project

Before creating any implementation, inspect the project for existing:

## Architecture

- BaseViewModel
- UiState
- DataState
- Repository Pattern
- UseCase Pattern

## Design System

- Typography
- Colors
- Shapes
- Components
- Icons
- Spacing

## Navigation

- Navigation Graph
- Destinations
- Route Pattern

## Dependency Injection

- Existing Koin modules

## Utilities

- Extensions
- Managers
- Common Components

Reuse whenever possible.

---

# Phase 3 — Feature Planning

Define the feature architecture before implementation.

Document:

- Domain Model
- Repository Contract
- Data Sources
- Use Cases
- UI State
- User Intent
- Events
- Navigation
- Dependencies

Do not start coding before the feature structure is clear.

---

# Phase 4 — Task Breakdown

Split implementation into logical tasks.

Example:

```text
Task 1

Domain Model

↓

Task 2

Repository Contract

↓

Task 3

Remote Data Source

↓

Task 4

Repository

↓

Task 5

Use Case

↓

Task 6

UiState

↓

Task 7

ViewModel

↓

Task 8

Composable UI

↓

Task 9

Navigation

↓

Task 10

DI Registration

↓

Task 11

Testing
```

Avoid implementing multiple responsibilities simultaneously.

---

# Phase 5 — Foundation First

Implement the feature from the lowest layer upward.

Recommended order:

```text
Domain

↓

Repository Contract

↓

Data Source

↓

Repository

↓

UseCase

↓

UiState

↓

Intent

↓

Event

↓

ViewModel

↓

Composable

↓

Navigation

↓

Dependency Injection
```

Never begin with Composable.

---

# Phase 6 — UI Construction (Router -> Screen -> Previews)

UI development MUST follow the strict 3-layer architecture:

1. **Stateful Router (`*Route` / `*Router`):**
   - Injects ViewModel via Koin (`koinViewModel()`).
   - Collects UI State with lifecycle (`collectAsStateWithLifecycle()`).
   - Collects One-off Effects (`LaunchedEffect`).
   - Manages Smart Permissions via `rememberPermissionController()` (Runtime & Special permissions + `ON_RESUME` auto-action).
   - Manages System Dialogs and Bottom Sheet visibility via `PermissionDialogHost`.
   - Forwards state and event handlers down to the Screen.

2. **Stateless Screen (`*Screen` / `*Content`):**
   - 100% Pure Composable, accepts only `(uiState, onIntent, modifier)`.
   - ZERO ViewModel references, ZERO Koin/DI calls.
   - Renders all UI states: `Loading`, `Success`, `Empty`, `Error`.

3. **Mandatory Previews (`*ScreenPreview`):**
   - Mandatory `@Preview` for Light and Dark modes.
   - Provides `PreviewParameterProvider` with mock states.

Before implementing UI components:

Identify existing Design System tokens:

- Typography
- Buttons
- TextFields
- Colors
- Shapes
- Icons
- Loading Components
- Empty State
- Error State

Create a component mapping.

Example:

```text
Title
↓
AppTypography.Title

Button
↓
PrimaryButton

Input
↓
AppTextField

Loading
↓
LoadingView
```

Only after mapping is complete should UI implementation begin.

---

# Phase 7 — Integration

After implementation, verify:

- Navigation
- Dependency Injection
- ViewModel
- Repository
- State
- Error handling
- Loading state
- Empty state

Do not leave partially integrated features.

---

# Phase 8 — Verification

Before considering a feature complete:

Verify:

□ Architecture consistency

□ No duplicated implementation

□ No hardcoded Design System values

□ No business logic in UI

□ Correct dispatcher usage

□ Correct DI registration

□ Navigation works

□ Loading state handled

□ Error state handled

□ Empty state handled

□ Build passes

---

# Existing Code First

When implementing a feature:

Search before creating.

Priority:

1. Existing implementation

2. Existing abstraction

3. Existing reusable component

4. New implementation

Never reverse this order.

---

# File Modification Rules

Modify only files related to the requested feature.

Never:

- Rename unrelated packages
- Move unrelated classes
- Reformat the entire project
- Upgrade dependencies
- Modify Gradle
- Rewrite architecture

unless explicitly requested.

---

# Feature Isolation

A feature should own:

- Presentation
- ViewModel
- Domain
- Repository
- Navigation
- DI

Avoid leaking implementation details into other features.

---

# Architecture Change Rules

If implementation requires architectural changes:

Do not proceed immediately.

Instead:

1. Explain the reason.

2. Describe the impact.

3. List affected modules.

4. Suggest alternatives.

Architecture changes require explicit approval.

---

# Code Generation Rules

Generate code incrementally.

Preferred:

One layer

↓

Compile mentally

↓

Next layer

Avoid generating an entire feature in a single step.

---

# Refactoring During Feature Development

Do not refactor unrelated code while implementing a feature.

If improvement opportunities are discovered:

Document them separately.

Do not mix feature implementation with project-wide refactoring.

---

# Feature Completion Checklist

A feature is complete only when:

□ All layers are implemented

□ Navigation connected

□ Dependencies registered

□ UI matches Design System

□ Error handling implemented

□ Loading implemented

□ Empty state implemented

□ Build succeeds

□ Tests added (when required)

□ Documentation updated (if applicable)

---

# Anti-patterns

Do not:

```text
UI

↓

Repository
```

Do not:

```text
ViewModel

↓

HttpClient
```

Do not:

```text
Screen

↓

Business Logic
```

Do not:

```text
Random helper classes
```

Do not:

Implement everything in one file.

---

# Decision Priority

When implementing a feature:

1. Understand the requirement

2. Inspect existing project

3. Reuse existing code

4. Design architecture

5. Implement foundation

6. Implement UI

7. Integrate

8. Verify

Never change this order.

---

# Final Rule

A feature is not defined by its UI.

A feature is a complete unit consisting of domain logic, state management, data flow, user interaction, dependency integration, and verification.

Always build the feature from the inside out, not from the screen inward.