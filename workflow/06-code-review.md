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

This document defines the project's **2-Tier Code Review Workflow**:
1. **Tier 1 — Mandatory Dev Mirror Self-Review (Gate E39):** Every implementation (`dev-builder` or Main Agent) must undergo a physical read-back (`view_file` / `git diff`) and 5-Mirror self-refactor before leaving the builder's hands.
2. **Tier 2 — Uncompromising Blind-Context QA Audit with Bounded 3-Round Convergence (Gates E33.4 & E40):** Independent prosecutorial verification by `qa-enforcer` (`enable_write_tools = false`), strictly governed by the **4 Laws of Bounded Convergence (`MAX_QA_ROUNDS = 3`)**:
   - **Law 1 (`E40.1` — Max 3 Rounds & Circuit Breaker):** Stop patching if Round 3 still yields `VERDICT: REJECTED`; trigger `🛑 CIRCUIT BREAKER TRIGGERED: ARCHITECTURAL PIVOT REQUIRED` and escalate to the user with 2 architectural pivot options.
   - **Law 2 (`E40.2` — Delta-Only Scope in Rounds 2 & 3):** Round 1 performs a Full-Scope PR scan; Rounds 2 & 3 inspect ONLY prior `[CLUSTER-XX]` resolution and the **Delta Diff** (modified lines + direct callers).
   - **Law 3 (`E40.3` — Pattern-Clustered Defect Batching & Systemic Sweep):** Group identical violations into `[CLUSTER-XX]` in Round 1 so `dev-builder` performs a Systemic Codebase Sweep to eradicate 100% of occurrences in one pass.
   - **Law 4 (`E40.4` — Zero Moving Goalposts & Compact Ledger):** Untouched Round-1 code not flagged in Round 1 cannot be newly flagged in Rounds 2–3; prior clusters are tracked in a compact `RESOLVED ✅` / `UNRESOLVED ❌` ledger.

No implementation is complete until both Tier 1 Mirror Self-Review and Tier 2 QA Audit have passed within $\le 3$ rounds.

---

# Philosophy

Writing code (Draft 1) is only half of the work.

Looking in the mirror (`view_file` physical read-back) and refactoring Draft 1 into Clean Draft 2 is a mandatory part of implementation.

The goal of Tier 1 Mirror Self-Review is to catch and eliminate one's own blind spots before handing off to Tier 2 QA, and the goal of Tier 2 Bounded 3-Round QA is to converge rapidly without infinite token-wasting ping-pong loops.

---

# Core Principles

Always:

Physically read back (`view_file`) every modified file after editing.

Audit against the 5 Mirror Lenses (Minimalism, Naming, Vitals, Architecture/UI, 6-Dimension Edge Cases).

Self-refactor Draft 1 into Clean Draft 2 before running final tests.

Output the `🪞 Dev Mirror Self-Review` evidence block before dispatching `qa-enforcer`.

Enforce the 4 Laws of Bounded 3-Round QA Convergence (`Gate E40`): Max 3 Rounds + Circuit Breaker, Delta-Only Rounds 2–3, Pattern-Clustered `[CLUSTER-XX]` batching + Systemic Sweep, and Zero Moving Goalposts.

---

# Code Review Workflow

Every implementation follows this workflow.

```text
Implementation (Draft 1)
        │
        ▼
🪞 Step 0: Physical Read-Back (view_file / git diff — Gate E39.1)
        │
        ▼
Architecture & Minimalism Review (Mirror 1)
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
⚖️ Tier 2: Bounded 3-Round QA-Enforcer Audit (Gate E40: Round 1 Full-Scope [CLUSTER-XX] ➔ Rounds 2-3 Delta-Only ➔ Circuit Breaker at Round 3)
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

# Review Checklist

Before approving implementation:

□ Architecture preserved

□ Rules followed

□ No duplicate code

□ Clear naming

□ Correct state management

□ Error handling complete

□ Performance acceptable

□ Security verified

□ DI correct

□ Tests updated

□ Documentation updated

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