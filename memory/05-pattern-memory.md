# 05-pattern-memory.md

# Pattern Memory

## Purpose

This document defines how the AI discovers, validates, stores, and applies recurring engineering patterns throughout a project.

Pattern Memory captures stable implementation patterns that appear consistently across the codebase.

Its purpose is to improve consistency, accelerate implementation, and reduce unnecessary rediscovery.

Patterns represent how the project is built in practice.

---

# Philosophy

Projects naturally develop recurring patterns.

Good engineers recognize them.

Great engineers reuse them.

The AI should learn from repetition, not from isolated examples.

Patterns should guide implementation without replacing reasoning.

---

# Primary Goal

Continuously identify reusable implementation patterns and apply them consistently across future work.

Pattern Memory should reduce:

Repeated analysis

Repeated design decisions

Code duplication

Architectural inconsistency

---

# Pattern Lifecycle

Every pattern follows this lifecycle.

```text
Observe
    │
    ▼
Collect Examples
    │
    ▼
Detect Similarity
    │
    ▼
Validate Stability
    │
    ▼
Store Pattern
    │
    ▼
Reuse
    │
    ▼
Refine
```

Patterns evolve over time.

---

# What Is A Pattern

A pattern is a repeatable engineering solution that appears consistently across multiple implementations.

Examples:

Feature structure

Repository implementation

ViewModel architecture

Compose screen layout

Error handling flow

Dependency Injection style

Navigation structure

Testing approach

Mapper implementation

State management

Patterns should describe reusable structure rather than specific code.

---

# What To Store

Pattern Memory may store:

Feature architecture

Folder organization

Repository template

ViewModel template

UiState template

Compose layout hierarchy

Navigation implementation

Error handling flow

Loading strategy

Caching strategy

Mapper conventions

Result handling

Dependency Injection style

Testing structure

Logging style

Naming conventions

Code organization

---

# What NOT To Store

Never store:

One-time implementations

Experimental code

Temporary fixes

Bug-specific logic

Generated code

Feature-specific business logic

Incomplete implementations

Patterns require repetition.

---

# Pattern Detection

A pattern becomes eligible only if:

It appears in multiple independent implementations.

It is consistent.

It aligns with project architecture.

It has been accepted by the user.

It improves maintainability.

One implementation is never enough.

---

# Pattern Structure

Each pattern should include:

Identifier

Name

Category

Intent

Structure

Required Components

Optional Components

Dependencies

Known Variations

Examples

Confidence

Patterns should be understandable without reading source code.

---

# Pattern Categories

Architecture

Feature

Repository

UseCase

ViewModel

Compose UI

Navigation

Dependency Injection

Room

Networking

Testing

Security

Performance

Utilities

Code Style

---

# Pattern Validation

Before storing verify:

Is it used consistently?

Is it reusable?

Does it respect project rules?

Does it improve maintainability?

If not,

do not store it.

---

# Pattern Retrieval

Before creating new code:

Retrieve:

Relevant feature pattern

↓

Relevant architecture pattern

↓

Relevant UI pattern

↓

Relevant implementation pattern

Prefer adapting an existing pattern over inventing a new one.

---

# Pattern Evolution

Patterns are living knowledge.

If a better implementation becomes the project standard:

Validate.

Replace the old pattern.

Archive the previous version.

Never silently overwrite stable patterns.

---

# Pattern Confidence

Confidence depends on:

Frequency

Consistency

Acceptance

Architecture alignment

Project adoption

Frequently reused patterns have higher confidence.

---

# Pattern Reuse

Reuse patterns whenever possible.

Adapt patterns when necessary.

Avoid copying blindly.

Patterns should be applied thoughtfully according to context.

---

# Pattern Conflict

If multiple patterns exist:

Prefer:

Current project standard

↓

Most frequently used

↓

Most recently validated

↓

Android best practice

Always explain deviations when necessary.

---

# Pattern Scope

Patterns may exist at different levels.

Project Pattern

↓

Module Pattern

↓

Feature Pattern

↓

Component Pattern

↓

Implementation Pattern

Higher-level patterns have greater priority.

---

# Self Validation

Before applying a pattern verify:

Does this pattern match the current feature?

Does it still reflect the current architecture?

Has it been replaced?

Is there a better project-specific pattern?

If uncertain,

revalidate before use.

---

# Anti-patterns

Never:

Create patterns from one example.

Treat experiments as standards.

Force a pattern where it does not fit.

Ignore architecture.

Duplicate similar patterns.

Apply patterns mechanically.

---

# Discovered Patterns

<!-- 
  Format: - **Pattern Name** | Where: file/module | Reuse: when to apply
-->

- **MVI Contract Pattern** | Where: Every feature's `Contract.kt` | Reuse: `data class XxxState : UiState` + `sealed interface XxxIntent : MVIIntent` + `sealed interface XxxEffect : MVIEffect`
- **Stateful/Stateless Screen Split** | Where: `*Route` (stateful) → `*Screen` (stateless) | Reuse: Every new screen
- **UseCase invoke() operator** | Where: All `*UseCase` classes | Reuse: `operator fun invoke(): Flow<DataState<T>>`
- **DataState sealed class** | Where: Domain layer | Reuse: `DataState.Loading`, `DataState.Success(data)`, `DataState.Error(message)`
- **FileItem extension functions** | Where: `FileItem.kt` extensions | Reuse: `isArchive()`, `isImage()`, `isVideo()`, etc.
- **Koin viewModel/factory pattern** | Where: `AppModule.kt` | Reuse: `viewModel { XxxViewModel(get(), get()) }` + `factory { XxxUseCase(get()) }`
- **Dialog state in MVI** | Where: Every ViewModel with dialogs | Reuse: Boolean flag in State + `OnDismissDialogs` intent resets all flags
- **Conditional FileAction visibility** | Where: `FileActionBottomSheet.kt` | Reuse: Show/hide actions based on `FileItem` properties (extension, vault status, etc.)
- **Zip Slip guard** | Where: `ArchiveRepositoryImpl.kt` | Reuse: `canonicalPath.startsWith(targetDir.canonicalPath)` before writing any extracted file

---

# Final Rule

Pattern Memory exists to preserve the engineering habits of the project.

The AI should recognize recurring structures,

reuse them consistently,

and continuously refine them as the project evolves.