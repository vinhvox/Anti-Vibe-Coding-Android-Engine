# 20-testing.md

# Purpose

This document defines the project's testing architecture and quality assurance principles.

Testing exists to ensure:

- Correctness
- Reliability
- Maintainability
- Regression prevention
- Safe refactoring

Testing is part of feature development.

A feature is not considered complete until it has been appropriately tested.

---

# Core Principles

Testing is a development activity.

Testing is not a post-development task.

Every layer should be testable.

Prefer automated tests over manual verification.

---

# Testing Pyramid

Follow the testing pyramid.

```text
            UI Tests
               ▲
      Integration Tests
               ▲
          Unit Tests
```

Most tests should be Unit Tests.

---

# Testing Levels

Supported test types:

- Unit Test
- Integration Test
- UI Test
- Snapshot Test (optional)
- Benchmark Test
- Macrobenchmark
- Baseline Profile Verification

Each serves a different purpose.

---

# Layer Responsibilities

Presentation

Test:

- ViewModel
- UiState
- Navigation Events

Never test Compose rendering through business assertions.

---

Domain

Test:

- UseCases
- Validators
- Business Rules

Domain tests should not depend on Android.

---

Data

Test:

- Repository
- Mapper
- DAO
- RemoteDataSource
- LocalDataSource

Use fake implementations whenever possible.

---

# Unit Test Rules

Unit tests should:

- Run fast
- Be deterministic
- Be isolated

Avoid:

- Network
- Database
- Android Framework

during unit tests.

---

# Integration Test Rules

Integration tests verify collaboration between components.

Examples:

```text
Repository

↓

RemoteDataSource

↓

Mapper
```

or

```text
Repository

↓

Room
```

Keep scope focused.

---

# UI Tests

UI tests should verify:

- User interactions
- Navigation
- Visible state
- Accessibility

Avoid asserting implementation details.

---

# ViewModel Testing

Test:

- Initial state
- Loading state
- Success state
- Error state
- Empty state
- Retry behavior

ViewModels should be fully testable without Android UI.

---

# Repository Testing

Verify:

- Cache behavior
- Offline strategy
- Error mapping
- Retry
- Synchronization

Use fake dependencies.

---

# Flow Testing

Test:

- Emission order
- Cancellation
- Completion
- Errors
- Multiple collectors

Use Turbine or equivalent Flow testing tools.

---

# Coroutine Testing

Use:

```kotlin
runTest
```

Inject dispatchers.

Avoid:

```kotlin
Dispatchers.IO
```

inside tests.

---

# Fake Dependencies

Prefer:

- Fake Repository
- Fake API
- Fake DAO
- Fake Preferences

Use mocks only when behavior verification is necessary.

---

# Mocking

Mock only external collaborators.

Avoid excessive mocking.

Prefer real business logic.

---

# Database Testing

Use:

In-memory Room Database

Test:

- CRUD
- Queries
- Transactions
- Migration

---

# Network Testing

Never depend on production servers.

Use:

- Fake API
- Mock Server

Verify:

- Parsing
- Error handling
- Timeout
- Retry

---

# Navigation Testing

Verify:

- Navigation Events
- Destination creation
- Argument serialization

Avoid testing NavController internals.

---

# Compose Testing

Verify:

- Visible content
- User actions
- Semantics
- Accessibility

Avoid depending on layout implementation.

---

# Accessibility Testing

Verify:

- Content descriptions
- Click targets
- Screen reader compatibility

Accessibility is part of quality.

---

# Benchmark Testing

Measure:

- Startup
- Scroll
- Search
- Database
- Rendering

Benchmark results should guide optimization.

---

# Baseline Profiles

Generate and verify Baseline Profiles.

Release builds should benefit from profile-guided optimization.

---

# Code Coverage

Coverage is a metric, not a goal.

High coverage does not guarantee quality.

Prefer meaningful tests over artificial coverage.

---

# Naming Convention

Use descriptive names.

Preferred:

```text
givenValidInput_whenSearching_thenReturnsFiles
```

Avoid:

```text
test1()

testSearch()
```

---

# Test Structure

Prefer:

```text
Arrange

↓

Act

↓

Assert
```

Keep tests simple and focused.

---

# One Assertion Principle

Each test should verify one behavior.

Avoid testing multiple unrelated scenarios.

---

# Test Data

Prefer:

- Builders
- Fixtures
- Factory Methods

Avoid duplicated setup code.

---

# Regression Tests

Every bug fix should include a regression test whenever practical.

Prevent bugs from reappearing.

---

# Continuous Integration

CI should execute:

- Unit Tests
- Static Analysis
- Lint
- Benchmark (when configured)

Builds should fail on critical test failures.

---

# Performance of Tests

Tests should:

- Execute quickly
- Be repeatable
- Run independently

Avoid flaky tests.

---

# Review Checklist

Before completing a feature:

□ Unit Tests added

□ ViewModel tested

□ UseCase tested

□ Repository tested

□ Error cases tested

□ Empty state tested

□ Loading state tested

□ Regression covered

□ CI compatible

□ Tests deterministic

---

# Anti-patterns

Do not:

Test private methods

Do not:

Sleep()

inside tests

Do not:

Depend on production services

Do not:

Use Android Framework in unit tests

Do not:

Mock everything

Do not:

Ignore failure cases

---

# Decision Priority

When writing tests:

1. Business Rules

2. ViewModel

3. Repository

4. Integration

5. UI

6. Benchmark

7. Coverage

---

# Final Rule

Testing is part of the implementation, not an optional step.

Every feature should be designed for testability, verified through automated tests, and protected against future regressions.