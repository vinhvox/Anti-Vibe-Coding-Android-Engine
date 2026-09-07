# 07-viewmodel.md

# Purpose

This document defines how ViewModels should be designed and implemented.

A ViewModel coordinates UI interactions and business execution.

It is NOT responsible for business rules, persistence, or networking.

---

# ViewModel Philosophy

A ViewModel coordinates.

It does not own business rules.

Think of the ViewModel as the bridge between:

```text
Router (*Route)
    ↓
ViewModel
    ↓
UseCase
```

Never bypass this flow. ViewModels are injected into Stateful Routers and NEVER into Stateless Screens.

---

# Responsibilities

A ViewModel is responsible for:

- Managing UI State
- Receiving User Intent
- Calling UseCases
- Updating State
- Emitting UI Events
- Coordinating Screen Logic

A ViewModel must NOT:

- Parse JSON
- Read files
- Access DAO
- Access HttpClient
- Execute SQL
- Render UI

---

# Dependency Rules

Inject dependencies via constructor.

Good:

```kotlin
class HomeViewModel(
    private val getFiles: GetFilesUseCase
) : ViewModel()
```

Avoid:

```kotlin
class HomeViewModel : ViewModel() {

    private val repository = FileRepository()

}
```

Never instantiate dependencies manually.

---

# State Ownership

Every screen owns exactly one UI State.

```text
Screen

↓

UiState

↓

Render
```

Avoid multiple independent StateFlows for screen rendering.

Good:

```kotlin
data class HomeUiState(
    val files: List<FileItem> = emptyList(),
    val isLoading: Boolean = false,
    val error: UiError? = null
)
```

---

# State Exposure

Always expose immutable state.

Good:

```kotlin
private val _uiState = MutableStateFlow(HomeUiState())

val uiState = _uiState.asStateFlow()
```

Never expose MutableStateFlow.

---

# Intent Handling

User actions should be represented as Intents.

Example:

```kotlin
sealed interface HomeIntent {

    data object Load : HomeIntent

    data class Search(
        val keyword: String
    ) : HomeIntent

    data class Delete(
        val id: Long
    ) : HomeIntent

}
```

ViewModel receives Intents.

---

# Event Handling

One-time actions should use Events.

Examples:

- Navigate
- Snackbar
- Toast
- Open Dialog
- Finish Screen

Do not encode one-time events inside UiState.

Preferred:

SharedFlow

---

# State Updates

Always use immutable updates.

Good:

```kotlin
_uiState.update {

    it.copy(
        isLoading = true
    )

}
```

Avoid mutating nested properties.

---

# Loading State

Every asynchronous operation should expose loading.

Example:

```text
Idle

↓

Loading

↓

Success

↓

Idle
```

Avoid hidden loading behavior.

---

# Error Handling

Convert domain errors into UI errors.

```text
DomainError

↓

UiError

↓

UiState
```

Do not expose Exception directly.

Bad:

```kotlin
error = exception
```

---

# Coroutine Rules

Launch coroutines only from:

viewModelScope

Preferred:

```kotlin
viewModelScope.launch {

}
```

Never create custom CoroutineScope.

---

# Dispatcher Rules

Dispatchers should come from:

UseCase

or

Repository

Avoid switching dispatchers inside ViewModel unless necessary for UI coordination.

---

# Business Logic

Business logic belongs in:

UseCase

Examples:

- Search
- Validation
- Filtering
- Merge
- Export

ViewModel should only coordinate.

---

# Navigation

Navigation should be emitted as Events.

Bad:

```kotlin
navController.navigate(...)
```

inside ViewModel.

Good:

```text
ViewModel

↓

NavigationEvent

↓

UI

↓

NavController
```

---

# Screen Lifecycle

Load initial data using:

```kotlin
init { }
```

or

```kotlin
onIntent(Load)
```

Avoid duplicate loading during recomposition.

---

# Saved State

Use SavedStateHandle only for:

- Navigation arguments
- Process restoration

Do not use it as a replacement for repositories.

---

# UI State Design

Prefer one state object.

Good:

```kotlin
HomeUiState
```

Avoid:

```text
loadingFlow

filesFlow

searchFlow

errorFlow

refreshFlow
```

for the same screen.

---

# Reducer Pattern

Prefer centralized updates.

Example:

