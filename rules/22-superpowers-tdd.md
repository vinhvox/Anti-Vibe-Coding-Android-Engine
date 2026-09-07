# 22-superpowers-tdd.md

# SUPERPOWERS EXECUTION & TDD MANDATE

## Purpose

This rule enforces the Test-Driven Development (TDD) cycle and Evidence-Based Verification principles adapted from Jesse Vincent's `obra/superpowers` framework, ensuring strict quality control before any logic is shipped.

---

## 1. Core Principles

### A. Test-First Execution (Red Phase)
- **Mandate**: For any new feature, ViewModel, Reducer, UseCase, Repository, or Data Engine logic, the AI MUST write unit tests before implementing the logic.
- **Verification**: Run the test suite to confirm tests fail as expected (Red Phase).

### B. Minimal Implementation (Green Phase)
- **Mandate**: Write the minimal code required to pass the failing tests.
- **Verification**: Run the test suite to confirm tests pass cleanly (Green Phase).

### C. Refactor & Polish (Refactor Phase)
- **Mandate**: Refactor and optimize code while preserving test coverage. Align with Antigravity UI, Compose, Navigation 3, and Koin rules.
- **Verification**: Confirm all tests remain passing post-refactor.

### D. Evidence Over Claims
- **Mandate**: Never claim a feature, fix, or refactor is complete without providing concrete test execution logs or command outputs.

---

## 2. Integration with Antigravity Pipeline

- **Workflow Entry**: `workflow/05-feature-development.md` (Step 2: TDD Gate)
- **Quality Gate**: `rules/21-enforcement-engine.md`
- **Memory Retention**: Store failed test patterns in `memory/06-error-fix.md` and successful refactoring patterns in `memory/05-pattern.md`.
