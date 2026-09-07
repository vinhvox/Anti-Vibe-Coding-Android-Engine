---
name: code-review
description: Phase 6 workflow to perform structured static review, architecture validation, error handling, performance, and security inspection before completion.
triggers:
  - "code review"
  - "review code"
  - "kiểm tra chất lượng code"
prerequisites:
  - ".antigravity/workflow/05-feature-development.md"
next_step: ".antigravity/workflow/07-testing-validation.md"
---
# 06-code-review.md

# Purpose

This document defines the project's code review workflow.

Every implementation must undergo a structured self-review before being considered complete.

Code review ensures correctness, maintainability, consistency, and long-term quality.

No implementation is complete until it has been reviewed.

---

# Philosophy

Writing code is only half of the work.

Reviewing code is part of implementation.

The goal is to improve the solution, not to validate the first attempt.

---

# Core Principles

Always:

Review before delivering.

Verify before assuming.

Refactor when beneficial.

Follow project standards.

Preserve architecture.

---

# Code Review Workflow

Every implementation follows this workflow.

```text
Implementation
        │
        ▼
Architecture Review
        │
        ▼
Code Quality Review
        │
        ▼
Error Handling Review
        │
        ▼
Performance Review
        │
        ▼
Security Review
        │
        ▼
Testing Review
        │
        ▼
Documentation Review
        │
        ▼
Ready
```

---

# Step 1 — Architecture Review

Verify:

- Module boundaries
- Layer responsibilities
- Dependency direction
- Single Responsibility Principle
- Existing architecture preserved

Reject implementations that violate architecture.

---

# Step 2 — Code Quality Review

Inspect:

- Naming
- Readability
- Maintainability
- Simplicity
- Duplication
- Complexity

Prefer simple solutions.

---

# Step 3 — Reuse Review

Verify:

- Existing components reused
- Existing UseCases reused
- Existing Repository reused
- Existing utilities reused
- Existing extensions reused

Avoid duplicate implementations.

---

# Step 4 — State Management Review

Verify:

- Single source of truth
- Immutable UiState
- Correct StateFlow usage
- Predictable state transitions

Avoid inconsistent state handling.

---

# Step 5 — Compose Review

Verify:

- Stable parameters
- Correct remember usage
- Correct rememberSaveable usage
- Proper state hoisting
- Minimal recomposition

Composable functions should remain lightweight.

---

# Step 6 — ViewModel Review

Verify:

- Business logic delegated to UseCases
- UI state exposed correctly
- No Android UI dependencies
- Proper coroutine scope usage

ViewModels should coordinate, not implement business logic.

---

# Step 7 — Error Handling Review

Verify:

- Loading state
- Success state
- Error state
- Empty state
- Retry behavior

Every user-facing flow should handle failures gracefully.

---

# Step 8 — Performance Review

Inspect:

- Main thread usage
- Recomposition
- Lazy loading
- Memory allocations
- Database queries
- Network requests

Avoid unnecessary work.

---

# Step 9 — Security Review

Verify:

- Secrets not exposed
- Sensitive logs avoided
- Input validated
- Storage protected
- Network configuration secure

Security is part of code quality.

---

# Step 10 — Dependency Review

Verify:

- Correct Dependency Injection
- No manual singleton creation
- No service locator usage
- Proper scopes

Dependencies should remain explicit.

---

# Step 11 — Testing Review

Verify:

- Unit tests updated
- Integration tests updated (if applicable)
- Existing tests still valid
- New behavior covered

Testing should match implementation changes.

---

# Step 12 — Documentation Review

Verify whether updates are required for:

- README
- Architecture
- Public APIs
- Feature documentation
- Migration notes

Documentation should reflect implementation.

---

# Technical Debt Review

Identify:

- Duplicate logic
- Temporary workarounds
- TODO items
- Large classes
- Large Composables
- Tight coupling

Only introduce technical debt with explicit justification.

---

# Step 7 — Enforcement Engine Audit (Gates E1 to E28)

The reviewer MUST audit all modified files against the 28 Quality Gates defined in `rules/21-enforcement-engine.md`:

- **Gates E1 — E5 (Architecture):** Layer boundaries respected, BaseViewModel used, MVI Intent purity.
- **Gates E6 — E10 (State & Navigation):** Navigation 3 or type-safe routes used, 400ms debounce, SSOT state flow.
- **Gates E11 — E15 (Compose & Design System):** 100% semantic `AppTheme` tokens (zero hardcoded colors or dp), explicit `key` and `contentType` on Lazy Layouts, stable parameters.
- **Gates E16 — E20 (Async & Concurrency):** Main-thread purity, structured `safeLaunch` scopes, non-blocking I/O.
- **Gate E21 (Enforcement Audit):** Comprehensive audit confirmation.
- **Gate E27 (World-Class Aesthetic):** Zero purple-on-dark neon clichés, 0.5dp subtle borders, tonal surfaces, 8-pt grid.
- **Gate E28 (Ubiquitous Language):** Domain precision, zero fluff.

---

# Review Checklist

Before approving implementation:

□ Architecture preserved and layer boundaries respected

□ Active Stack Drivers (Koin/Hilt, Ktor/Retrofit) properly implemented

□ Quality Gates E1 — E28 verified with ZERO violations

□ No duplicate code or lazy try-catch sprawl

□ Clear, self-documenting naming

□ Correct state management (StateFlow immutable read-only exposure)

□ Compose recomposition stability verified (explicit `key` on LazyColumn/Row)

□ UI/UX Pro Max verified (0.5dp subtle borders, 8-pt grid, anti-AI-slop)

□ Error handling complete at I/O Boundary (`AppResult<T>`)

□ Real build verification succeeded (`./gradlew compileDebugKotlin` / `test`)

□ Documentation and Living Plans updated

---

# Anti-patterns

Do not:

Approve code because it compiles.

Do not:

Ignore architecture violations.

Do not:

Leave duplicated logic.

Do not:

Ignore TODOs without justification.

Do not:

Accept unnecessary complexity.

Do not:

Merge unreviewed code.

---

# Decision Priority

When reviewing code:

1. Correctness

2. Architecture

3. Maintainability

4. Reusability

5. Performance

6. Security

7. Readability

8. Style

---

# Exit Criteria

A code review is complete only if:

✓ Requirements satisfied

✓ Architecture preserved

✓ Engineering Rules followed

✓ Code reusable

✓ Tests updated

✓ No critical issues remain

✓ Documentation consistent

---

# Final Rule

The first implementation is rarely the best implementation.

Every change should leave the codebase cleaner, safer, and easier to maintain than before.