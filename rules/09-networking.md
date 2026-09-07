# 09-networking.md

# Purpose

This document defines the networking architecture and implementation rules for the Antigravity Android Framework.

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

Networking belongs exclusively to the **Data Layer**.

Presentation and Domain MUST NEVER know networking implementation details or library-specific classes (e.g. `HttpClient`, `Retrofit`, `Response<T>`, `HttpResponse`).

Preferred flow:

```text
UI (Presentation)
    ↓ (Emits Intent)
ViewModel
    ↓ (Executes UseCase)
UseCase (Domain)
    ↓ (Calls Repository Interface)
Repository (Data)
    ↓ (Uses RemoteDataSource)
RemoteDataSource
    ↓
HttpClient / Retrofit Service
```

Never bypass this flow.

---

# Adaptive Networking Architecture (Ktor & Retrofit Drivers)

The AI auto-detects the project's networking engine during **Phase 0** and enforces high-rigor standards on that engine:

## 1. Driver A: Ktor Client (Modern & KMP Preferred)
- Use `HttpClient` configured in Dependency Injection (exactly ONE singleton client).
- Use `ContentNegotiation` with `kotlinx.serialization`.
- Platform-appropriate engines: `OkHttp` for Android, `Darwin` for iOS, `CIO` for multiplatform/server.
- Configure `HttpTimeout` (connect, request, socket timeouts) explicitly.
- Centralize request pipeline with custom plugins or DefaultRequest.

## 2. Driver B: Retrofit + OkHttp (Industry Standard Android)
- Use standard Retrofit interfaces with `suspend` functions for all endpoints.
- Converters: `kotlinx.serialization.converter` or `MoshiConverterFactory` (avoid legacy Gson for new code).
- Configure single `OkHttpClient` with connection pooling, timeouts (15s connect/read), and logging interceptors (debug only).
- Enforce custom OkHttp Interceptors for Auth tokens (refresh token flow) and headers.

---

# Universal Networking Invariants (Mandatory for ALL Drivers)

Regardless of whether Ktor or Retrofit is used:

### 1. DTO Isolation & Boundary Mapping
- DTO (Data Transfer Object) models must live strictly in the Data layer.
- NEVER return DTOs from Repository to Domain or Presentation.
- Every DTO must have an explicit mapping function to a pure Domain model:
  ```kotlin
  fun UserDto.toDomain(): User = User(id = id, name = name)
  ```

### 2. Error Boundary & Result Wrapper
- Every network call MUST be wrapped at the RemoteDataSource or Repository boundary.
- Return `AppResult<T>` or Kotlin stdlib `Result<T>` with structured domain errors (`NetworkError.NoConnection`, `NetworkError.ServerError`, `NetworkError.Unauthorized`).
- NEVER let raw network exceptions (`IOException`, `SocketTimeoutException`, `UnresolvedAddressException`) escape unhandled into the UI.

### 3. Threading & Coroutines Safety
- All network operations must execute asynchronously.
- Explicitly ensure non-blocking I/O execution via `withContext(Dispatchers.IO)`.
- Never block the Main thread.

### 4. Single Source of Truth (SSOT)
- When building offline-capable features, Network NEVER feeds UI directly.
- Flow: `Network ➔ Save to Local Database (Room/SQLDelight) ➔ Flow from Database to UI`.

---

# Forbidden Anti-Patterns

❌ NEVER call `HttpClient` or `Retrofit` directly from Composable or ViewModel.  
❌ NEVER expose raw HTTP status codes or library-specific exceptions to the Presentation layer.  
❌ NEVER disable SSL certificate validation (`TrustAllCerts`) in production code.  
❌ NEVER log sensitive authentication tokens, passwords, or personal data in plaintext network logs.  
❌ NEVER perform synchronous/blocking network calls.