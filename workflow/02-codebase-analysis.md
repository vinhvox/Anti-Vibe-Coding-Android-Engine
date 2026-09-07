---
name: codebase-analysis
description: Phase 2 workflow to inspect existing codebase, locate modules, detect reusable components, and analyze impact.
triggers:
  - "codebase analysis"
  - "analyze codebase"
  - "inspect existing code"
prerequisites:
  - ".antigravity/workflow/01-requirement-analysis.md"
next_step: ".antigravity/workflow/03-architecture-design.md"
---
# 02-codebase-analysis.md

# Purpose

This document defines the project's codebase analysis workflow.

Before implementing any change, the existing codebase must be inspected to understand the current architecture, identify reusable components, and minimize duplication.

Implementation must not begin until the relevant parts of the project have been analyzed.

---

# Philosophy

Understand the existing system before modifying it.

Every codebase already contains knowledge.

Prefer understanding over rewriting.

Prefer reuse over recreation.

---

# Core Principles

Always:

Analyze before implementing.

Search before creating.

Reuse before duplicating.

Preserve architectural consistency.

Never ignore existing implementations.

---

# Codebase Analysis Workflow

Every implementation must follow this workflow.

```text
Requirement
      │
      ▼
Locate Relevant Modules
      │
      ▼
Inspect Existing Features
      │
      ▼
Inspect Shared Components
      │
      ▼
Inspect Architecture
      │
      ▼
Identify Reuse Opportunities
      │
      ▼
Identify Impact
      │
      ▼
Ready for Architecture Design
```

---

# Step 1 — Locate Relevant Modules

Determine which modules are related.

Inspect:

- app
- feature
- core
- data
- domain
- designsystem
- benchmark

Do not inspect unrelated modules.

---

# Step 2 — Inspect Existing Features

Search for features with similar behavior.

Examples:

- Search
- Recorder
- Player
- Settings
- File Manager
- Permission Flow

Determine whether functionality already exists.

---

# Step 3 — Inspect Shared Components

Inspect reusable UI.

Examples:

- Buttons
- Dialogs
- Bottom Sheets
- Loading
- Error Views
- Empty Views
- App Bars
- Cards
- List Items

Reuse before creating.

---

# Step 4 — Inspect ViewModels

Search for:

- Existing UiState
- Existing Intent
- Existing Actions
- Existing Events

Avoid duplicating state management.

---

# Step 5 — Inspect Domain Layer

Inspect:

- UseCases
- Validators
- Business Services
- Domain Models

Reuse business logic whenever possible.

---

# Step 6 — Inspect Data Layer

Inspect:

- Repository
- RemoteDataSource
- LocalDataSource
- DAO
- API
- Mapper

Avoid duplicate data access logic.

---

# Step 7 — Inspect Core Layer

Inspect:

- Managers
- Extensions
- Utilities
- Logger
- Permission
- Navigation
- Security
- Ads

Prefer existing infrastructure.

---

# Step 8 — Inspect Design System

Inspect:

- Colors
- Typography
- Icons
- Spacing
- Shapes
- Components
- Animation

Never introduce inconsistent UI.

---

# Step 9 — Inspect Navigation

Determine:

- Existing destinations
- Navigation graph
- Arguments
- Deep links
- Back stack behavior

Follow the existing navigation architecture.

---

# Step 10 — Inspect Dependency Injection

Identify:

- Existing modules
- Providers
- Scopes
- Singleton objects

Do not manually instantiate shared dependencies.

---

# Step 11 — Inspect Existing Patterns

Determine project conventions.

Examples:

- Repository Pattern
- State Holder
- MVI
- Mapper
- Result Wrapper
- Error Handling

Follow established patterns.

---

# Step 12 — Search for Reuse

Before writing new code, search for:

- Components
- UseCases
- Repository
- Mapper
- Extension Functions
- Utilities
- Constants

Always reuse first.

---

# Step 13 — Impact Analysis

Determine which parts of the application will be affected.

Examples:

- UI
- ViewModel
- Repository
- API
- Room
- Navigation
- Tests

Document expected impact.

---

# Dependency Analysis

Identify upstream and downstream dependencies.

Examples:

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
▼
Remote / Local
```

Understand the complete dependency chain before making changes.

---

# Architecture Validation

Verify that the planned implementation is consistent with:

- Module boundaries
- Layer responsibilities
- Dependency direction
- Naming conventions
- Design System

---

# Duplicate Detection

Search for similar:

- Files
- Classes
- Functions
- Extensions
- Composables
- Mappers

Do not create duplicate implementations.

---

# Technical Debt Detection

Identify:

- Duplicate logic
- Dead code
- Tight coupling
- Large classes
- Large Composables
- Repeated business logic

Document issues, but only refactor when within scope.

---

# Deliverables

Codebase analysis should produce:

- Related Modules
- Existing Implementations
- Reusable Components
- Dependencies
- Architecture Notes
- Risks
- Impact Analysis
- Reuse Opportunities

---

# Review Checklist

Before leaving this phase:

□ Relevant modules identified

□ Existing features inspected

□ Shared components inspected

□ ViewModels reviewed

□ Domain reviewed

□ Data layer reviewed

□ Core layer reviewed

□ Design System reviewed

□ Navigation reviewed

□ DI reviewed

□ Reuse opportunities documented

□ Impact analyzed

□ Architecture understood

---

# Anti-patterns

Do not:

Implement without searching.

Do not:

Create duplicate components.

Do not:

Ignore project conventions.

Do not:

Bypass shared infrastructure.

Do not:

Refactor unrelated code.

Do not:

Introduce inconsistent architecture.

---

# Decision Priority

When analyzing the codebase:

1. Locate related modules

2. Understand existing architecture

3. Search reusable code

4. Detect duplicates

5. Analyze dependencies

6. Analyze impact

7. Preserve consistency

Only then proceed to architecture design.

---

# Final Rule

Every existing implementation represents accumulated engineering knowledge.

Understanding and reusing that knowledge is always preferable to creating new code without context.