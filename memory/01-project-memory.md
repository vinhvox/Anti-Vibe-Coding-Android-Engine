# 01-project-memory.md

# Project Memory (Generic Modern Android Framework Baseline)

## Purpose

This document defines how the AI understands, stores, and maintains long-term project knowledge for modern Android applications.

Project Memory represents stable engineering knowledge about the project. It enables the AI to make consistent engineering decisions without repeatedly rediscovering the same information.

---

# Baseline Architecture Profile (Modern Android 2026)

Every project running under the Antigravity Android Framework adheres to this baseline unless explicitly overridden in the local project configuration:

## 1. UI & Design System
- **Framework:** Jetpack Compose (Material 3 BOM)
- **Design System:** Centralized `AppTheme` token wrapper (`Theme.kt`, `Color.kt`, `Spacing.kt`, `Type.kt`, `Shape.kt`)
- **Aesthetic Standard:** [Rule 36 (World-Class UI/UX)](../rules/36-ui-ux-design-standard.md) & 5-State UI Matrix (Empty, Loading, Content, Error, Offline)
- **Composables Hierarchy:** Atoms (Icon, Text) -> Molecules (Input, ListItem) -> Organisms (TopBar, BottomSheet) -> Screens

## 2. Navigation
- **Framework:** Navigation 3 (Compose-first, State-driven backend)
- **Route Definitions:** Strongly typed, `@Serializable` data classes or sealed interfaces (Strictly NO raw string-based URI paths for internal navigation)
- **Router Backstack:** Reactive `SnapshotStateList<Screen>` driven by centralized router with 400ms debounce

## 3. Presentation & State Management
- **Architecture:** MVI / Uni-Directional Data Flow (UDF)
- **Base Class:** Every ViewModel MUST inherit from `BaseViewModel<State, Intent, Effect>`
- **Coroutines Scope:** Lifecycle-bound `safeLaunch` with structured exception handling
- **Flow Invariants:** Read-only `StateFlow<UIState>` exposed to UI, updated via `_state.update { copy(...) }`

## 4. Dependency Injection
- **Framework:** Koin (Constructor-based injection, lightweight, KMP-friendly)
- **Module Structure:** Modularized DI (`coreModule`, `networkModule`, `databaseModule`, `featureModule`)

## 5. Data & Domain Layer
- **Pattern:** Clean Architecture (UI -> Domain -> Data)
- **Networking:** Ktor Client with content negotiation and serialization
- **Persistence:** Room Database (with WAL mode, migrations, and exportSchema enabled)
- **Preferences:** Jetpack DataStore (Preferences / Proto)
- **Repository Strategy:** Single Source of Truth (SSOT) — Database as truth, Network as updater

---

## 19 Core Engineering Compliance Checklist
For ANY active project profile, the AI must enforce:
1. **Lifecycle & State:** 3-Tier State, SavedStateHandle, Process Death resilience
2. **Background Execution:** WorkManager, `isStopped` checks, `NonCancellable` cleanup
3. **Permissions & Privacy:** JIT verification, `PickVisualMedia`
4. **Networking & Offline-first:** SSOT Room, Outbox Queue, Exponential backoff
5. **Persistence & Migration:** Zero data loss, MigrationTestHelper, WAL
6. **Navigation:** State-driven Navigation 3, `@Serializable` routes, 400ms debounce
7. **Adaptive UI:** WindowSizeClass Compact/Medium/Expanded, `safeDrawing`, `imePadding`
8. **Accessibility (a11y):** Minimum 48x48dp touch bounds, Non-linear 200% font scale
9. **Localization & Theming:** RTL Start/End, `pluralStringResource`, semantic token theme
10. **Concurrency & Flow:** Main-thread purity, atomic StateFlow updates
11. **Performance & Vitals:** Stack vs Heap discipline, Baseline Profiles, Startup TTID < 500ms
12. **Platform Behaviors:** SDK_INT branching, Predictive Back gesture
13. **Cross-Platform Bridge:** Pigeon type safety (if KMP/Flutter)
14. **System Integrations:** Lifecycle-bound sensors & CameraX
15. **Security:** Hardware Keystore, `FLAG_SECURE`
16. **Build & 16KB:** 16KB page alignment linker flags, In-App updates
17. **Observability:** Breadcrumbs, `reportFullyDrawn` TTFD
18. **Testing Strategy:** Turbine, Koin verify, real Gradle build verification
19. **Failure Modeling:** The 10 Ultimate Failure Modes

---

# Customizing for Your Project
To customize this profile for a specific project, copy `templates/memory/project-memory.template.md` to your local project's `.antigravity/memory/01-project-memory.md`.
