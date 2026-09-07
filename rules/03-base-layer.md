# 03-base-layer.md

# Purpose

This document defines how the agent should work with the project's shared foundation.

The goal is to maximize reuse, avoid duplicate abstractions, and ensure consistency across the codebase.

A Base Layer should emerge naturally from repeated patterns, not from anticipation.

---

# Base Layer Philosophy

The Base Layer exists to provide reusable behavior.

It should NOT exist merely to reduce the number of lines of code.

Prefer:

Meaningful shared behavior

over

Generic inheritance.

---

# Base Layer Decision Process

Before creating any shared abstraction, follow this order:

```text
Inspect Existing Base
        ↓
Reuse Existing Base
        ↓
Extend Existing Base
        ↓
Create New Base (only if justified)
```

Never skip the inspection phase.

---

# Inspection Rules

Before creating a new base component, search the project for:

- BaseViewModel
- BaseUiState
- UiState
- DataState
- UiEvent
- UiEffect
- Intent
- Repository
- BaseRepository
- UseCase
- BaseUseCase
- BaseScreen
- PermissionController / AppPermission
- AppDispatchers
- Error Model
- Result Wrapper
- Design System
- Navigation abstraction

Do not duplicate existing concepts.

---

# Reuse First

Always prefer:

Reuse

over

Reimplementation.

If an existing abstraction already satisfies the requirement, reuse it.

Avoid introducing similar classes with different names.

Bad example:

```text
BaseViewModel

ScreenViewModel

CoreViewModel

AbstractViewModel
```

Choose one standard.

---

# BaseViewModel Rules

Create a BaseViewModel only if it provides meaningful shared behavior.

Examples:

- Shared StateFlow management
- Shared Event handling
- Shared loading helpers
- Common coroutine utilities
- Error mapping
- State reducers

Do NOT create a BaseViewModel simply to avoid repeating:

```kotlin
class FeatureViewModel : ViewModel()
```

Generic inheritance without shared behavior is prohibited.

---

# Repository Rules

Repositories should represent business capabilities.

Avoid:

```text
BaseRepository<T>
```

that only wraps CRUD operations.

A repository should expose meaningful business operations.

Example:

```kotlin
interface AudioRepository {

    suspend fun record()

    suspend fun delete()

    suspend fun rename()

}
```

Instead of:

```kotlin
BaseRepository<T>
```

---

# UseCase Rules

A UseCase should encapsulate business logic.

Do not create:

```text
GetDataUseCase

↓

repository.getData()
```

without adding business value.

A UseCase should:

- Validate
- Transform
- Combine
- Coordinate
- Enforce business rules

---

# Shared State Rules

Inspect existing state patterns.

Possible patterns:

```kotlin
sealed interface DataState<out T>
```

or

```kotlin
UiState<T>
```

Choose one.

Do not introduce multiple incompatible state models.

---

# Event Rules

Events should represent one-time actions.

Examples:

- Navigate
- Show Snackbar
- Open Dialog
- Finish Screen

Do not use StateFlow for one-time events.

Prefer:

SharedFlow

or

Channel

depending on project conventions.

---

# Intent Rules

Intent represents user actions.

Examples:

```text
Load

Refresh

Delete

Retry

Search
```

Intent should be immutable.

Intent should not contain UI components.

---

# Result Wrapper Rules

If the project already defines:

- Result
- Resource
- Outcome
- Either

Reuse it.

Do not introduce another wrapper with similar behavior.

---

# Dispatcher Rules

Before creating:

```kotlin
AppDispatchers
```

verify whether the project already provides:

- CoroutineDispatcher abstraction
- DispatcherProvider
- AppDispatchers

Reuse existing implementations.

---

# Error Model Rules

Reuse existing:

- AppError
- UiError
- DomainError

Avoid creating multiple error hierarchies.

---

# Foundation Before Feature

Every feature should first understand the project foundation.

Implementation order:

```text
Inspect Base
        ↓
Inspect Design System
        ↓
Inspect State Pattern
        ↓
Inspect Repository Pattern
        ↓
Inspect Navigation
        ↓
Inspect DI
        ↓
Implement Feature
```

Never begin directly with UI.

---

# Shared Behavior Requirements

Promote behavior into the Base Layer only if ALL are true:

✓ Used by multiple features

✓ Stable

✓ Well-tested

✓ Reduces duplication

✓ Improves readability

✓ Improves maintainability

If any condition is false, keep the implementation local.

---

# Generic Abstraction Rules

Avoid creating:

```kotlin
BaseRepository<T>

BaseUseCase<P, R>

BaseManager<T>

BaseService<T>
```

unless they provide real reusable behavior.

Generic code is not automatically better code.

---

# Inheritance Rules

Prefer:

Composition

over

Inheritance.

Before extending a base class, ask:

- Is inheritance necessary?
- Would composition make responsibilities clearer?

Choose the simplest solution.

---

# Naming Rules

Shared abstractions should have clear intent.

Prefer:

```text
AudioRepository

FileScanner

PermissionManager

ThemeManager
```

Avoid:

```text
Helper

Util

Manager

Common

Base

Core
```

unless the name accurately describes its responsibility.

---

# Base Layer Review Checklist

Before creating a new base component:

□ Did I search the project?

□ Does a similar abstraction already exist?

□ Is it used by multiple features?

□ Does it provide meaningful shared behavior?

□ Can composition solve this instead?

□ Will it reduce duplication?

□ Will it simplify maintenance?

Only then create a new shared abstraction.

---

# Anti-patterns

Do not create:

```text
BaseRepository<T>

↓

No shared behavior
```

Do not create:

```text
BaseUseCase

↓

Single repository call
```

Do not create:

```text
BaseViewModel

↓

Only extends ViewModel
```

Do not create:

```text
Utils.kt

↓

Everything
```

Avoid "God Base Classes".

---

# Decision Priority

When introducing shared code:

1. Reuse existing implementation

2. Extend existing implementation

3. Compose reusable behavior

4. Create a new shared abstraction

Never reverse this order.

---

# Final Rule

A Base Layer is a product of repeated patterns.

Do not design an abstract foundation before the project demonstrates the need for it.

Prefer concrete implementations until shared behavior naturally emerges.