```kotlin
private fun reduce(
    reducer: HomeUiState.() -> HomeUiState
) {
    _uiState.update {
        it.reducer()
    }
}
```

Avoid scattering state updates across many methods.

---

# Long Running Tasks

For operations like:

- Export
- Scan
- Backup
- Upload

Expose progress.

Example:

```text
0%

↓

35%

↓

70%

↓

100%
```

Do not freeze UI.

---

# Retry Strategy

Recoverable failures should expose Retry.

Preferred flow:

```text
Error

↓

Retry

↓

Loading

↓

Success
```

---

# Cancellation

Always respect coroutine cancellation.

Never swallow:

```kotlin
CancellationException
```

---

# Logging

Log meaningful information only.

Avoid logging:

- Password
- Token
- Personal Data

Use structured logs when possible.

---

# Review Checklist

Before completing a ViewModel:

□ Constructor Injection

□ Immutable UiState

□ No MutableStateFlow exposed

□ No Repository creation

□ No DAO access

□ No HttpClient

□ Business logic delegated

□ Uses viewModelScope

□ Emits Events correctly

□ Handles Loading

□ Handles Error

□ Supports Retry

---

# Anti-patterns

Do not:

ViewModel

↓

HttpClient

Do not:

ViewModel

↓

DAO

Do not:

ViewModel

↓

Business Logic

Do not:

MutableStateFlow public

Do not:

20+ StateFlows

Avoid God ViewModels.

---

# Decision Priority

When implementing ViewModel:

1. Existing project conventions

2. Immutable State

3. Single UiState

4. Intent-driven actions

5. Event-based side effects

6. Delegation to UseCases

7. Small focused methods

---

# ENFORCEMENT: Mandatory Architecture Compliance Checks

Before reporting ANY ViewModel-related task as complete, the AI MUST verify the following.
Failure to pass ALL checks means the task is NOT complete and code is REJECTED.

## Rule 1: BaseViewModel Inheritance (ZERO EXCEPTIONS)

ALL ViewModels in the project MUST extend `BaseViewModel<State, Intent, Effect>`.
Direct extension of `ViewModel()` or `AndroidViewModel()` is **ABSOLUTELY FORBIDDEN**.

```kotlin
// ✅ CORRECT — The ONLY acceptable pattern
class XxxViewModel(
    private val useCase: XxxUseCase
) : BaseViewModel<XxxState, XxxIntent, XxxEffect>(
    initialState = XxxState()
)

// ❌ REJECTED — Direct ViewModel extension is FORBIDDEN
class XxxViewModel : ViewModel()
```

If the AI encounters an existing ViewModel violating this rule, it MUST:
1. STOP current work.
2. REPORT the violation to the user.
3. REFUSE to add new code to the violating ViewModel until it is migrated.

## Rule 2: safeLaunch Enforcement (ZERO EXCEPTIONS)

ALL coroutine launches inside ViewModels MUST use `BaseViewModel.launch {}` (which wraps `safeLaunch` with the global `CoroutineExceptionHandler`).

`viewModelScope.launch {}` is **ABSOLUTELY FORBIDDEN** inside any ViewModel.

```kotlin
// ✅ CORRECT
launch { useCase.invoke() }

// ❌ REJECTED — Bypasses global error handling, will crash on exception
viewModelScope.launch { useCase.invoke() }
```

## Rule 3: Dead Code Prevention

Before completing any ViewModel modification:
1. Scan for methods that are no longer referenced by any Intent in `onIntent()`.
2. Any unreferenced private method is dead code and MUST be deleted immediately.
3. Never leave old method signatures alongside new replacements.

## Rule 4: Intent Exhaustiveness

The `when (intent)` block in `onIntent()` MUST handle every sealed subclass.
If a new Intent is added to the Contract, it MUST be handled in the ViewModel before compilation.
The Kotlin compiler enforces this for sealed interfaces; never use `else ->` catch-all.

## Rule 5: State Consistency

Every dialog/bottom sheet in the UI MUST have a corresponding Boolean flag in the State data class.
`OnDismissDialogs` intent MUST reset ALL dialog flags to false AND set `selectedFileForAction = null`.

---

# Final Rule

A ViewModel should coordinate UI behavior, not implement business rules.

If a ViewModel grows beyond coordinating state, events, and UseCases, responsibilities should be moved into the appropriate layer.