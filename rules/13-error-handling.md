# 13-error-handling.md

# Purpose

This document defines the project's error handling architecture.

Errors should be:

- Predictable
- Recoverable
- Observable
- User-friendly
- Consistent
- Testable

Errors are part of the application's normal behavior and must be handled explicitly.

---

# Core Principles

Errors should never cross architectural boundaries unchanged.

Preferred flow:

```text
Throwable
      ↓
Infrastructure Error
      ↓
Domain Error
      ↓
Ui Error
      ↓
UI
```

Never expose raw exceptions to Presentation.

---

# Error Ownership

Each layer owns its own error representation.

Presentation

- UiError

Domain

- DomainError

Data

- NetworkError
- DatabaseError
- StorageError

Never mix error types across layers.

---

# Error Categories

All errors should belong to a known category.

Examples:

- Network
- Authentication
- Authorization
- Validation
- Database
- Storage
- Parsing
- Timeout
- Cancellation
- Unknown

Avoid generic Exception handling.

---

# Data Layer

Data layer catches:

- IOException
- SerializationException
- SQLiteException
- SecurityException

Convert them into Data Errors.

Never throw infrastructure exceptions upward.

---

# Repository Rules

Repository converts Data Errors into Domain Errors.

Example:

```text
IOException

↓

NetworkUnavailable
```

```text
404

↓

ResourceNotFound
```

Repository never exposes:

- HttpException
- SQLException
- JsonDecodingException

---

# Domain Rules

Domain should understand business failures.

Examples:

```text
FileNotFound

PermissionDenied

StorageFull

InvalidInput

QuotaExceeded
```

Avoid HTTP terminology inside Domain.

---

# Presentation Rules

Presentation receives only UiError.

Examples:

```text
NoInternet

PermissionRequired

SomethingWentWrong

EmptyResult
```

UI should never display technical details.

---

# Result Wrapper

Business operations should return:

```text
Result<T>

or

Either<L, R>

or

AppResult<T>
```

Avoid throwing exceptions for expected failures.

---

# Exception Usage

Throw exceptions only for:

- Programmer errors
- Illegal state
- Contract violations

Do not throw exceptions for expected business outcomes.

---

# Retry Strategy

Retry only recoverable failures.

Retry examples:

- Timeout
- Temporary network failure
- HTTP 503

Do not retry:

- Invalid credentials
- Validation errors
- Permission denied
- Resource not found

---

# User Messages

Always map technical errors to user-friendly messages.

Bad:

```text
java.net.SocketTimeoutException
```

Good:

```text
Connection timed out.
Please try again.
```

---

# Logging

Log technical information.

Display friendly information.

Never show stack traces to users.

---

# Cancellation

Cancellation is not an error.

Never convert:

```kotlin
CancellationException
```

into UiError.

Always rethrow it.

---

# Validation

Input validation should happen before calling repositories.

Avoid making unnecessary requests that are guaranteed to fail.

---

# Empty State

Empty data is not an error.

Preferred flow:

```text
Request

↓

Success

↓

Empty List

↓

Empty UI
```

Avoid showing error screens for valid empty results.

---

# Loading State

Loading should be represented explicitly.

Flow:

```text
Idle

↓

Loading

↓

Success

↓

Idle
```

or

```text
Loading

↓

Error
```

Avoid hidden loading states.

---

# Error Recovery

Whenever possible provide recovery.

Examples:

- Retry
- Refresh
- Login Again
- Open Settings
- Request Permission

Do not leave users at dead ends.

---

# Permission Errors

Permission failures should suggest recovery.

Example:

```text
Permission Denied

↓

Open App Settings
```

---

# Network Errors

Differentiate:

- Offline
- Timeout
- Server Error
- Unauthorized
- Rate Limited

Do not group all as "Network Error".

---

# Storage Errors

Differentiate:

- Storage Full
- File Missing
- Read Failed
- Write Failed

Each may require different recovery.

---

# Error Analytics

Track:

- Error type
- Frequency
- Recovery success
- Screen
- App version

Do not collect sensitive user data.

---

# Crash Handling

Crash only for unrecoverable programmer errors.

Business failures must not crash the application.

---

# Testing

Test:

- Error mapping
- Retry
- Recovery
- User messages
- Empty state

Avoid testing only success paths.

---

# Review Checklist

Before completing a feature:

□ Exceptions mapped

□ Repository returns Result

□ Domain errors defined

□ UiError used

□ Retry supported

□ Cancellation respected

□ User-friendly messages

□ Logging implemented

□ Recovery available

□ Empty state handled

---

# Rule 13.5: Anti-Paranoic Try-Catch & Boundary-Only Error Isolation

### Mandatory Constraints
1. **Ban on Paranoic Try-Catch in Presentation & Domain**:
   - Strictly forbid wrapping Composable functions, UI events, or pure business logic in generic `try-catch` blocks as a crude crash-suppression tactic.
   - UI and Domain safety must be achieved through **Kotlin Null-Safety (`val`, `T?`, smart casts)**, exhaustive `when`, and immutable StateFlow updates.
2. **I/O Boundary Error Isolation**:
   - Error handling and `try-catch` / `runCatching` are strictly isolated to **I/O boundaries only**:
     - Remote Network API calls (`Ktor` / `OkHttp`)
     - Local Database transactions (`Room` / `SQLite`)
     - File I/O & JSON deserialization
   - Convert all boundary exceptions into structured `AppResult<T>` or typed `DomainError` before emitting to higher layers.
3. **Coroutines Cancellation Preservation**:
   - Never catch or swallow `CancellationException`. Always allow cancellation to propagate freely to preserve structured concurrency.

---

# Anti-patterns

Do not:

catch(Exception)

↓

Ignore

Do not:

UI

↓

exception.message

Do not:

Repository

↓

throw IOException

Do not:

ViewModel

↓

StackTrace

Do not:

Crash for business failures

---

# Decision Priority

When handling failures:

1. Can the error be prevented?

2. Can it be recovered?

3. Can it be mapped?

4. Can the user understand it?

5. Should it be logged?

6. Should analytics record it?

---

# Final Rule

Errors are expected outcomes, not exceptional events.

Handle failures deliberately, translate them across architectural boundaries, and always provide the user with the clearest possible recovery path.