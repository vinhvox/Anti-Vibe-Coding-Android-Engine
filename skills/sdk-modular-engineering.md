# Skill: SDK & Modular Engineering Playbook

## Purpose

Provide an end-to-end architectural guide, drop-in blueprints, and quality checklists for designing, building, and optimizing high-performance **Internal Modules, Core Libraries, and SDKs** across Modern Android and Kotlin Multiplatform projects.

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
```text
:core:auth
  ├── :core:auth:api        (Pure interfaces, models, public SdkResult)
  ├── :core:auth:impl       (Internal network calls, encryption, state)
  └── :core:auth:testing    (FakeAuthSdk for feature teams)
```

### 2. Gradle Build Logic Convention Plugin (`build-logic/convention`)
```kotlin
// AndroidLibraryConventionPlugin.kt
class AndroidLibraryConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) = with(target) {
        with(pluginManager) {
            apply("com.android.library")
            apply("org.jetbrains.kotlin.android")
        }
        extensions.configure<LibraryExtension> {
            compileSdk = 35
            defaultConfig {
                minSdk = 26
                testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
            }
            buildTypes {
                release {
                    isMinifyEnabled = false
                }
            }
        }
    }
}
```

### 3. Pluggable Test Fake Blueprint
```kotlin
// In :core:network:testing
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

# Verification Checklist (Gate E25 Audit)

Before publishing or completing an SDK / core module:
- [ ] **Visibility:** Are all internal classes and helpers explicitly marked `internal`?
- [ ] **Test Double:** Does the module export a companion `:testing` submodule with an in-memory Fake?
- [ ] **Zero Auto-Init:** Is the SDK free from `ContentProvider` auto-initializers?
- [ ] **Host Protection:** Are all public methods wrapped in `SdkResult<T>`?
- [ ] **Gradle Boundaries:** Is `implementation` used for internal dependencies to protect ABI?
