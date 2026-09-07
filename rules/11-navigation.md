# 11-navigation.md

# Purpose

This document defines the navigation architecture using Android Navigation 3.

Navigation should be:

- Type-safe
- Feature-oriented
- Lifecycle-aware
- Testable
- Decoupled
- Predictable

Navigation is a Presentation concern.

Business logic must never depend on navigation.

---

# Navigation Stack

Approved navigation technology:

- Android Navigation 3
- Kotlin Serialization
- Type-safe destinations
- Compose
- Koin

Avoid:

- Navigation XML
- Safe Args
- String Routes
- Manual route parsing

---

# Navigation Philosophy

Navigation represents user flow.

Navigation should describe:

Where the user goes.

It should NOT describe:

How the destination is implemented.

---

# Navigation Architecture

Preferred architecture:

```text
Navigation 3 NavDisplay
          │
          ▼
Stateful Router (*Route)
   ├── Injects ViewModel via Koin (`koinViewModel()`)
   ├── Manages Permissions & Dialogs
   └── Collects UiState & One-off Effects
          │
          ▼
Stateless Screen (*Screen)
   └── Pure Declarative UI with @Preview
```

NavDisplay renders Destination keys mapped to **Stateful Route** composables (`*Route`), NEVER directly to stateful ViewModel-injected screens. Navigation actions are emitted as pure Effects from the ViewModel up to the Route, then routed via the Navigator.

ViewModel never owns NavController.

---

# Destination Definition

Every destination should be a strongly typed object.

Preferred:

```kotlin
@Serializable
data object Home
```

```kotlin
@Serializable
data class Detail(
    val id: Long
)
```

Avoid:

```kotlin
const val HOME = "home"

const val DETAIL = "detail/{id}"
```

No string routes.

---

# Destination Rules

Destinations should only contain:

- Navigation arguments
- Stable identifiers

Avoid placing:

- Repository
- ViewModel
- UI State
- Large Objects

inside destinations.

---

# Navigation Arguments

Arguments must be:

- Immutable
- Serializable
- Minimal

Good:

```kotlin
@Serializable
data class PhotoDetail(
    val photoId: Long
)
```

Bad:

```kotlin
PhotoDetail(
    photo = Photo(...)
)
```

Only pass identifiers.

---

# Navigation Ownership

Navigation belongs to:

Presentation Layer.

Never:

Repository

↓

Navigation

Never:

UseCase

↓

Navigation

---

# Navigator Pattern

Prefer a dedicated Navigator abstraction.

Example:

```text
HomeNavigator

SettingsNavigator

FileNavigator
```

Avoid exposing NavController throughout the app.

---

# Navigation Events

ViewModel emits navigation events.

Example:

```text
Click File

↓

OpenFile(id)

↓

UI

↓

Navigator

↓

Navigate()
```

Avoid calling navigate() inside ViewModel.

---

# Back Navigation

Use system back handling.

Avoid manually manipulating the back stack unless required.

Always respect Android back behavior.

---

# Deep Links

Deep links should map directly to typed destinations.

Example:

```text
URI

↓

Destination

↓

Screen
```

Avoid manually parsing query parameters.

---

# Nested Navigation

Use nested navigation for:

- Authentication
- Main Application
- Settings
- Onboarding

Avoid one massive navigation graph.

---

# Feature Navigation

Every feature owns its own navigation.

Preferred:

```text
feature/

home/

navigation/

HomeDestination

HomeNavigator
```

Avoid centralizing all destinations in one file.

---

# Start Destination

Application startup should define exactly one root destination.

Example:

```text
Splash

↓

Login

↓

Home
```

Avoid runtime string decisions.

---

# Navigation State

Navigation state should not be mixed with UI state.

Avoid:

```kotlin
HomeUiState(
    navigate = true
)
```

Prefer:

Navigation Event.

---

# Passing Data

Only pass:

- IDs
- Filters
- Query
- Small configuration values

Never pass:

- Bitmap
- List
- Entity
- DTO
- Repository
- ViewModel

Load data in the destination.

---

# Returning Results

Prefer:

Shared ViewModel

or

SavedStateHandle

depending on Navigation 3 support.

Avoid global callbacks.

---

# Dialog Navigation

Dialogs should be destinations.

Avoid boolean flags controlling multiple dialogs.

---

# Bottom Sheet Navigation

Bottom sheets should be represented as destinations when navigation semantics exist.

Avoid embedding navigation logic inside UI.

---

# Multi-Module Navigation

Each feature exposes only:

Destination

Navigator Contract

Avoid exposing internal implementation.

---

# Authentication Flow

Preferred:

```text
Splash

↓

Authentication Check

↓

Login

↓

Home
```

Authentication decisions belong outside UI.

---

# Error Navigation

Errors should not navigate automatically.

Only navigate after explicit user intent when appropriate.

---

# Testing

Navigation should be testable.

Test:

- Destination creation
- Argument serialization
- Navigation events
- Deep links

Avoid relying solely on manual testing.

---

# Review Checklist

Before completing navigation:

□ Type-safe destinations

□ No string routes

□ ViewModel emits Events only

□ Navigator abstraction

□ Immutable arguments

□ Feature isolation

□ Nested graphs when appropriate

□ No large objects passed

□ Testable

---

# Anti-patterns

Do not:

String Routes

↓

"home/{id}"

Do not:

NavController

↓

ViewModel

Do not:

Repository

↓

Navigation

Do not:

DTO

↓

Destination

Do not:

Entity

↓

Destination

Do not:

Business Logic

↓

Navigation

---

# Decision Priority

When implementing navigation:

1. Type-safe Destination

2. Existing Feature Navigation

3. Navigator abstraction

4. Minimal arguments

5. Nested Navigation

6. Testability

7. Maintainability

---

# Final Rule

Navigation should describe user movement, not business behavior.

Every destination should be strongly typed, isolated within its feature, and easy to test.

Prefer type-safe navigation over string-based routing in all new implementations.