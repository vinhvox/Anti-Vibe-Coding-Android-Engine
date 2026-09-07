# 02-architecture.md

# Purpose

This document defines the architectural principles for the Android project.

The goal is to ensure that every feature follows a consistent, maintainable, and scalable architecture.

The architecture should evolve naturally with the project while avoiding unnecessary complexity.

---

# Core Principles

The project follows:

- Feature-first organization
- MVVM / MVI (Antigravity UDF)
- Clean Architecture
- Repository Pattern
- Unidirectional Data Flow (UDF)

REAL DEVICE DATA MANDATE:
NEVER return hardcoded fake/mock data from production Repositories or Use Cases (e.g. dummy `listOf(...)` for file scanning or storage calculations). ALL data providers MUST scan, read, and manipulate real files on the device's storage (`Environment.getExternalStorageDirectory()`) safely using `Dispatchers.IO`.

---

# Architecture Philosophy

Every architectural decision should prioritize:

1. Simplicity
2. Maintainability
3. Testability
4. Scalability
5. Reusability

Never introduce abstractions without a clear benefit.

---

# Dependency Direction

Dependencies MUST always flow in one direction.

```text
Presentation
      │
      ▼
Domain
      │
      ▼
Data
```

Never reverse dependencies.

---

# Layer Responsibilities

## Presentation

Responsible for:

- **Stateful Routers (`*Route` / `*Router`):**
  - Dependency Injection entry point (`koinViewModel()`).
  - Lifecycle-aware State collection (`collectAsStateWithLifecycle()`).
  - Permission requests (`rememberLauncherForActivityResult`).
  - Dialog / BottomSheet / System Event triggers.
  - Side-effect handling & navigation routing.
- **Stateless Screens (`*Screen` / `*Content`):**
  - 100% Pure UI rendering (Stateless Function of State).
  - Mandatory `@Preview` for Light/Dark modes & `PreviewParameterProvider`.
  - Dispatching user intents `(UiIntent) -> Unit`.
- **MVI Coordination:**
  - `BaseViewModel<State, Intent, Effect>` managing state and executing business use cases.

Must NOT contain:

- Business logic
- Network logic
- Database logic
- File operations
- Direct ViewModel references inside child/stateless composables

---

## Domain

Responsible for:

- Business rules
- Use Cases (e.g. real storage scanning algorithms)
- Domain models
- Repository contracts

Domain must NOT know:

- Room
- Ktor
- Android SDK UI
- Compose
- Koin

---

## Data

Responsible for:

- API
- Database
- Real Disk Storage / StatFs / File System API
- Mappers
- Repository implementation

Data layer must NOT contain:

- UI state
- Compose code
- Android Views

---

# Feature Structure

Preferred structure:

```text
feature/
└── home/
    ├── data/
    ├── domain/
    ├── presentation/
    ├── navigation/
    └── di/
```

Every feature should remain self-contained.

---

# Review Checklist

Before implementation:

□ Is the dependency direction correct?

□ Is business logic in the correct layer?

□ Are real device data sources used (No fake/mock data)?

□ Are models separated correctly?

□ Is feature isolation preserved?

□ Are responsibilities clearly separated?

---

# Related Files

- Brain: `brain/02-context-engine.md` (codebase context collection)
- Workflow: `workflow/02-codebase-analysis.md`, `workflow/03-architecture-design.md`
- Rules: `03-base-layer.md`, `04-feature-construction.md`, `07-viewmodel.md`, `21-enforcement-engine.md`, `25-solid-principles.md`
- Skills: `architecture.md`, `mvi.md`, `clean-code.md`, `design-patterns.md`

---

# Layer Boundary Violations — Forbidden Imports

## Presentation Layer MUST NOT import:
- `room` / `dao` / `database`
- `ktor` / `HttpClient`
- `java.io.File` (for direct file operations)
- `java.sql` / `SQLite`

## Domain Layer MUST NOT import:
- `room` / `dao` / `database`
- `ktor` / `HttpClient`
- `compose` / `android.widget`
- `koin`
- `android.*` (except `android.os.Parcelable`)

## Data Layer MUST NOT import:
- `compose` / `android.widget` / `android.view`
- ViewModel / UiState / MVIIntent

---

# Stub/Placeholder Data Rule

Production Repositories and UseCases MUST NEVER:

```kotlin
// ❌ FORBIDDEN — Fake delay + hardcoded data
suspend fun scan(): List<Result> {
    delay(1500)  // fake progress
    return listOf(
        Result("Duplicate Photos", "1.2 GB"),  // hardcoded fake
        Result("Cache Files", "800 MB")         // hardcoded fake
    )
}
```

Instead:

```kotlin
// ✅ CORRECT — Real device data
suspend fun scan(): Flow<DataState<List<Result>>> = flow {
    emit(DataState.Loading)
    val realFiles = withContext(Dispatchers.IO) {
        directory.listFiles()?.map { file ->
            Result(file.name, file.length())
        } ?: emptyList()
    }
    emit(DataState.Success(realFiles))
}.catch { emit(DataState.Error(it.message)) }
```

If a feature's backend is not yet implemented:
1. Mark it with `⚠️ STUB` comment
2. Inform the user explicitly
3. NEVER report the feature as "complete"

---

# ENFORCEMENT

Before reporting ANY architecture-related task as complete:

## Check 1: Dependency Direction
- Scan import statements in modified files
- REJECT if Domain imports from `presentation/` or `data/`
- REJECT if Presentation imports from `data/` directly (must go through Domain)

## Check 2: No Fake Data
- Scan for `delay(` + hardcoded `listOf(` in Repository/UseCase files
- REJECT if found in production code
- If stub is necessary, explicitly label and inform user

## Check 3: Layer Responsibility
- REJECT if ViewModel contains `File()`, `HttpClient`, `dao` access
- REJECT if Repository contains Compose imports or UI state
- REJECT if UseCase contains Android SDK UI imports

## Check 4: Feature Isolation
- REJECT if a change in feature A requires modifications in feature B (unless shared component)
- New features must be self-contained under their own module directory

---

# Final Rule

Architecture is the skeleton of the application.

Every feature must respect the established layer boundaries, dependency direction, and separation of concerns.

Violations compound over time and make the codebase unmaintainable.