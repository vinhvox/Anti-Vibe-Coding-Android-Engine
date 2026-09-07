# Spec-Driven Development (SDD) & GitHub Spec Kit Guide

## Overview

**Spec-Driven Development (SDD)** is an engineering paradigm that replaces spontaneous, unanchored prompt-coding ("vibe coding") with **executable, version-controlled specification contracts**. 

By establishing a strict **Specification $\rightarrow$ Plan $\rightarrow$ Tasks $\rightarrow$ Implementation $\rightarrow$ Verification** pipeline, AI agents and engineers collaborate with zero ambiguity, zero hallucinated architecture, and zero scope drift.

---

# 1. THE SDD CORE LIFECYCLE

```
┌─────────────────────────────────────────────────────────────┐
│ 1. SPECIFY (spec.md)                                        │
│ • Business Objectives & Use Cases                           │
│ • Domain Entities & Contracts                               │
│ • Exhaustive 5-State UI Matrix                              │
│ • Gherkin Given-When-Then Acceptance Criteria               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. PLAN (plan.md)                                           │
│ • Clean Architecture Layer Mapping (Data, Domain, UI)       │
│ • Design System Component Reuse                             │
│ • ViewModel MVI Contracts & Navigation 3 Route Objects      │
│ • Touchpoint Demarcation ([NEW], [MODIFY], [DELETE])        │
│ • Risk & Performance Budget (Stack/Heap, Vitals, 16KB)      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. TASKS (tasks.md)                                         │
│ • Layered Dependency Order (Data -> Domain -> UI -> Tests)  │
│ • Actionable Checklists with Verification Commands          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. IMPLEMENT & VERIFY (walkthrough.md)                      │
│ • Native Tool File Modifications                            │
│ • Automated Build & Test Run (./gradlew compileDebugKotlin) │
│ • Zero Lingering Background Tasks                           │
│ • Reflection & Memory Update                                │
└─────────────────────────────────────────────────────────────┘
```

---

# 2. SPECIFICATION TEMPLATE (`spec.md` or Living Spec Section 1)

```markdown
# Feature Specification: [Feature Name]

## 1. Goal & Problem Statement
- **Problem**: [Describe the user pain point or missing capability]
- **Target Outcome**: [Describe the tangible user and business benefit]
- **Target Platform**: Modern Android (API 26+) / Kotlin Multiplatform

## 2. Target Audience & User Stories
- **Primary Persona**: [End User / Admin / Content Creator]
- **User Story 1**: As a [user], I want to [action] so that [benefit].
- **User Story 2**: As a [user], I want to [action] so that [benefit].

## 3. Domain Model & Boundary Constraints
- **Key Entities**:
  - `EntityName`: [immutable properties, `@JvmInline value class` IDs]
- **Immutability & Stack-Memory**: All domain models must be data classes with `val` properties.

## 4. Mandatory 5-State UI/UX Matrix
| State | Trigger / Condition | UI Representation | Behavioral Requirement |
| :--- | :--- | :--- | :--- |
| **1. Loading** | Async network/DB operation active | Shimmer skeleton or non-blocking spinner | Maintain touch responsiveness; no ANR |
| **2. Content / Success** | Data valid and loaded | Full Compose screen via Design System | 60/120 FPS Lazy Layout scrolling |
| **3. Empty** | Result list empty | Illustration + title + CTA button | Actionable button to retry or create item |
| **4. Error** | Network failure / Exception | Error illustration + retry button | Non-blocking; clear human-readable message |
| **5. Offline** | Device disconnected | Cached local data + offline badge/banner | Disable online triggers gracefully |

## 5. Behavioral Acceptance Criteria (Gherkin Format)
```gherkin
Scenario: Successfully loading feature content
  Given the user is on the Feature Screen
  And the network connection is active
  When the initial load completes
  Then the UiState transitions from Loading to Success
  And the content list displays all retrieved items

Scenario: Handling empty state
  Given the user searches with a query yielding 0 results
  When the search response returns empty
  Then the UiState displays the Empty state component with a "Clear Filter" button
```

## 6. Non-Functional Constraints
- **Crash Rate**: $< 0.05\%$
- **ANR Rate**: $< 0.02\%$
- **Cold Start Impact**: $< 50\text{ms}$ addition to startup
- **16KB Memory Page Alignment**: Zero incompatible C/C++ native binaries
```

---

# 3. TECHNICAL PLAN TEMPLATE (`plan.md` or Living Spec Section 2)

