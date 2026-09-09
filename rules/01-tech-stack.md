# 01-tech-stack.md

# Purpose

This document defines the **Adaptive Technology Architecture (Hardware Abstraction Layer - HAL)** for the Antigravity Android Framework.

As a true **AI Cognitive Operating System**, the AI does NOT dictate or force a single dogmatic stack onto existing projects. Instead, it enforces universal engineering invariants while seamlessly adapting to the project's chosen libraries (detected automatically during **Phase 0: Workspace & Stack Auto-Discovery**).

---

# 1. Universal Engineering Invariants (All Projects)

Regardless of the libraries used, every implementation MUST satisfy:

| Invariant | Standard | Enforcement |
|---|---|---|
| **Language** | Kotlin (2.0+) | Strict null safety, immutable collections (`val`), sealed interfaces. |
| **UI System** | Jetpack Compose / Compose Multiplatform | Material 3 Design Tokens, 60/120 FPS recomposition stability, explicit `key` & `contentType` for Lazy Layouts. |
| **Aesthetic Standard** | [Rule 36 (World-Class UI/UX)](36-ui-ux-design-standard.md) | 0.5dp subtle borders, tonal surfaces, 8-pt grid, anti-AI design clichés. |
| **Architecture** | Clean Architecture (Domain ➔ Data ➔ UI) | Strict layer boundaries; Domain never depends on Data or Presentation. |
| **State Pattern** | MVI / Uni-Directional Data Flow (UDF) | Immutable `StateFlow<UIState>` exposed to UI; UI emits pure intents. |
| **Concurrency** | Kotlin Coroutines & Flow | Main-Thread purity (`Dispatchers.Main` for UI only, `Dispatchers.IO` for I/O). |
| **Memory Discipline** | [Rule 26 (Stack vs Heap)](26-stack-heap-memory.md) | Zero object allocation in Composable render loops; `@JvmInline value class` for IDs. |
| **Android Vitals** | [Rule 27 (App Quality Vitals)](27-app-quality-vitals.md) | Zero-Crash, Zero-ANR, Zero-Leak, Startup TTID < 500ms, 16KB page alignment. |

---

# 2. Adaptive Stack Drivers (Plug-and-Play)

During Phase 0, the AI inspects `libs.versions.toml` or `build.gradle.kts` and activates the corresponding driver:

## A. Dependency Injection Drivers
* **Driver 1: Koin (Lightweight / KMP Preferred)**
  - Use constructor injection (`viewModelOf`, `singleOf`, `factoryOf`).
  - Modularize DI: `coreModule`, `networkModule`, `databaseModule`, `featureModule`.
  - Zero reflection in production.
* **Driver 2: Hilt / Dagger (Enterprise Android Standard)**
  - Use `@HiltViewModel` for ViewModels, `@Inject constructor(...)` for classes.
  - Bind interfaces via `@Binds` in abstract `@Module` with `@InstallIn(SingletonComponent::class)`.
  - Strict scope isolation: `@Singleton` for Repositories/Clients, `@ActivityRetainedScoped` for feature-level caches.
  - Zero field injection (`@Inject lateinit var`) in Domain or Data classes.

## B. Networking Drivers
* **Driver 1: Ktor Client (Modern / KMP Preferred)**
  - ContentNegotiation with `kotlinx.serialization`.
  - Platform-appropriate engines (OkHttp for Android, Darwin for iOS, CIO for Server).
  - HttpTimeout configuration and unified exception mapping to `AppResult<T>`.
* **Driver 2: Retrofit + OkHttp (Industry Standard Android)**
  - Suspend functions for all API declarations.
  - `kotlinx.serialization` or `Moshi` converter (avoid legacy Gson).
  - Custom Interceptors for Auth, Logging, and Headers.
  - Dedicated DTO-to-Domain mappers; never leak Retrofit DTOs into Presentation.

## C. Navigation Drivers
* **Driver 1: Navigation 3 (Compose-first, State-driven)**
  - Strongly typed `@Serializable` destinations.
  - Centralized reactive router with `SnapshotStateList<Screen>`.
  - 400ms debounce on navigation transitions.
* **Driver 2: Jetpack Navigation Compose**
  - Type-safe routes via Kotlin `@Serializable` objects (Navigation 2.8+).
  - Scope ViewModels to navigation graph entries (`hiltViewModel()`).
* **Driver 3: Voyager / Decompose (KMP Navigation)**
  - Type-safe Screen models with screen lifecycle hooks.

## D. Local Storage Drivers
* **Driver 1: Room Database (Android / KMP)**
  - SQLiteDriver with WAL (Write-Ahead Logging) enabled.
  - Safe migrations with `MigrationTestHelper` and `exportSchema = true`.
  - Single Source of Truth (SSOT): Database as truth, Network as updater.
* **Driver 2: SQLDelight (KMP Standard)**
  - Type-safe SQL queries generated at compile time.
* **Driver 3: Jetpack DataStore (Preferences & Proto)**
  - Coroutine-based, non-blocking asynchronous key-value persistence.

---

# 3. Strictly Forbidden Anti-Patterns & Obsolete Technologies

Unless maintaining untouchable legacy modules, the AI MUST NEVER introduce:

- ❌ `AsyncTask`, raw `Thread()`, `java.util.Timer` (Violates structured concurrency).
- ❌ `ButterKnife`, synthetic view accessors (Obsolete, causes memory leaks).
- ❌ `Loaders`, `CursorAdapter`, legacy `ContentProvider` auto-init (Slows startup TTID).
- ❌ Raw string SQL queries without parameter binding (SQL injection hazard).
- ❌ Blocking operations on `Dispatchers.Main` (`Thread.sleep()`, synchronous file/network I/O).
- ❌ Lazy `try-catch` sprawl across UI or ViewModel to sweep errors under the rug.
- ❌ Purple-on-dark neon glows and cliché AI design patterns ([Rule 36](36-ui-ux-design-standard.md)).

---

# 4. Stack Decision Priority

When working on any codebase:
1. **Existing Codebase Stack:** Match what the project already uses (e.g. if Hilt is used, write Hilt; do not migrate to Koin unprompted).
2. **Official Android Modern Standards:** Compose, Coroutines, Flow, Version Catalog.
3. **Simplicity & Performance:** The simplest solution that satisfies all 29 Quality Gates (E1–E29).