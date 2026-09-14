# 01-tech-stack.md

# Purpose

This document defines the approved technology stack for the Android project.

The agent MUST follow these rules whenever generating, modifying, or reviewing production code.

Do not introduce alternative technologies unless explicitly requested.

---

# Project Stack

| Category | Technology | Platform Support |
|----------|------------|------------------|
| Language | Kotlin (2.0+) | Multiplatform (`commonMain`, Android, iOS, Desktop) |
| UI | Compose Multiplatform / Jetpack Compose | Multiplatform (`commonMain`, Android, iOS, Desktop) |
| Design | Material 3 (Design Tokens) | Multiplatform |
| Architecture | MVI / UDF + Clean Architecture | Multiplatform (`commonMain`) |
| Async | Kotlin Coroutines + Flow | Multiplatform (`commonMain`) |
| UI State | StateFlow (`BaseViewModel`) | Multiplatform (`commonMain`) |
| Dependency Injection | Koin (4.x Multiplatform) | Multiplatform (`commonMain` + Platform Hooks) |
| Networking | Ktor Client (3.x Multiplatform) | Multiplatform (OkHttp / Darwin / CIO) |
| Local Database | Room KMP (2.7+) / SQLiteDriver | Multiplatform (`BundledSQLiteDriver`) |
| Memory Management | Stack vs Heap Architecture (`@JvmInline value class`, Primitive State, Zero-Heap Compose) | Multiplatform (`commonMain` + ART/JVM) |
| Preferences | DataStore Preferences / Multiplatform Settings | Multiplatform |
| Serialization | kotlinx.serialization | Multiplatform (`commonMain`) |
| Image Loading | Coil 3 (Multiplatform) | Multiplatform |
| Navigation | Navigation 3 / Type-Safe NavKeys | Multiplatform |
| Build | Gradle Kotlin DSL + KMP Plugin | Multiplatform |
| Dependency Management | Version Catalog (`libs.versions.toml`) | Multiplatform |
| Annotation Processing | KSP (Multiplatform) | Multiplatform |

---

# Core Principles

Every implementation should be:

- Simple
- Readable
- Testable
- Maintainable
- Lifecycle-safe
- Multiplatform-Ready (Maximize `commonMain` code sharing)
- Production-ready

Prefer existing project conventions over introducing new patterns.

---

# Approved Technologies

The agent SHOULD use:

- Kotlin Multiplatform & Compose Multiplatform
- Material 3 Design System
- Coroutines & Flow (StateFlow, SharedFlow)
- BaseViewModel (MVI UDF pattern)
- Koin Dependency Injection
- Ktor Client (Multiplatform Engines)
- Room KMP Database
- Coil 3 Image Loading
- kotlinx.serialization & kotlinx.datetime
- Version Catalog (`libs.versions.toml`)
- Gradle Kotlin DSL & KSP

---

# Forbidden Technologies

Unless explicitly requested, NEVER introduce:

- Java
- Hilt
- Dagger
- Retrofit
- Gson
- Moshi
- RxJava
- LiveData
- AsyncTask
- ButterKnife
- DataBinding
- ViewBinding for new Compose screens

Existing legacy code may continue using these technologies if migration is not part of the requested task.

---

# Kotlin Rules

All new production source files MUST use Kotlin.

Prefer:

- data class
- sealed interface
- object
- value class (when appropriate)
- extension functions
- null safety
- immutable collections

Avoid Java-style coding patterns.

---

# Compose Rules

All newly created screens MUST use Jetpack Compose.

Do not create XML layouts unless:

- The project already requires XML for that screen.
- Migration is not requested.
- The task explicitly requires XML.

---

# State Management

Screen state MUST use:

StateFlow

Example:

```kotlin
private val _uiState = MutableStateFlow(HomeUiState())
val uiState = _uiState.asStateFlow()
```

Do not expose MutableStateFlow publicly.

Do not use LiveData for new features.

---

# Asynchronous Programming

Use:

- suspend functions
- CoroutineScope
- viewModelScope
- lifecycleScope
- Flow
- SharedFlow

Never use:

- Thread
- Timer
- AsyncTask
- RxJava

---

# Networking

Networking MUST use:

Ktor

Preferred flow:

Remote API

↓

DTO

↓

Mapper

↓

Domain Model

↓

UI

Do not expose DTOs outside the Data layer.

---

# Local Storage

Persistent storage MUST use Room.

Preferred flow:

Entity

↓

DAO

↓

LocalDataSource

↓

Repository

↓

Domain

Never expose Entity to Presentation.

---

# Dependency Injection

Use:

Koin

Prefer constructor injection.

Never manually instantiate:

- Repository
- UseCase
- Service
- DataSource

inside ViewModel or Composable.

---

# Image Loading

Use:

Coil

Do not introduce Glide or Picasso.

---

# Serialization

Preferred:

kotlinx.serialization

Do not introduce Gson or Moshi unless required for legacy compatibility.

---

# Gradle

Use:

Gradle Kotlin DSL

Do not generate Groovy build scripts.

Use Version Catalog whenever possible.

Dependencies should be added through:

libs.versions.toml

instead of hardcoded versions.

---

# Annotation Processing

Preferred:

KSP

Avoid:

kapt

unless required by an existing dependency.

---

# Android APIs

Prefer modern AndroidX APIs.

Avoid deprecated APIs.

If both a legacy and a modern API exist, choose the modern implementation.

---

# Decision Checklist

Before introducing a new technology, verify:

□ Does the project already use it?

□ Is it officially approved?

□ Can an existing library solve the problem?

□ Will it increase maintenance cost?

□ Is migration required?

If any answer is uncertain, reuse the existing stack.

---

# Anti-patterns

Do not:

Compose
↓

Retrofit

Compose
↓

Database

Compose
↓

Business Logic

ViewModel
↓

File I/O

Repository
↓

UI State

DTO
↓

Presentation

Entity
↓

Composable

---

# Technology Decision Priority

When multiple solutions exist:

1. Existing project implementation
2. Android official recommendation
3. Kotlin idiomatic solution
4. Simplicity
5. Performance
6. Maintainability

---

# Final Rule

The agent must NOT introduce a new technology solely because it is newer or more popular.

Consistency across the codebase is more valuable than adopting additional frameworks.

Always prefer the existing project stack.