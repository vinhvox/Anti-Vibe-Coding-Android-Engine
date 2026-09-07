---
name: design-patterns
description: Use when choosing, applying, or reviewing software design patterns in Modern Android, Kotlin, and Jetpack Compose (Creational, Structural, Behavioral, Compose Slot API, State Hoisting, MVI Intent, SSOT).
---

# Modern Android & Jetpack Compose Design Patterns

This skill serves as the primary technical guide for applying **Software Design Patterns** within **Modern Kotlin, Jetpack Compose, MVI, and Clean Architecture**.

For the complete standalone reference guide, see [design-patterns.md](../design-patterns.md).

---

## 1. Core Philosophy: Kotlin & Compose vs Java OOP

In modern Android development, classical Gang of Four (GoF) patterns are streamlined by Kotlin idioms and Compose declarative semantics:
1. **Language First-Class:** Replaced or enhanced by native Kotlin constructs (first-class functions, default parameters, `data class` `.copy()`, class delegation `by`, Coroutines `Flow`, Snapshot State).
2. **Declarative-First:** UI is a pure function of State (`UI = f(State)`). Unidirectional Data Flow (UDF) replaces stateful UI hierarchies.
3. **Pragmatic & Lean:** Avoid over-engineering. Design patterns exist to solve concrete architectural problems, not to add ceremonial layers.

---

## 2. Quick Pattern Taxonomy & Code Examples

### A. Creational Patterns
* **Factory / Abstract Factory:** Companion object factory methods (`VpnConnectionProfile.createOpenVpn(...)`) and sealed interfaces (`EncryptedVaultFactory`).
* **Builder:** Replaced by **Kotlin Named Arguments + Defaults** for standard models, or **Type-Safe DSL Builders** (`@DslMarker`) for complex nested configurations.
* **Singleton:** Dependency-injected singletons via **Koin `single {}`**. Never use global mutable `object` with Android `Context`.
* **Prototype:** `data class.copy()` for pure, immutable state transitions in MVI.

```kotlin
// DSL Builder with @DslMarker
@DslMarker annotation class VpnDsl

@VpnDsl
class VpnRouteBuilder {
    private val allowedApps = mutableListOf<String>()
    fun allowApp(packageName: String) { allowedApps.add(packageName) }
    fun build(): VpnRouteConfig = VpnRouteConfig(allowedApps)
}

fun vpnRoute(block: VpnRouteBuilder.() -> Unit): VpnRouteConfig =
    VpnRouteBuilder().apply(block).build()
```

---

### B. Structural Patterns
* **Adapter:** Converting Android legacy callback listeners into `callbackFlow` or `suspendCancellableCoroutine`.
* **Decorator:** Compose `Modifier` extension functions and Kotlin class delegation (`class LoggingRepo(val delegate: Repo) : Repo by delegate`).
* **Facade:** Encapsulating complex Android Native subsystems (VPN AIDL, ExoPlayer, Biometrics) behind clean domain facades.
* **Composite:** Compose UI layout node hierarchy and composite domain use cases.

```kotlin
// Adapter: Android Callback -> Flow
fun ConnectivityManager.observeNetwork(): Flow<NetworkStatus> = callbackFlow {
    val callback = object : ConnectivityManager.NetworkCallback() {
        override fun onAvailable(network: Network) { trySend(NetworkStatus.Available) }
        override fun onLost(network: Network) { trySend(NetworkStatus.Lost) }
    }
    registerDefaultNetworkCallback(callback)
    awaitClose { unregisterNetworkCallback(callback) }
}.distinctUntilChanged()
```

---

### C. Behavioral Patterns
* **Strategy:** First-class functions (lambdas `(VpnServer) -> Boolean`) and sealed interface strategies (`ServerSortingStrategy`).
* **Observer:** Coroutines `Flow`, `StateFlow`, `SharedFlow`, and Compose `SnapshotState`.
* **Command:** MVI `Intent` / UI Events encapsulating user actions as discrete commands.
* **State Pattern:** Finite State Machines (FSM) via exhaustive `sealed interface UiState`.
* **Chain of Responsibility:** Ktor/OkHttp Interceptors and Navigation Guards.

```kotlin
// State Pattern via Sealed Interface in Compose MVI
sealed interface VpnConnectionUiState : UiState {
    data object Disconnected : VpnConnectionUiState
    data class Connecting(val progress: Float) : VpnConnectionUiState
    data class Connected(val sessionDurationSeconds: Long) : VpnConnectionUiState
    data class Error(val errorReason: VpnErrorType) : VpnConnectionUiState
}
```

---

### D. Compose & Architectural Patterns
* **Slot API Pattern:** Accepting `@Composable () -> Unit` lambdas for flexible container customization.
* **State Hoisting:** Decoupling stateless presenters (`@Composable (State) -> Unit`) from stateful containers (`ViewModel` collectors).
* **Single Source of Truth (SSOT):** `networkBoundResource` coordinating Room DB cache with remote APIs.
* **Mapper Pattern:** Explicit boundary mappers separating DTO, Entity, Domain Model, and UiModel.

---

## 3. Decision Matrix: Pragmatic vs Over-Engineered

| Pattern | Recommended When | Avoid When (Anti-Pattern) |
|---|---|---|
| **Builder** | Nested, hierarchical DSL configurations (`@DslMarker`). | Simple classes with < 5 parameters (use Named Args + Defaults). |
| **Factory** | Dynamic polymorphism based on runtime config or platform type. | Trivial instantiation (`ItemFactory` calling `return Item(...)`). |
| **Singleton** | Registered via Koin `single {}` for stateless services. | Global `object` with mutable `var` state or holding Android `Context`. |
| **Strategy** | Algorithms changeable by user preferences (sorting/ciphers). | Interface hierarchies for simple 2-branch `if/else` logic. |
| **Command** | MVI `Intent` representing user actions queued in UDF. | Wrapping internal UI composable state setters into Command objects. |
| **Facade** | Encapsulating complex Android Native subsystems. | Wrapping a single repository method with zero added value. |
| **Slot API** | Design System components needing flexible child customization. | Rigid leaf components (static icon badges). |

---

## Related References
- [architecture.md](../architecture.md) — Screen architecture, state owners, and MVI vs MVVM.
- [clean-code.md](../clean-code.md) — Avoiding over-engineering and disciplined MVI.
- [anti-patterns.md](../anti-patterns.md) — Anti-patterns in Compose and Coroutines.
- [compose-essentials.md](../compose-essentials.md) — Compose stability, state hoisting, and side effects.
- [koin.md](../koin.md) — Dependency injection rules and scoping.
