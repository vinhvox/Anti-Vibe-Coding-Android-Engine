# 09-networking.md

# Purpose

This document defines the networking architecture and implementation rules.

Networking should be:

- Reliable
- Testable
- Secure
- Observable
- Offline-friendly
- Maintainable

The agent MUST follow these rules whenever implementing remote communication.

---

# Core Principles

Networking belongs exclusively to the Data Layer.

Presentation and Domain must never know networking implementation details.

Preferred flow:

```text
UI
    ↓
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

Never bypass this flow.

---

# Networking Stack

Approved stack:

- Ktor Client
- Kotlin Serialization
- Coroutines
- Flow
- Koin
- Result Wrapper

Do not introduce:

- Retrofit
- Volley
- Fuel
- OkHttp directly in Presentation

---

# HttpClient Ownership

Create exactly ONE HttpClient.

Register it in Dependency Injection.

Bad:

```kotlin
class UserRepository {

    private val client = HttpClient()

}
```

Good:

```text
Koin

↓

Singleton HttpClient

↓

Inject
```

Never instantiate HttpClient manually.

---

# Layer Responsibilities

Presentation

Responsible for:

- Triggering actions

Never:

- Build request
- Parse response
- Handle HTTP

---

Domain

Responsible for:

- Business rules

Never know:

- HttpClient
- Status Code
- DTO

---

Data

Responsible for:

- API
- Serialization
- Mapping
- Retry
- Cache

---

# API Interface

Create one interface per API group.

Example:

```text
UserApi

AuthApi

FileApi

MediaApi

ConfigApi
```

Avoid:

```text
ApiService
```

containing everything.

---

# Remote Data Source

Every API group should have:

```text
UserRemoteDataSource

↓

UserRemoteDataSourceImpl
```

Repository depends on RemoteDataSource.

Never call HttpClient directly from Repository unless the project explicitly chooses that architecture.

---

# Repository Rules

Repository returns:

Domain Models

Never:

DTO

Never:

HttpResponse

Never:

JsonObject

---

# DTO Rules

DTO exists only for serialization.

Flow:

```text
JSON

↓

DTO

↓

Mapper

↓

Domain
```

Never expose DTO outside Data.

---

# Mapping Rules

Every DTO should have an explicit mapper.

Good:

```kotlin
fun UserDto.toDomain(): User
```

Avoid implicit conversions.

---

# URL Rules

Never hardcode URLs.

Preferred:

```text
BuildConfig

Environment

ConfigProvider
```

Support:

- Development
- Staging
- Production

---

# Endpoint Rules

Keep endpoints centralized.

Example:

```text
Endpoints

↓

LOGIN

↓

PROFILE

↓

UPLOAD

↓

SEARCH
```

Avoid scattered endpoint strings.

---

# Request Rules

Each request should:

- Specify timeout
- Handle cancellation
- Support retry when appropriate

Avoid fire-and-forget requests.

---

# Response Rules

Never expose raw responses.

Preferred:

```text
Response

↓

DTO

↓

Domain

↓

Result
```

---

# Result Wrapper

Repositories should return:

```text
Result<T>

or

Either

or

AppResult
```

Never throw networking exceptions into Presentation.

---

# Error Mapping

Convert:

```text
IOException

↓

NetworkError
```

```text
SerializationException

↓

ParseError
```

```text
HttpStatusCode

↓

ApiError
```

Never expose raw exceptions.

---

# HTTP Status Handling

Handle explicitly:

200

201

204

400

401

403

404

409

422

429

500

503

Avoid:

```kotlin
catch(Exception)
```

without understanding the cause.

---

# Authentication

Authentication should be handled centrally.

Preferred:

```text
HttpClient

↓

Plugin

↓

Authorization Header
```

Avoid adding tokens manually to every request.

---

# Token Refresh

Refresh tokens automatically.

Flow:

```text
401

↓

Refresh Token

↓

Retry Request

↓

Return Result
```

Avoid duplicating refresh logic.

---

# Timeout

Configure globally.

Preferred:

```text
Connect Timeout

Read Timeout

Request Timeout
```

Avoid setting timeout per request unless required.

---

# Retry Strategy

Retry only recoverable failures.

Good:

- Network timeout
- Temporary server unavailable

Avoid retrying:

- 400
- 401
- Validation failure

Use exponential backoff when applicable.

---

# Pagination

Support pagination through dedicated models.

Example:

```kotlin
Page<T>
```

Avoid returning raw lists for paginated APIs.

---

# Upload Rules

Uploads should support:

- Progress
- Cancellation
- Retry

Expose progress through Flow.

---

# Download Rules

Downloads should support:

- Resume (when supported)
- Progress
- Integrity verification
- Cancellation

Never block Main Thread.

---

# Offline First

Repositories should decide:

```text
Cache Available?

      │

      ├── Yes

      │      ↓

      │   Return Cache

      │

      └── No

             ↓

        Fetch Remote

             ↓

        Save Cache

             ↓

        Return Data
```

Presentation should not decide cache strategy.

---

# Caching Rules

Possible cache sources:

- Room
- Memory
- Disk

Repository coordinates cache.

---

# Logging

Log:

- URL
- Method
- Duration
- Status Code

Never log:

- Token
- Password
- Cookies
- Personal Data

Disable verbose logs in Release builds.

---

# Serialization

Use:

Kotlin Serialization

Every DTO should define:

```kotlin
@Serializable
```

Avoid reflection-based serialization.

---

# Network Monitoring

Observe:

- Connectivity
- Slow requests
- Failure rate
- Retry count

Expose metrics for debugging.

---

# Dependency Injection

Networking dependencies should be:

Singleton.

Example:

```text
HttpClient

Json

Api

RemoteDataSource
```

Never recreate them.

---

# Testing

Mock:

- API
- RemoteDataSource
- Repository

Avoid testing real servers in unit tests.

---

# Review Checklist

Before completing networking code:

□ Single HttpClient

□ Repository returns Domain

□ DTO mapped

□ Errors mapped

□ Retry configured

□ Timeout configured

□ Logging safe

□ Authentication centralized

□ No hardcoded URLs

□ Offline strategy defined

□ Testable

---

# Anti-patterns

Do not:

ViewModel

↓

HttpClient

Do not:

Composable

↓

API

Do not:

Repository

↓

JsonObject

Do not:

Presentation

↓

DTO

Do not:

Hardcoded URL

Do not:

Duplicate authentication logic

---

# Decision Priority

When implementing networking:

1. Existing architecture

2. Single HttpClient

3. Explicit mapping

4. Error handling

5. Offline support

6. Performance

7. Testability

---

# Final Rule

Networking should be invisible to the Presentation layer.

Presentation requests business data.

The Data layer decides how that data is retrieved, cached, refreshed, and validated.

Keep networking centralized, secure, observable, and easy to evolve.