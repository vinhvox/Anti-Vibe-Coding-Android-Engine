---
name: mobile-engineering-core
description: Comprehensive architectural standard and defense matrix for the 19 core mobile engineering domains in Modern Android, Jetpack Compose, KMP, and Native platforms.
always_apply: false
---

# Mobile Engineering Core (19 Domains Matrix)

This skill provides a deep, production-grade architectural defense reference across all **19 Core Domains of Mobile Engineering**.

---

## 19 Core Domains Overview

1. **Lifecycle & State**: 3-Tier State Hierarchy (Ephemeral `remember`, Re-creation Safe `rememberSaveable`/`SavedStateHandle`, Persistent Room/DataStore). State restoration after Process Death.
2. **Background Execution**: Task categorization (`Immediate`, `Guaranteed WorkManager`, `ForegroundService`). Exponential backoff with jitter. Cooperative cancellation check (`isStopped`).
3. **Permissions & Privacy**: Just-In-Time (JIT) runtime checks. Zero-permission PhotoPicker. Graceful degradation on permanent denial.
4. **Networking & Offline-first**: Single Source of Truth (SSOT). NetworkBoundResource flow. Outbox Pattern with UUID idempotency keys.
5. **Persistence & Migration**: Strict zero data loss. Mandatory `MigrationTestHelper` tests. SQLite WAL mode & atomic transactions (`@Transaction`).
6. **Navigation & Routing**: State-driven Navigation 3 (`SnapshotStateList<NavKey>`). Type-safe `@Serializable` destinations. Synthetic backstack on deep links. Single-click debounce.
7. **Adaptive UI & Insets**: Material 3 WindowSizeClass (`Compact`, `Medium`, `Expanded`). Edge-to-Edge `WindowInsets.safeDrawing` & `WindowInsets.ime`. IME padding & scrolling.
8. **Accessibility (a11y)**: Minimum 48x48dp interactive bounds (`minimumInteractiveComponentSize()`). Non-linear font scaling on Android 14+. TalkBack semantic roles.
9. **Localization & Theming**: Start/End layout anchoring (RTL safe). Plurals via `getQuantityString`. Dynamic Material You theming & semantic token hierarchy.
10. **Concurrency & Flow**: Main-thread purity. Atomic StateFlow updates (`_state.update {}`). Cooperative cancellation (`ensureActive()`, rethrow `CancellationException`).
11. **Performance & Vitals**: Stack vs Heap discipline (`Rule 26`). Primitive States (`mutableIntStateOf`). Baseline Profiles. Cold Start TTID < 500ms, TTFD < 800ms.
12. **Platform Behaviors & OEM**: SDK version branching (`Build.VERSION.SDK_INT`). Predictive Back gesture integration. OEM aggressive background termination guidance.
13. **Flutter ↔ Native Bridge**: Type-safe IPC via Pigeon. Engine warm-up (`FlutterEngineCache`). Dart background isolates for heavy compute.
14. **System Integrations**: Lifecycle-bound sensors and camera (`DisposableEffect` + `LifecycleEventObserver`). Direct Activity PendingIntents.
15. **Security & Cryptography**: Hardware-backed Keystore (`EncryptedSharedPreferences`, `EncryptedFile`). Window `FLAG_SECURE`. Network Security Config cleartext blocking.
16. **Build & 16KB Release**: 16KB memory page alignment linker flags (`-Wl,-z,max-page-size=16384`). R8 mapping upload. Google Play In-App Updates.
17. **Observability & Vitals**: Structured Crashlytics breadcrumbs. AndroidX Tracing (`trace("...") {}`). `reportFullyDrawn()` measurement.
18. **Testing Strategy**: Turbine for StateFlow/SharedFlow. Koin DI graph verification (`appModule.verify()`). Mandatory real assemble build (`./gradlew assembleDebug testDebugUnitTest`).
19. **Failure Modeling**: The 10 Ultimate Failure Modes (App Kill, Backgrounding, Permission Revoke, Network Loss, Disk Full, Migration Fail, Stale Async Race, Duplicate Click, Missing Hardware, Thermal Throttling).

---

## The 10 Failure Mode Defenses Quick Reference

| Failure Mode | Root Cause | Defense & Recovery Pattern |
| :--- | :--- | :--- |
| **App Kill (Process Death)** | OS kills background process due to low RAM | Save minimal keys in `SavedStateHandle`; re-hydrate from Room on revive. |
| **Backgrounding** | OS suspends CPU / throttling | Suspend sensors & live camera streams in `onPause`/`onDispose`. |
| **Permission Revoke** | User revokes in Settings while backgrounded | Catch `SecurityException` at DataSource; check permissions JIT. |
| **Network Loss** | Offline or packet loss | Display Offline Banner; read SSOT Room DB; enqueue writes to Outbox. |
| **Storage Full** | Disk exhaustion (`IOException`) | Catch disk exceptions; auto-evict temporary image/HTTP caches. |
| **Migration Fail** | Schema mismatch | Verify migrations with `MigrationTestHelper` before release. |
| **Stale Async Result** | Rapid user switches / out-of-order responses | Use `collectLatest` or `restartableOrLatest` coroutine scoping. |
| **Duplicate Callback** | Fast multi-taps | Apply 400ms debounce at UI layer + UUID idempotency keys at Data layer. |
| **Unsupported API** | Running on older Android or missing sensor | Guard with `Build.VERSION.SDK_INT` and `hasSystemFeature` checks. |
| **Device Throttling** | RAM < 3GB or thermal severe | Disable glassmorphism blur and downsample image decode size. |

---

## Full Master Playbook Reference
The complete living playbook with comprehensive code patterns is maintained at:
`~/plan/mobile_engineering_master_playbook.md`
