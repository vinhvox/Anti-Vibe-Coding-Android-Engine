# 08-coroutines.md

# Purpose

This document defines the rules for using Kotlin Coroutines and Flow.

The goal is to ensure asynchronous code is:

- Safe
- Predictable
- Structured
- Lifecycle-aware
- Easy to maintain

The agent MUST follow these rules whenever implementing asynchronous logic.

---

# Core Principles

Coroutines must follow Structured Concurrency.

Never create coroutines without a clear lifecycle owner.

Prefer simplicity over concurrency.

---

# Coroutine Ownership

Every coroutine must have an owner.

Preferred owners:

- viewModelScope
- lifecycleScope
- coroutineScope

Avoid:

```kotlin
GlobalScope.launch { }
```

Never use GlobalScope.

---

# Structured Concurrency

Coroutines should always belong to a parent.

Preferred:

```text
ViewModel
      │
viewModelScope
      │
 launch
```

Avoid orphan coroutines.

---

# Dispatcher Rules

Use the appropriate dispatcher.

| Dispatcher | Purpose |
|------------|---------|
| Main | UI |
| IO | File, Network, Database |
| Default | CPU-intensive work |
| Unconfined | Never in production |

---

# Dispatcher Responsibility

Dispatchers should be selected by the Data layer whenever possible.

Preferred flow:

```text
ViewModel

↓

UseCase

↓

Repository

↓

withContext(IO)
```

Avoid switching dispatchers repeatedly.

---

# Main Thread Rules

Never perform:

- Network
- Database
- File I/O
- Bitmap decoding
- Compression

on Main.

Main is only for UI coordination.

---

# Flow Selection

Choose the correct Flow type.

| Type | Purpose |
|------|----------|
| StateFlow | UI State |
| SharedFlow | Events |
| Flow | Data Stream |
| Channel | One-to-one communication |

Never use StateFlow for one-time events.

---

# StateFlow Rules

Use StateFlow for:

- Screen State
- Form State
- Loading State

Always expose immutable StateFlow.

Good:

```kotlin
private val _uiState = MutableStateFlow(HomeUiState())

val uiState = _uiState.asStateFlow()
```

---

# SharedFlow Rules

Use SharedFlow for:

- Snackbar
- Navigation
- Dialog
- Toast

Avoid replay unless required.

---

# Flow Creation

Prefer:

```kotlin
flow {

}
```

Avoid creating unnecessary custom Flow builders.

---

# Cold vs Hot Flow

Remember:

Flow

↓

Cold

StateFlow

↓

Hot

SharedFlow

↓

Hot

Choose appropriately.

---

# Flow Operators

Preferred operators:

- map
- filter
- combine
- debounce
- distinctUntilChanged
- flatMapLatest
- catch
- onEach

Avoid long operator chains when readability suffers.

---

# combine

Use combine when multiple sources affect UI.

Example:

```text
Search Query

+

Sort Type

↓

Filtered Result
```

---

# zip

Use zip when values should pair one-to-one.

Avoid using zip for UI state merging.

---

# merge

Use merge for independent streams.

Do not replace combine with merge.

---

# flatMapLatest

Preferred for:

- Search
- Filtering
- Auto-complete

Cancels previous requests automatically.

---

# debounce

Use for:

- Search
- Typing
- Live filtering

Avoid arbitrary debounce values.

---

# distinctUntilChanged

Prevent unnecessary updates.

Good:

```kotlin
query
    .distinctUntilChanged()
```

---

# Exception Handling

Catch exceptions at the appropriate layer.

Preferred:

```text
Repository

↓

Result

↓

ViewModel

↓

UiState
```

Avoid swallowing exceptions.

---

# Cancellation

Always support cancellation.

Never catch:

```kotlin
CancellationException
```

unless rethrowing.

---

# Timeout

Use timeout only when business requirements demand it.

Preferred:

```kotlin
withTimeout(...)
```

Avoid arbitrary timeout values.

---

# Parallel Work

Use:

```kotlin
coroutineScope {

    val a = async { }

    val b = async { }

}
```

Only parallelize truly independent work.

---

# SupervisorScope

Use supervisorScope when child failures should not cancel siblings.

Example:

```text
Load Banner

Load User

Load Notification
```

One failure should not stop the others.

---

# Mutex

Use Mutex when protecting shared mutable state.

Avoid synchronized.

---

# Semaphore

Use Semaphore only when limiting concurrent operations.

Example:

- Multiple downloads
- File scanning

Avoid unnecessary complexity.

---

# Retry

Retry only recoverable failures.

Never retry:

- Authentication errors
- Validation errors
- Parsing bugs

Use exponential backoff when appropriate.

---

# Resource Cleanup

Always release:

- File handles
- Streams
- Database cursors

Use:

```kotlin
use { }
```

or

try/finally

---

# Lifecycle Awareness

UI should collect Flow using:

```kotlin
collectAsStateWithLifecycle()
```

Avoid collecting Flow manually inside Composable.

---

# Performance Rules

Avoid:

- Blocking calls
- Nested launch
- Deep Flow chains
- Excessive context switching

Prefer readable asynchronous code.

---

# Logging

Log:

- Coroutine failures
- Retry attempts
- Timeout events

Never log:

- Passwords
- Tokens
- Sensitive user data

---

# Testing Rules

Coroutine tests should use:

- runTest
- TestDispatcher
- TestScope

Avoid Thread.sleep().

---

# Review Checklist

Before completing asynchronous code:

□ No GlobalScope

□ Correct Dispatcher

□ Structured Concurrency

□ Immutable StateFlow

□ SharedFlow for Events

□ Cancellation supported

□ Timeout justified

□ No blocking Main Thread

□ Exceptions handled

□ Resources released

□ Testable

---

# Anti-patterns

Do not:

GlobalScope.launch

Do not:

launch {

launch {

launch {

}
}
}

Do not:

StateFlow

↓

Navigation Event

Do not:

Thread.sleep()

Do not:

withContext(Main) {

Database.query()

}

---

# Decision Priority

When implementing asynchronous logic:

1. Structured Concurrency

2. Correct lifecycle owner

3. Correct Flow type

4. Correct Dispatcher

5. Readability

6. Performance

7. Testability

---

# Final Rule

Coroutines exist to simplify asynchronous programming.

Do not introduce concurrency unless it improves responsiveness or user experience.

Prefer predictable, structured, and lifecycle-aware coroutine code over clever asynchronous implementations.