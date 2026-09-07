# 34 - Internal Module & SDK Architectural Standard (The Enterprise Modularity Mandate)

## Purpose

This document establishes the official **Internal Module & SDK Architectural Standard** across the entire Antigravity Engine.

Its mission is to maximize engineering velocity across multi-module codebases, eliminate leaky abstractions, enforce zero-startup-overhead SDKs, mandate pluggable test doubles (`:testing` fake modules), ensure host app crash isolation, and maintain strict binary compatibility.

---

# 1. THE 6 PILLARS OF ENTERPRISE SDK & MODULAR DESIGN

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. MINIMAL PUBLIC SURFACE      │ 90% code is 'internal'. Expose pure interfaces only.   │
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 2. MANDATORY ':testing' FAKES  │ Every SDK ships an in-memory Fake for feature teams.   │
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 3. ZERO STARTUP OVERHEAD       │ Ban ContentProvider auto-init. Lazy/On-Demand init.    │
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 4. HOST APP ERROR ISOLATION    │ Return structured SdkResult<T>. SDK never crashes host │
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 5. GRADLE BUILD ISOLATION      │ 'implementation' > 'api', Convention Plugins, no cycles│
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 6. SEMVER & ABI COMPATIBILITY  │ Strict Deprecation cycle before breaking API changes.  │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# 2. CORE ARCHITECTURAL MANDATES

## Rule 34.1: Public API Surface & Visibility Isolation
- **Rule:** Every class, interface, and top-level function in an SDK or internal module is `internal` by default.
- **Explicit Exposure:** Only public contract interfaces, builder/configuration classes, and DI entry-points are marked `public`.
- **Package Encapsulation:** Internal implementation details (`*Impl.kt`, network clients, database entities) must reside in internal packages and NEVER leak into host app autocompletion.

---

## Rule 34.2: Mandatory Pluggable Test Doubles (`:testing` Artifact)
- **Rule:** Every SDK module (e.g. `:core:auth`) MUST publish a corresponding test fixture submodule (e.g. `:core:auth-testing` or `projects.core.auth.testing`).
- **In-Memory Fake:** The `:testing` module must provide a thread-safe, high-performance in-memory Fake implementing the public SDK interface (`FakeAuthSdk`).
- **DevEx Velocity:** Feature teams can write unit tests in 50ms without mocking the SDK.

---

## Rule 34.3: Zero Startup Overhead & Lazy Initialization
- **Rule:** Strictly ban using Android `ContentProvider` or auto-startup initializers to initialize SDKs silently on app cold start.
- **Explicit Configuration:** Provide an explicit `SdkConfiguration` or lazy entry-point initialized on-demand or during background initialization phases.
- **Resource Reclaim:** Provide a lifecycle cleanup method (`sdk.shutdown()` / `sdk.clearUserSession()`) to release coroutine scopes, open sockets, and caches when the user logs out or the host app backgrounds.

---

## Rule 34.4: Host App Error Isolation & Crash Prevention
- **Rule:** An internal SDK or core module MUST NEVER crash the host application due to unhandled exceptions, backend serialization changes, or transient I/O failures.
- **Contract Boundary:** Wrap all public operations in `SdkResult<T>` with structured error codes (`SdkErrorCode.NETWORK_UNAVAILABLE`, `SdkErrorCode.AUTH_EXPIRED`, `SdkErrorCode.INVALID_PARAM`) and diagnostic trace IDs.

---

## Rule 34.5: Gradle Module Taxonomy & Dependency Scoping
- **Rule:** Enforce the 4-tier module taxonomy:
  1. `:core:model` (Pure Kotlin JVM, zero Android SDK dependencies, blazing fast tests).
  2. `:core:api` / `:core:contract` (Pure interfaces).
  3. `:core:impl` (Internal business logic and dependencies).
  4. `:core:testing` (In-memory fakes for consumers).
- **Dependency Inversion:** Use `implementation` for 95% of dependencies. Use `api` ONLY when a type is explicitly part of the public interface signature.
- **Convention Plugins:** Use Gradle `build-logic` composite builds to centralize Compose, Kotlin, Android, and KMP configurations.

---

## Rule 34.6: Binary Compatibility & Deprecation Lifecycle
- **Rule:** When refactoring an existing SDK API:
  1. **Phase 1 (Deprecate):** Mark old API with `@Deprecated(message = "...", replaceWith = ReplaceWith("newApi()"))`.
  2. **Phase 2 (Migrate):** Give feature teams at least 1 release cycle to migrate.
  3. **Phase 3 (Remove):** Remove only after all dependent modules have updated.
- **Experimental APIs:** Mark unstable or incubating APIs with `@RequiresOptIn` / `@ExperimentalSdkApi`.

---

# 3. DROP-IN SDK CODE BLUEPRINTS

### A. Public Contract & Internal Implementation Blueprint
```kotlin
// Public API Interface (:core:auth)
public interface AuthSdk {
    public val authState: StateFlow<AuthState>
    public suspend fun login(credentials: Credentials): SdkResult<UserSession>
    public suspend fun logout(): SdkResult<Unit>

    public companion object {
        public fun create(context: Context, config: AuthConfig): AuthSdk = AuthSdkImpl(context, config)
    }
}

// Internal Implementation (Not accessible outside module)
internal class AuthSdkImpl(
    private val context: Context,
    private val config: AuthConfig
) : AuthSdk {
    override val authState: MutableStateFlow<AuthState> = MutableStateFlow(AuthState.Unauthenticated)

    override suspend fun login(credentials: Credentials): SdkResult<UserSession> = withContext(Dispatchers.IO) {
        runCatching {
            // Internal network call
            UserSession(userId = "123", token = "jwt_token")
        }.fold(
            onSuccess = { session ->
                authState.value = AuthState.Authenticated(session)
                SdkResult.Success(session)
            },
            onFailure = { err ->
                SdkResult.Failure(SdkErrorCode.NETWORK_ERROR, err.message)
            }
        )
    }

    override suspend fun logout(): SdkResult<Unit> {
        authState.value = AuthState.Unauthenticated
        return SdkResult.Success(Unit)
    }
}
```

### B. Pluggable In-Memory Fake (:core:auth-testing)
```kotlin
public class FakeAuthSdk : AuthSdk {
    public override val authState: MutableStateFlow<AuthState> = MutableStateFlow(AuthState.Unauthenticated)
    public var shouldFailLogin: Boolean = false

    public override suspend fun login(credentials: Credentials): SdkResult<UserSession> {
        if (shouldFailLogin) {
            return SdkResult.Failure(SdkErrorCode.INVALID_CREDENTIALS, "Invalid credentials")
        }
        val session = UserSession(userId = "fake_user", token = "fake_token")
        authState.value = AuthState.Authenticated(session)
        return SdkResult.Success(session)
    }

    public override suspend fun logout(): SdkResult<Unit> {
        authState.value = AuthState.Unauthenticated
        return SdkResult.Success(Unit)
    }
}
```

---

# 4. REVIEW & ENFORCEMENT (GATE E25)

Every SDK and module implementation must pass **GATE E25** in `rules/21-enforcement-engine.md`:
- `E25.1`: Public API Surface & Visibility Isolation Gate
- `E25.2`: Mandatory Test Double / Fake Artifact Gate
- `E25.3`: Zero Startup Penalty Gate
- `E25.4`: Gradle Dependency Isolation Gate
- `E25.5`: Host App Error Isolation Gate
- `E25.6`: SemVer & Deprecation Lifecycle Gate
