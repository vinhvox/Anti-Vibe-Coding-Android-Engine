# 12-dependency-injection.md

# Purpose

This document defines the dependency injection architecture for the project.

Dependency Injection exists to:

- Reduce coupling
- Improve testability
- Increase modularity
- Simplify object creation
- Improve maintainability

The project uses:

- Koin
- Constructor Injection
- Feature-based Modules

Avoid Service Locator patterns.

---

# Core Principles

Dependencies should be injected.

Objects should never create their own dependencies.

Preferred:

```text
Koin

↓

Constructor Injection

↓

Class
```

Avoid:

```kotlin
class UserRepository {

    private val api = UserApi()

}
```

---

# Approved DI Framework

Only use:

- Koin

Do not introduce:

- Hilt
- Dagger
- Manual Service Locator

---

# Constructor Injection

Always prefer constructor injection.

Good:

```kotlin
class HomeViewModel(
    private val getFiles: GetFilesUseCase
)
```

Avoid:

```kotlin
lateinit var repository: Repository
```

or

```kotlin
val repository = Repository()
```

---

# Dependency Direction

Dependencies must always point inward.

```text
Presentation
        │
        ▼
Domain
        │
        ▼
Data
```

Never reverse this direction.

---

# Module Organization

Modules should be organized by feature.

Example:

```text
core/

feature/

home/

homeModule

settings/

settingsModule

player/

playerModule
```

Avoid a single massive module.

---

# Core Modules

Typical core modules:

```text
networkModule

databaseModule

dispatcherModule

navigationModule

preferenceModule

permissionModule

loggerModule

serializationModule
```

Each module owns one responsibility.

---

# Feature Modules

Every feature owns its own DI module.

Example:

```text
feature/home

↓

homeModule
```

Register only feature-specific dependencies.

---

# Registration Rules

Singleton:

Use when there should be exactly one instance.

Examples:

- HttpClient
- RoomDatabase
- Preferences
- Logger
- Navigator
- Repository (when stateless)

Example:

```kotlin
single {
    HttpClient(...)
}
```

---

# Factory Rules

Use factory when every request should create a new instance.

Examples:

- Formatter
- Temporary Mapper
- Utility with mutable state

Example:

```kotlin
factory {
    FileFormatter()
}
```

---

# ViewModel Rules

Register ViewModels using Koin ViewModel DSL.

Example:

```kotlin
viewModel {
    HomeViewModel(
        get()
    )
}
```

Never instantiate ViewModel manually.

---

# Scoped Dependencies

Use Scope only when object lifetime must match a feature lifecycle.

Examples:

- Wizard Flow
- Checkout Flow
- Authentication Flow

Avoid unnecessary scopes.

---

# Interface Binding

Depend on abstractions.

Preferred:

```text
UserRepository

↓

UserRepositoryImpl
```

Register:

```kotlin
single<UserRepository> {

    UserRepositoryImpl(
        get()
    )

}
```

Avoid depending directly on implementations.

---

# Dependency Graph

Preferred flow:

```text
ViewModel

↓

UseCase

↓

Repository

↓

RemoteDataSource

↓

HttpClient
```

Never skip layers.

---

# Module Dependencies

Feature modules may depend on:

Core modules.

Core modules must never depend on feature modules.

---

# Lazy Injection

Prefer constructor injection.

Use lazy injection only when:

- Expensive initialization
- Circular dependency cannot be avoided

Avoid overusing lazy injection.

---

# Circular Dependencies

Circular dependencies are prohibited.

Bad:

```text
Repository

↓

UseCase

↓

Repository
```

Refactor instead.

---

# Runtime Parameters

Use parameters only for runtime values.

Examples:

- File ID
- User ID
- Configuration

Avoid passing dependencies through parameters.

---

# Singleton Rules

Singletons must be:

- Thread-safe
- Stateless where possible
- Immutable where practical

Avoid mutable global state.

---

# Dispatcher Injection

Dispatchers should be injected.

Example:

```kotlin
data class AppDispatchers(
    val main: CoroutineDispatcher,
    val io: CoroutineDispatcher,
    val default: CoroutineDispatcher
)
```

Avoid hardcoding Dispatchers.IO throughout the codebase.

---

# Testability

Every dependency should be replaceable.

Tests should provide fake or mock implementations through DI.

Avoid hidden dependencies.

---

# Initialization

Application startup should initialize:

- Core modules
- Feature modules
- Third-party SDKs (if required)

Avoid eager initialization of heavy objects unless necessary.

---

# Module Naming

Use descriptive names.

Good:

```text
networkModule

databaseModule

homeModule

settingsModule
```

Avoid:

```text
module1

commonModule

utilsModule
```

---

# Dependency Lifetime

Choose the smallest appropriate lifetime.

Priority:

```text
Factory

↓

Scoped

↓

Singleton
```

Do not default everything to Singleton.

---

# Logging

Log dependency initialization only when useful for debugging.

Avoid excessive startup logs in Release builds.

---

# Review Checklist

Before completing dependency registration:

□ Constructor Injection

□ No manual object creation

□ Feature module exists

□ Interface binding used

□ Correct lifetime selected

□ ViewModel registered

□ No circular dependency

□ Dispatchers injected

□ Testable

□ Minimal module responsibility

---

# Anti-patterns

Do not:

ViewModel()

inside Composable

Do not:

Repository()

inside ViewModel

Do not:

HttpClient()

inside Repository

Do not:

Global singleton object

Do not:

Service Locator

Do not:

Circular dependency

---

# Decision Priority

When introducing a dependency:

1. Can an existing dependency be reused?

2. Should it be an interface?

3. What is its lifecycle?

4. Which module owns it?

5. Is it testable?

6. Does it introduce coupling?

---

# Final Rule

Dependency Injection is responsible only for object creation and wiring.

Business logic belongs to UseCases.

State belongs to ViewModels.

Persistence belongs to Repositories.

Keep dependencies explicit, constructor-injected, modular, and easy to replace.