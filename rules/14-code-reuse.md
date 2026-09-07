# 14-code-reuse.md

# Purpose

This document defines the project's code reuse strategy.

The objective is to maximize consistency, reduce duplication, simplify maintenance, and accelerate feature development.

Before writing new code, always determine whether an equivalent implementation already exists.

---

# Core Principles

Prefer reuse over creation.

Prefer extension over duplication.

Prefer composition over inheritance.

Never create a new implementation before inspecting the existing codebase.

---

# Reuse Priority

Always follow this order:

```text
Existing Feature
        ↓
Core Component
        ↓
Shared Utility
        ↓
Base Layer
        ↓
Extension Function
        ↓
New Implementation
```

Never reverse this order.

---

# Project Inspection

Before implementing anything, inspect for:

## UI

- Components
- Dialogs
- Bottom Sheets
- Loading Views
- Error Views
- Empty States
- Top Bars
- Cards

---

## Domain

- Existing UseCases
- Existing Models
- Existing Validators

---

## Data

- Repository
- DataSource
- DAO
- API
- Mapper

---

## Core

- Managers
- Helpers
- Extensions
- Utilities
- Navigation
- Permission
- Logger

---

## Design System

- Colors
- Typography
- Shapes
- Icons
- Spacing

Only after inspection should implementation begin.

---

# Duplicate Detection

Before creating:

- Component
- Class
- Function
- Extension
- Mapper
- Utility

Search the project.

If similar functionality already exists:

Reuse it.

Avoid duplicate logic with different names.

---

# Extension First

Prefer extension functions for reusable behavior.

Good:

```kotlin
fun File.formatSize(): String
```

Avoid:

```kotlin
FileFormatter.format(file)
```

when no state is required.

---

# Composition Over Inheritance

Prefer:

```text
Composable

↓

Composable
```

instead of:

```text
BaseComposable

↓

ChildComposable

↓

AnotherComposable
```

Inheritance should be used only when a strong "is-a" relationship exists.

---

# Utility Rules

Utility classes should:

- Be stateless
- Have one responsibility
- Be reusable

Avoid "Utils" classes containing unrelated methods.

Bad:

```text
CommonUtils

AppUtils

HelperUtils
```

Prefer:

```text
DateFormatter

FileSizeFormatter

PermissionChecker

UriExtensions
```

---

# Shared Components

A component should move into the Design System when:

✓ Used in multiple features

✓ Same behavior

✓ Same appearance

✓ Improves consistency

Otherwise:

Keep it inside the feature.

---

# Base Classes

Avoid creating base classes unless there is proven duplication.

Prefer interfaces or composition.

Bad:

```text
BaseRepository

↓

Everything
```

Good:

```text
Repository Interface

↓

Concrete Implementation
```

---

# Generic Abstractions

Do not create abstractions too early.

Example:

Avoid:

```text
BaseManager<T>

BaseRepository<T>

BaseScreen<T>

BaseDialog<T>
```

unless multiple concrete implementations justify them.

---

# Copy-Paste Policy

Never copy an existing implementation without evaluating whether it can be reused or extracted.

When duplication is discovered:

1. Identify common behavior.
2. Extract reusable code.
3. Keep feature-specific behavior local.

---

# Feature Isolation

Reusable code belongs in:

```text
core/

designsystem/

common/
```

Feature-specific logic remains inside:

```text
feature/
```

Avoid moving feature-specific logic into shared modules prematurely.

---

# Naming Consistency

Reuse existing terminology.

If the project uses:

```text
FileItem
```

Do not introduce:

```text
DocumentItem

StorageItem

MediaItem
```

for the same concept.

Consistency is more important than personal preference.

---

# Mapper Reuse

Each transformation should have one canonical mapper.

Preferred:

```kotlin
FileEntity.toDomain()

FileDto.toDomain()

FileDomain.toUi()
```

Avoid duplicate mapping logic.

---

# Extension Organization

Organize extensions by receiver.

Example:

```text
StringExtensions.kt

FileExtensions.kt

ContextExtensions.kt

FlowExtensions.kt
```

Avoid large extension files containing unrelated receivers.

---

# Constants

Shared constants belong in centralized definitions.

Avoid magic numbers and duplicated string literals.

Good:

```kotlin
AppConstants.MAX_SELECTION
```

Avoid:

```kotlin
const val LIMIT = 100
```

inside multiple files.

---

# Reusable Business Logic

If the same business rule appears in multiple features:

Extract it into:

- UseCase
- Validator
- Domain Service

Do not duplicate validation logic.

---

# Review Before Creating

Before adding a new file ask:

- Does something similar already exist?
- Can it be extended?
- Can it be parameterized?
- Can composition solve this?
- Does this improve maintainability?

If the answer is "Yes", prefer reuse.

---

# Refactoring Rules

When duplicate code is identified:

Refactor only the duplicated portion.

Do not rewrite unrelated code.

Avoid large refactors during feature implementation.

---

# Review Checklist

Before completing implementation:

□ Existing code inspected

□ Existing component reused

□ No duplicated logic

□ No duplicated mapper

□ No duplicated validator

□ No unnecessary base class

□ Composition preferred

□ Extensions reused

□ Naming consistent

□ Shared code located appropriately

---

# Anti-patterns

Do not:

Copy

↓

Rename

↓

Paste

Do not:

Create BaseClass for one implementation

Do not:

Duplicate validation

Do not:

Duplicate API calls

Do not:

Duplicate Composable

Do not:

Duplicate Mapper

Do not:

Introduce generic abstractions prematurely

---

# Decision Priority

When implementing new functionality:

1. Search existing implementation

2. Reuse existing abstraction

3. Extend existing component

4. Extract common behavior

5. Create new implementation

Never create first.

---

# Final Rule

Every new line of code increases maintenance cost.

Before writing new code, determine whether the existing architecture already provides the required capability.

The best implementation is often the one that does not need to be written.