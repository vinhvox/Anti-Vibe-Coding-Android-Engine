# 01-project-memory.md (Project Profile Template)

# Project Memory: [Your Project Name]

## 1. Project Overview
- **Application Name:** [e.g. AcmePay]
- **Target Platform:** Modern Android (API 26+) / KMP
- **Package Name:** [e.g. com.acme.app]
- **Repository Structure:** Single Module / Multi-Module (`:app`, `:core`, `:feature:...`)

---

## 2. Technology Stack & Dependencies
- **UI Toolkit:** Jetpack Compose (Material 3 BOM [e.g. 2026.03.01])
- **Navigation:** Navigation 3 (State-driven, `@Serializable` routes)
- **State & Architecture:** MVI / Uni-Directional Data Flow (`BaseViewModel<State, Intent, Effect>`)
- **Dependency Injection:** Koin [e.g. 4.2.1]
- **Networking:** Ktor Client [e.g. 3.x] / Retrofit
- **Database:** Room [e.g. 2.8.x] / SQLDelight
- **Key-Value Storage:** Jetpack DataStore Preferences
- **Asynchronous:** Kotlin Coroutines & Flow (StateFlow, SharedFlow)
- **Image Loading:** Coil 3.x
- **Testing:** JUnit 5, MockK, Turbine, Compose Test Rule

---

## 3. Architecture Layer Conventions
- **Clean Architecture Boundaries:**
  - `presentation/`: Compose screens, ViewModels, UI State models.
  - `domain/`: Use cases, Domain models, Repository interfaces.
  - `data/`: Repository implementations, Remote DataSource (Ktor), Local DataSource (Room/DataStore), DTO mappers.
  - `di/`: Koin modules definitions.

---

## 4. Key Architectural Decisions (ADR Summary)
- *Decision 1:* [e.g. Navigation 3 chosen over Jetpack Navigation for compile-time type safety and reactive state-driven backstack]
- *Decision 2:* [e.g. Single Source of Truth (SSOT) pattern: Room database acts as truth, Ktor syncs in background]
