---
name: mobile-engineering-core
description: Comprehensive architectural standard and defense matrix for the 19 core mobile engineering domains in Modern Android, Jetpack Compose, KMP, and Native platforms.
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
19. **Hostile Runtime & Edge Cases Defense**: The 8-Vector Hostile Runtime Matrix (**Rule 39 & Gate E30**): Process Death, Network Chaos & Captive Portals, Concurrency & Cancellation Leaks, Storage Saturation, Display Metamorphosis, Permissions JIT, OEM Battery Throttling, UI String & Inset Pathologies.

---

## The 8-Vector Hostile Runtime Defense Quick Reference (Rule 39)

| Runtime Vector | Hostile Threat / Edge Case | Mandatory Engineering Defense & Pattern |
| :--- | :--- | :--- |
| **1. Process & Memory** | Process Death (LMK), `TransactionTooLargeException` (>500KB) | Save minimal primitive keys in `SavedStateHandle`; re-hydrate from Room SSOT; evict bitmaps on `TRIM_MEMORY_RUNNING_CRITICAL`. |
| **2. Network Chaos** | Hard offline, Captive Portal HTML trap, 401 Concurrency Race, 429 Jitter | Validate `NET_CAPABILITY_VALIDATED` + `Content-Type: application/json`; serialize 401 refresh with single `Mutex`; parse `Retry-After`. |
| **3. Concurrency & Races** | Swallowed `CancellationException` zombie jobs, Multi-tap races (<400ms), Out-of-order overwrite | Use `safeCatching` (rethrow `CancellationException`); `Modifier.singleClick`; lock ViewModel `isLoading`; use `collectLatest`. |
| **4. Storage & Integrity** | Disk full (`IOException: ENOSPC`), Corrupted partial writes, Scoped Storage URI expiration | Use `AtomicFile` or `.tmp` rename; catch `IOException`; call `takePersistableUriPermission`. |
| **5. Display Metamorphosis**| 200% Accessibility Font Scaling text clipping, Virtual Keyboard IME overlap | Container with `verticalScroll` + `defaultMinSize()`; `Modifier.imePadding()` + `BringIntoViewRequester`. |
| **6. Permissions & Hardware**| JIT runtime permission revocation, Permanent denial loop, Camera in use (`CAMERA_IN_USE`) | Always check `ContextCompat.checkSelfPermission` JIT; handle denial with App Settings deep-link; fallback states. |
| **7. OEM & Background** | Aggressive OEM background killers (MIUI/OneUI), Doze mode, Android 14+ FGS 3-min limits | Use `WorkManager` with `NetworkType.CONNECTED`; declare `foregroundServiceType` in manifest; handle `Service.onTimeout`. |
| **8. UI & Boundary** | 500-char unbroken words, RTL/LTR Bidi mixed text, Multi-codepoint Emojis / ZWJ, Missing states | `Text(overflow = TextOverflow.Ellipsis, softWrap = true)`; RTL Start/End anchoring; 100% 5-State UI coverage. |

---

## Minimalist Drop-In Defenses (Rule 32 Compliant)

```kotlin
// 1. Safe Cancellation Runner (Preserves Structured Concurrency)
inline fun <T> safeCatching(block: () -> T): Result<T> =
    runCatching(block).onFailure { if (it is CancellationException) throw it }

// 2. Single-Click Pointer Debounce Modifier (Filters Double-Taps < 400ms)
fun Modifier.singleClick(debounceMs: Long = 400L, onClick: () -> Unit): Modifier = composed {
    val lastClickTime = remember { longArrayOf(0L) }
    clickable {
        val now = SystemClock.elapsedRealtime()
        if (now - lastClickTime[0] >= debounceMs) {
            lastClickTime[0] = now
            onClick()
        }
    }
}

// 3. Atomic File Writer (Prevents Corrupted Partial Files on OS Kill)
fun File.writeAtomic(data: ByteArray) {
    val atomicFile = AtomicFile(this)
    var stream: FileOutputStream? = null
    try {
        stream = atomicFile.startWrite()
        stream.write(data)
        atomicFile.finishWrite(stream)
    } catch (e: IOException) {
        if (stream != null) atomicFile.failWrite(stream)
        throw e
    }
}
```

---

## Full Master Playbook Reference
The complete living playbook with comprehensive code patterns is maintained at:
`file:///Users/vio/plan/mobile_engineering_master_playbook.md`
