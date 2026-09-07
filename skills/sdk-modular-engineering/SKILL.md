---
name: sdk-modular-engineering
description: Comprehensive architectural standard and drop-in blueprints for designing, building, and optimizing high-performance Internal Modules, Core Libraries, and SDKs. Enforces minimal public surface (internal by default), built-in pluggable test fakes (:testing modules), zero startup overhead (no ContentProvider auto-init), host app crash isolation, Gradle convention plugins, and binary compatibility.
---

# SDK & Modular Engineering Skill

## Purpose
Provide actionable rules, drop-in blueprints, and quality checklists for developing robust, scalable, and high-performance internal modules and SDKs across Modern Android and Kotlin Multiplatform projects.

---

# The 6 SDK Architectural Pillars

```text
1. Minimal Public Surface (90% internal, clean interface exports)
2. Mandatory ':testing' Submodule (Drop-in in-memory fakes for consumers)
3. Zero Startup Overhead (Ban ContentProvider auto-init, lazy initialization)
4. Host App Error Isolation (SdkResult<T> with structured error codes)
5. Gradle Dependency Isolation ('implementation' > 'api', convention plugins)
6. Binary Compatibility & SemVer Deprecation Lifecycle
```

---

# Drop-in SDK Blueprints

### 1. 4-Tier Module Taxonomy
- `:core:auth:api` (Pure interfaces, models, public SdkResult)
- `:core:auth:impl` (Internal network calls, encryption, state)
- `:core:auth:testing` (FakeAuthSdk for feature teams)

### 2. Pluggable Test Fake Blueprint
```kotlin
public class FakeNetworkClient : NetworkClient {
    public var responseMap: MutableMap<String, Any> = mutableMapOf()
    public var shouldThrowNetworkError: Boolean = false

    override suspend fun <T : Any> get(url: String, clazz: KClass<T>): SdkResult<T> {
        if (shouldThrowNetworkError) {
            return SdkResult.Failure(SdkErrorCode.NETWORK_ERROR, "Simulated network failure")
        }
        @Suppress("UNCHECKED_CAST")
        val response = responseMap[url] as? T 
            ?: return SdkResult.Failure(SdkErrorCode.NOT_FOUND, "No mocked response for $url")
        return SdkResult.Success(response)
    }
}
```

---

# Quality Enforcement (Gate E25)

- `E25.1`: Public API Surface & Visibility Isolation Gate
- `E25.2`: Mandatory Test Double / Fake Artifact Gate
- `E25.3`: Zero Startup Penalty Gate
- `E25.4`: Gradle Dependency Isolation Gate
- `E25.5`: Host App Error Isolation Gate
- `E25.6`: SemVer & Deprecation Lifecycle Gate
