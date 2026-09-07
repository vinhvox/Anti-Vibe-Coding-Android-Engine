---
name: feature-development
description: Phase 5 workflow to execute the actual coding of features incrementally across Data, Domain, Presentation, Navigation, and DI layers based on an approved plan.
triggers:
  - "feature development"
  - "implement feature"
  - "write feature code"
prerequisites:
  - ".antigravity/workflow/04-implementation-planning.md"
  - "./.antigravity/plan/<task_name>_plan.md"
next_step: ".antigravity/workflow/06-code-review.md"
---
# 05-feature-development.md

# Purpose

This document defines the standard workflow for implementing new features.

Every feature should be developed incrementally, consistently, and in accordance with the project's architecture and engineering rules.

The objective is to produce maintainable, testable, scalable, and production-ready features.

---

# Philosophy

A feature is more than UI.

A feature consists of:

- Business Logic
- State Management
- Data Flow
- Navigation
- Error Handling
- Testing
- Documentation

A feature is complete only when all parts are implemented.

---

# Development Workflow

Every feature follows this lifecycle (Superpowers TDD + Antigravity CTO Standard).

```text
Implementation Plan
        │
        ▼
Prepare Structure
        │
        ▼
Superpowers TDD Gate (Write Failing Tests - RED)
        │
        ▼
Implement Data & Domain Layer (Minimal Code - GREEN)
        │
        ▼
Implement Presentation & Navigation Layer
        │
        ▼
Dependency Injection
        │
        ▼
Refactor & Verify (Evidence Over Claims)
        │
        ▼
Self Review & Memory Update
        │
        ▼
Ready
```

---

# Step 1 — Prepare Feature Structure

Create only the required files.

Typical feature structure:

feature/
└── search/
├── presentation/
├── domain/
├── data/
├── navigation/
└── di/

Avoid creating unnecessary files.

---

# Step 2 — Implement Data Layer

Implement:

- API
- DTO
- Mapper
- Repository
- LocalDataSource
- RemoteDataSource

Responsibilities:

- Retrieve data
- Store data
- Map data

No business logic.

---

# Step 3 — Implement Domain Layer

Implement:

- UseCases
- Domain Models
- Validators

Responsibilities:

- Business Rules
- Validation
- Business Decisions

Domain must not depend on Android Framework.

---

# Step 4 — Implement Presentation Layer

Implement:

- Screen
- ViewModel
- UiState
- UiEvent
- UiAction

Presentation responsibilities:

- Render state
- Receive user actions
- Send events

Business logic belongs in UseCases.

---

# Step 5 — Connect Navigation

Implement:

- Destination
- Route
- Arguments
- Result Handling

Navigation should remain independent.

---

# Step 6 — Dependency Injection

Register:

- Repository
- UseCases
- ViewModel

Dependencies should be injected.

Never instantiate manually.

---

# Step 7 — Error Handling

Handle:

Loading

Success

Error

Empty

Retry

Every feature should provide a complete user experience.

---

# Step 8 — Loading Strategy

Avoid blocking UI.

Prefer:

Loading Indicator

↓

Content

↓

Progressive Updates

Do not freeze the interface.

---

# Step 9 — State Management

Single source of truth.

Preferred:

UiState

↓

StateFlow

↓

Compose

Avoid duplicated state.

---

# Step 10 — Data Flow

Data moves in one direction.

```text
UI

↓

ViewModel

↓

UseCase

↓

Repository

↓

Data Source
```

Avoid circular communication.

---

# Step 11 — UI Development

UI should:

- Follow Design System
- Be responsive
- Support dark mode
- Handle empty states
- Handle loading
- Handle errors

Never hardcode design values.

---

# Step 12 — Performance

Avoid:

- Unnecessary recomposition
- Blocking Main Thread
- Heavy computations in Compose
- Duplicate network requests

Performance should be considered during implementation.

---

# Step 13 — Accessibility

Verify:

- Content descriptions
- Touch targets
- Dynamic font support
- Screen reader compatibility

Accessibility is mandatory.

---

# Step 14 — Logging

Log only:

- Errors
- Important events
- Debug information (Debug builds)

Avoid logging sensitive information.

---

# Step 15 — Testing

Verify:

- Business Logic
- ViewModel
- Repository
- Navigation
- UI

Feature implementation is incomplete without testing.

---

# Deliverables

A completed feature should include:

- UI
- ViewModel
- UseCases
- Repository
- Navigation
- DI
- Tests

---

# Feature Completion Checklist

Before marking a feature complete:

□ Architecture respected

□ Rules followed

□ Reused existing components

□ No duplicated logic

□ State handled correctly

□ Error states implemented

□ Loading implemented

□ Navigation completed

□ Tests added

□ Build successful

---

# Anti-patterns

Do not:

Implement business logic inside Compose.

Do not:

Access Repository directly from UI.

Do not:

Instantiate dependencies manually.

Do not:

Duplicate existing components.

Do not:

Skip error handling.

Do not:

Ignore loading states.

---

# Decision Priority

When implementing a feature:

1. Correctness

2. Architecture

3. Simplicity

4. Reuse

5. Testability

6. Performance

7. UX

---

# Final Rule

A feature is complete only when it is functional, testable, maintainable, and fully integrated into the application's architecture.