```markdown
# Technical Architecture Plan: [Feature Name]

## 1. Layer Architecture Mapping

### A. Data Layer
- **Data Source**: Ktor Client / Room DAO / DataStore.
- **DTOs & Mappers**: Extension functions mapping DTO $\rightarrow$ Domain Model.
- **Repository Implementation**: `FeatureRepositoryImpl` executing on `Dispatchers.IO`.

### B. Domain Layer
- **Domain Models**: Pure Kotlin models without Android framework dependencies.
- **Repository Interface**: `FeatureRepository` returning `Flow<Result<T>>` or suspending functions.
- **Use Cases**: Single-responsibility use cases (`GetFeatureItemsUseCase`, `UpdateFeatureItemUseCase`).

### C. Presentation Layer (Jetpack Compose + MVI)
- **Contract**:
  - `FeatureUiState`: Exhaustive sealed hierarchy or data class representing the 5 states.
  - `FeatureIntent`: Sealed interface for user actions.
  - `FeatureEffect`: Sealed interface for one-off side effects (navigation, snackbar).
- **ViewModel**: `FeatureViewModel` extending `BaseViewModel<FeatureUiState, FeatureIntent, FeatureEffect>`.
- **UI Components**:
  - `FeatureScreen` (Stateful route container connecting ViewModel and Navigator).
  - `FeatureContent` (Stateless Composable receiving state and lambda callbacks).

### D. Navigation & Dependency Injection
- **Navigation 3 Route**: `@Serializable data class Feature(val id: String) : Screen`.
- **Koin Module**: `viewModelOf(::FeatureViewModel)`, `singleOf(::FeatureRepositoryImpl) bind FeatureRepository::class`.

## 2. File Demarcation
- `[NEW]` `domain/model/FeatureItem.kt`
- `[NEW]` `domain/usecase/GetFeatureItemsUseCase.kt`
- `[NEW]` `data/repository/FeatureRepositoryImpl.kt`
- `[NEW]` `presentation/feature/FeatureContract.kt`
- `[NEW]` `presentation/feature/FeatureViewModel.kt`
- `[NEW]` `presentation/feature/FeatureScreen.kt`
- `[MODIFY]` `di/FeatureModule.kt`
- `[MODIFY]` `core/navigation/AppNavigator.kt`

## 3. Risk & Quality Analysis
- **Stack vs Heap Allocation**: Primitive state used where applicable; zero lambdas capturing scope inside Compose draw loops.
- **Main Thread Safety**: All I/O confined to `Dispatchers.IO`.
```

---

# 4. TASK CHECKLIST TEMPLATE (`tasks.md` or Living Spec Section 3)

```markdown
# Task Execution Checklist: [Feature Name]

## Execution Phases

- [ ] **Phase 1: Data & Domain Layer**
  - [ ] 1.1: Create Domain Models & Repository Interface (`domain/`)
  - [ ] 1.2: Implement DataSources & Repository Implementation (`data/`)
  - [ ] 1.3: Create Domain Use Cases with unit tests (`domain/usecase/`)

- [ ] **Phase 2: Presentation & MVI Architecture**
  - [ ] 2.1: Define MVI Contract (`UiState`, `Intent`, `Effect`)
  - [ ] 2.2: Implement `FeatureViewModel` with `safeLaunch` and 5-state handling
  - [ ] 2.3: Build Stateless `FeatureContent` (Loading, Success, Empty, Error, Offline)
  - [ ] 2.4: Build Stateful `FeatureScreen` connecting to Navigation 3

- [ ] **Phase 3: DI & Navigation Integration**
  - [ ] 3.1: Register Koin module bindings
  - [ ] 3.2: Register Navigation 3 route in `NavDisplay`

- [ ] **Phase 4: Automated Verification**
  - [ ] 4.1: Run Unit Tests: `./gradlew testDebugUnitTest`
  - [ ] 4.2: Run Compilation: `./gradlew compileDebugKotlin`
  - [ ] 4.3: Verify Enforcement Gate E18 compliance
```

---

# 5. ZERO SPEC DRIFT PROTOCOL

When unexpected requirements or architectural challenges arise during implementation:

1. **PAUSE** coding immediately.
2. **DOCUMENT** the discovered constraints or requirement changes.
3. **UPDATE** the `spec.md` (or Living Spec) and obtain user agreement.
4. **ADJUST** the `plan.md` and `tasks.md`.
5. **RESUME** execution against the aligned contract.
