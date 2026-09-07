# 30-build-runtime-verification.md

# REAL BUILD & RUNTIME VERIFICATION MANDATE

## Purpose

This document establishes the official **Real Build & Runtime Verification Standard** across the entire Antigravity Engine.

Its mission is to eliminate the dangerous gap where **"Unit Tests pass, but the application fails to build, crashes on launch, or freezes on an infinite loading spinner"**. Every task MUST be validated through full-graph compilation, dependency injection integrity, realistic state assertions, and runtime trigger verification before completion.

---

# 1. THE 5 PILLARS OF REALISTIC VERIFICATION

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. FULL ASSEMBLE BUILD GATE  │ Mandatory `./gradlew assembleDebug testDebugUnitTest`   │
├──────────────────────────────┼─────────────────────────────────────────────────────────┤
│ 2. KOIN DI GRAPH INTEGRITY   │ 100% of ViewModel & UseCase dependencies bound in Koin  │
├──────────────────────────────┼─────────────────────────────────────────────────────────┤
│ 3. INITIAL DATA TRIGGER      │ All screens MUST trigger initial load (no frozen spin) │
├──────────────────────────────┼─────────────────────────────────────────────────────────┤
│ 4. REALISTIC STATE ASSERTION │ Assert actual StateFlow values; forbid pure mock-verify │
├──────────────────────────────┼─────────────────────────────────────────────────────────┤
│ 5. AAPT2 & RESOURCE DEFENSE  │ 100% of strings.xml, drawables, layouts resolved        │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# 2. PILLAR 1: MANDATORY FULL ASSEMBLE BUILD

### The Problem
Running only `./gradlew testDebugUnitTest` skips AAPT2 resource linking, KSP Room schema processing, ProGuard/R8 rules, and full DEX packaging. Code that passes unit tests can fail catastrophically during APK assembly.

### Mandatory Rules
1. **Full Verification Command**: Before marking ANY task complete, the AI MUST execute:
   ```bash
   ./gradlew assembleDebug testDebugUnitTest --stacktrace
   ```
   *(For KMP projects, execute `./gradlew compileDebugKotlin desktopJar test` or equivalent)*
2. **Zero-Tolerance Build Gate**: If `assembleDebug` fails due to resource linking, unresolved references, or KSP errors, the task is **STRICTLY INCOMPLETE**.

---

# 3. PILLAR 2: KOIN DI GRAPH INTEGRITY (ZERO RUNTIME INJECTION CRASHES)

### The Problem
Koin uses runtime dependency resolution. If a developer creates a new `FeatureUseCase` and injects it into `FeatureViewModel`, but forgets to register `factoryOf(::FeatureUseCase)` in `di/AppModule.kt`:
- Code compiles fine.
- Unit tests pass (because tests instantiate dependencies manually or via mocks).
- **At Runtime: App crashes instantly with `InstanceCreationException: Could not create instance for [FeatureViewModel]`**.

### Mandatory Rules
1. **Constructor-to-Module Audit**: Whenever a ViewModel, UseCase, Repository, or DataSource constructor is created or modified, the AI MUST immediately verify that the corresponding Koin module in `di/` has the exact binding:
   ```kotlin
   // In di/FeatureModule.kt
   val featureModule = module {
       singleOf(::FeatureRepositoryImpl) bind FeatureRepository::class
       factoryOf(::GetFeatureItemsUseCase)
       viewModelOf(::FeatureViewModel)
   }
   ```
2. **Koin Module Verification Test**: Projects utilizing Koin MUST maintain a Koin verification test:
   ```kotlin
   @Test
   fun verifyKoinAppModules() {
       appModules.verify()
   }
   ```

---

# 4. PILLAR 3: INITIAL DATA TRIGGER SAFETY (ZERO FROZEN LOADING SPINNERS)

### The Problem
A ViewModel defines a robust `loadData()` function and its tests pass. However, neither the ViewModel's `init {}` block nor the Screen Composable's `LaunchedEffect(Unit)` triggers `loadData()` $\rightarrow$ The user opens the screen and sees an infinite loading spinner.

### Mandatory Rules
1. **Automatic Initial Trigger Mandate**: Every feature screen that requires initial data MUST have an explicit trigger:
   * **Option A (ViewModel init)**:
     ```kotlin
     init {
         onIntent(FeatureIntent.LoadInitialData)
     }
     ```
   * **Option B (Compose LaunchedEffect)**:
     ```kotlin
     LaunchedEffect(Unit) {
         onIntent(FeatureIntent.LoadInitialData)
     }
     ```
2. **Default State Safety**: Default UI state MUST NOT remain in a permanent `Loading` state if no async operation is actively launched.

---

# 5. PILLAR 4: ANTI-OVER-MOCKING & REALISTIC STATE ASSERTIONS

### The Problem
Writing tests that only verify mock method invocations (`verify(exactly = 1) { repository.getData() }`) without checking the actual `UiState` value. If mapping logic breaks or emits an unexpected error state, the test still reports `PASS`.

### Mandatory Rules
1. **Assert StateFlow Values**: Unit tests for ViewModels and UseCases MUST assert the exact emitted state:
   ```kotlin
   // PREFERRED: Asserting concrete state progression
   viewModel.uiState.test {
       assertEquals(FeatureUiState.Loading, awaitItem())
       val success = awaitItem() as FeatureUiState.Success
       assertEquals(3, success.items.size)
       assertEquals("Expected Title", success.items.first().title)
   }
   ```
2. **Forbid Shallow Mock Tests**: A test suite containing only `verify { mock.call() }` with zero assertions on resulting data is considered a **Fake Test** and violates this rule.

---

# 6. PILLAR 5: AAPT2 & RESOURCE RESOLUTION DEFENSE

### The Problem
Hardcoded string resource IDs or missing XML entries cause runtime `Resources$NotFoundException`.

### Mandatory Rules
1. Every `R.string.xxx` reference in Compose code MUST have a corresponding XML definition in `app/src/main/res/values/strings.xml` (in English) and secondary localization files.
2. Every `R.drawable.xxx` must exist in `res/drawable/` as a valid vector or raster asset.

---

# 7. ENFORCEMENT & COMPLIANCE

* This rule is strictly guarded by **CATEGORY E20 (Real Build & Runtime Verification Gate)** in `rules/21-enforcement-engine.md`.
* No code passes the completion gate without real build evidence and DI graph validation.
