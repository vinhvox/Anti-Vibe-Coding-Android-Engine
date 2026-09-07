# 25-solid-principles.md

# S.O.L.I.D Principles in Modern Android & Jetpack Compose

## Purpose

This document defines the mandatory rules and architectural guidelines for enforcing **S.O.L.I.D Principles** across the Android codebase.

Modern Android development (Jetpack Compose, Clean Architecture, MVI/UDF Antigravity, Navigation 3, and Koin DI) requires mapping classical Object-Oriented SOLID principles into declarative, reactive, and unidirectional patterns.

---

# Related Files

- Rules: `00-system-mandate.md`, `02-architecture.md`, `03-base-layer.md`, `06-compose.md`, `07-viewmodel.md`, `12-dependency-injection.md`, `21-enforcement-engine.md`
- Skills: `clean-code.md`, `architecture.md`, `design-patterns.md`, `mvi.md`

---

# S — Single Responsibility Principle (SRP)

> **"A class, Composable, or module should have one, and only one, reason to change."**

### 1. Presentation Layer (Jetpack Compose & MVI)
- **Stateless Composable (`*Content`):** Strictly responsible for UI rendering given a `UiState` and emitting events via callback lambdas. MUST NOT hold ViewModel references, CoroutineScopes, or trigger side effects.
- **Stateful Composable (`*Screen`):** Strictly acts as the glue layer between ViewModel and Stateless Content. Observes State and dispatches Intents/Navigation.
- **ViewModel (`BaseViewModel`):** Strictly manages UI State, receives user Intents, coordinates UseCases, and emits one-off UI Effects.
  - ❌ **FORBIDDEN:** Direct File I/O (`java.io.File`), Database queries (`Dao`), Network calls (`HttpClient`), or holding Android `Context`/`View` in ViewModel.

### 2. Domain & Data Layers (Clean Architecture)
- **UseCase:** Encapsulates exactly **ONE** business policy via `operator fun invoke()`.
  - ❌ **FORBIDDEN:** Creating "God UseCases" with multiple unrelated business actions.
- **Repository:** Strictly acts as the Single Source of Truth (SSOT), orchestrating between Local Persistence (Room DB) and Remote API (Ktor).
- **Mapper:** Strictly converts data models across boundaries (`Dto` ↔ `Entity` ↔ `DomainModel` ↔ `UiModel`).

---

# O — Open/Closed Principle (OCP)

> **"Software entities should be open for extension, but closed for modification."**

### 1. Jetpack Compose Slot API Pattern
- Open components for layout and content extension using **Slot lambdas** (`@Composable () -> Unit`) and `Modifier` rather than adding dozens of boolean flags (`hasIcon`, `hasBadge`, `isSpecialLayout`).

### 2. Sealed Interfaces & Polymorphic MVI State/Event
- Model UI States and UI Intents as `sealed interface` or `sealed class`.
- Adding a new user action (e.g. `VpnIntent.ToggleKillSwitch`) extends functionality by adding a new `data class` to the sealed hierarchy, requiring no modification to existing Intent classes.
- Exhaustive `when` expressions guarantee complete handling across the system.

---

# L — Liskov Substitution Principle (LSP)

> **"Objects of a superclass should be replaceable with objects of its subclasses without breaking application correctness."**

### 1. Repository & Data Source Contracts
- Implementations (e.g. `SeverRepositoryImpl`, `FakeSeverRepository`, `InMemoryVpnRepository`) MUST strictly fulfill the behavioral invariants defined by the domain interface.
- ❌ **FORBIDDEN:** Subclasses/Implementations throwing unexpected runtime exceptions (e.g., `throw UnsupportedOperationException()`) or altering return value assumptions (e.g. emitting non-terminating flows when a single emission was contracted).

### 2. Immutability in Compose State
- All UI State implementations MUST be immutable (`val` fields only, `data class` with `.copy()`, annotated with `@Immutable` or `@Stable`).
- If an implementation mutates properties in-place, Compose runtime cannot detect state diffs, breaking Recomposition contracts and causing subtle UI bugs.

---

# I — Interface Segregation Principle (ISP)

> **"Clients should not be forced to depend upon interfaces or methods that they do not use."**

### 1. Fine-Grained Callbacks in Compose
- NEVER pass an entire `ViewModel` or a monolithic 10-method listener interface to leaf/child Composables (e.g. `ServerCityRow`, `ConnectButton`).
- Pass only the specific, granular lambdas the child actually needs:
  ```kotlin
  // ✅ CORRECT (ISP compliant)
  @Composable
  fun ServerCityRow(
      server: VpnServer,
      onSelect: (VpnServer) -> Unit,
      onToggleFavorite: (String) -> Unit
  )
  ```

### 2. Segregated Domain & System Contracts
- Split broad interfaces into focused, single-purpose contracts:
  - `NetworkMonitor` (observes `isOnline: Flow<Boolean>`) vs `NetworkController` (modifies routing).
  - `VpnStateReader` (reads connection state) vs `VpnConnectionController` (connects/disconnects).

---

# D — Dependency Inversion Principle (DIP)

> **"High-level modules should not depend on low-level modules. Both should depend on abstractions."**

### 1. Clean Architecture Boundaries
- **High-Level Modules (Presentation & Domain):** MUST depend only on abstractions (Domain Repository Interfaces / UseCases).
- **Low-Level Modules (Data & Frameworks):** Implement abstractions defined by the Domain layer (`SeverRepositoryImpl` implements `SeverRepository`).
- Domain and Presentation layers MUST NOT import Room Database, DAOs, Ktor HttpClient, or low-level Android hardware services directly.

### 2. Constructor Dependency Injection via Koin
- All dependencies must be injected through constructors:
  ```kotlin
  // Domain interface defined in domain/repository/
  interface SeverRepository {
      fun getServers(): Flow<DataState<List<VpnServer>>>
  }

  // Implementation in data/repository/
  class SeverRepositoryImpl(
      private val remoteDataSource: VpnRemoteDataSource,
      private val serverDao: VpnServerDao
  ) : SeverRepository { ... }

  // High-level ViewModel depends on abstraction
  class ServerViewModel(
      private val severRepository: SeverRepository
  ) : BaseViewModel<ServerState, ServerIntent, ServerEffect>(ServerState()) { ... }
  ```
- Koin modules bind the interface to the implementation:
  ```kotlin
  val repositoryModule = module {
      single<SeverRepository> { SeverRepositoryImpl(get(), get()) }
  }
  ```

---

# REVIEW & ENFORCEMENT CHECKLIST

Before completing ANY code change, verify compliance against the following 5 SOLID gates:

- [ ] **SRP:** Does each class/composable/file have only 1 responsibility? (No direct I/O in ViewModel; no ViewModel in leaf composables).
- [ ] **OCP:** Are UI components extensible via Slot API and Modifier rather than excessive boolean props?
- [ ] **LSP:** Are all State models immutable? Can Repository test fakes substitute for implementations with 100% contract adherence?
- [ ] **ISP:** Are Composable callbacks granular lambdas rather than bloated listener objects or full ViewModels?
- [ ] **DIP:** Are high-level Presentation/Domain layers decoupled from low-level Room/Ktor/File implementations via Domain interfaces and Koin DI?
