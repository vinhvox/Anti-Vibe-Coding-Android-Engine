# 12-dependency-injection.md

# Purpose

This document defines the dependency injection (DI) architecture for the Antigravity Android Framework.

Dependency Injection exists to:
- Reduce coupling
- Improve testability
- Increase modularity
- Simplify object creation
- Enforce clean architectural boundaries

As a true **AI Cognitive Operating System**, the AI does not mandate a single DI framework. It enforces universal dependency inversion invariants while adapting to the project's chosen DI system (**Koin** or **Hilt/Dagger**).

---

# Core Principles (Universal Invariants)

Regardless of the DI framework used:

1. **Constructor Injection is Mandatory:**
   Every class must receive its dependencies through its primary constructor.
   ```kotlin
   // GOOD
   class GetUserUseCase(
       private val userRepository: UserRepository
   )
   
   // BAD — Self-instantiation violates DI
   class GetUserUseCase {
       private val userRepository = UserRepositoryImpl()
   }
   ```

2. **Zero Manual Instantiation in Presentation:**
   Never instantiate Repositories, UseCases, DataSources, or HTTP clients manually inside a Composable or ViewModel.

3. **Inversion of Control (IoC) at Layer Boundaries:**
   Presentation depends on Domain interfaces.  
   Data implements Domain interfaces.  
   DI wires the implementation to the interface.

4. **Avoid Service Locator Anti-Pattern:**
   Do not pass DI containers around or call global locator methods (`GlobalContext.get()`) deep inside business logic.

---

# Adaptive DI Drivers (Koin & Hilt)

The AI detects the DI framework during **Phase 0: Workspace & Stack Auto-Discovery**:

## Driver A: Koin (Lightweight & KMP Preferred)
- Use constructor DSL: `singleOf(::UserRepositoryImpl) bind UserRepository::class`, `viewModelOf(::HomeViewModel)`.
- Organize modules cleanly:
  - `coreModule`: Network client, Preferences, App dispatchers.
  - `databaseModule`: Room database, DAOs.
  - `networkModule`: API services, DTO serializers.
  - `featureModule`: UseCases, ViewModels for specific features.
- Zero reflection in production.
- Use `koinViewModel()` or `viewModel()` in Composables to retrieve ViewModels.

## Driver B: Hilt / Dagger (Industry Standard Enterprise Android)
- Annotate the Application class with `@HiltAndroidApp`.
- Annotate ViewModels with `@HiltViewModel` and `@Inject constructor(...)`.
- Use `@Module` with `@InstallIn(SingletonComponent::class)` for app-wide singletons (Database, Network Client, Repositories).
- Use `@Binds` inside abstract modules for binding implementations to interfaces (avoids boilerplate `@Provides`).
- Use `@ActivityRetainedScoped` for scoped feature state if needed.
- In Compose, obtain ViewModels via `hiltViewModel()`.
- **Strict Prohibition:** NEVER use `@Inject lateinit var` field injection in Domain UseCases or Repositories; field injection is only permissible in Android-framework entry points (Activities/Services/BroadcastReceivers).

---

# Forbidden Anti-Patterns

❌ NEVER instantiate dependencies directly inside Composable functions (`val repo = UserRepositoryImpl()`).  
❌ NEVER create circular dependencies between modules.  
❌ NEVER inject `Context` or `Activity` into Domain UseCases or Repositories.  
❌ NEVER use reflection-heavy DI patterns in performance-critical hot paths.