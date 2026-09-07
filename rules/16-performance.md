# 16-performance.md

# Purpose

This document defines the project's performance engineering principles and quantitative performance budgets.

Performance is a functional requirement. It must be considered during design, implementation, testing, and continuous review.

The goal is to deliver applications that are:

- **Ultra-Fast & Responsive (60/120 FPS)**
- **Memory-Efficient & Leak-Free**
- **Battery-Friendly (Zero Unmanaged Background Work)**
- **Compiler-Optimized for Compose Skipping**
- **Offline-First & Instant-Loading**

---

# Core Principles & Quantitative Budget

Measure before optimizing. Avoid premature optimization, but design for performance from the beginning.

### Quantitative Performance Budgets
- **Frame Budget:** < 16.6ms per frame for 60Hz displays, < 8.3ms per frame for 120Hz ProMotion/High-Refresh displays. Zero dropped frames (jank) during scrolling or animations.
- **Cold Start Time:** < 500ms (TTID - Time to Initial Display), < 800ms (TTFD - Time to Full Display).
- **Memory Footprint:** Baseline heap < 64MB; no memory leaks across screen transitions (monitored via LeakCanary).
- **Main Thread Block Time:** Zero operations exceeding 5ms on `Dispatchers.Main`.

---

# Jetpack Compose Performance Standards

### 1. Compose Compiler Stability & Smart Skipping
- **Mandatory:** All UI state models, DTOs, and event arguments MUST be evaluate-able as **Stable** by the Compose Compiler.
- Mark UI state data classes with `@Immutable` or `@Stable`.
- Use `kotlinx.collections.immutable.ImmutableList` / `PersistentList` instead of standard Kotlin `List` in public composables to allow the compiler to skip recomposition.

### 2. Deferred State Reads (Phased Execution)
- Never read high-frequency changing state (such as scroll offset, animation progress, or touch gestures) in the **Composition Phase**.
- Defer state reads to the **Layout** or **Draw** phase:
  - Use `Modifier.graphicsLayer { alpha = ...; translationY = ... }`
  - Use `Modifier.offset { IntOffset(...) }`
  - Use `Modifier.drawBehind { ... }`
- **Result:** Skips the expensive Composition phase entirely and directly repaints the canvas.

### 3. Snapshot State Primitive Specialization
Avoid autoboxing overhead for primitive values by using specialized snapshot state primitives:
- `mutableIntStateOf(0)` instead of `mutableStateOf(0)`
- `mutableFloatStateOf(0f)` instead of `mutableStateOf(0f)`
- `mutableLongStateOf(0L)` instead of `mutableStateOf(0L)`

### 4. Zero Heavy Allocations in Composition Phase
- NEVER create expensive objects inside the Composable body (e.g. `SimpleDateFormat`, `Regex`, JSON parsers, list filtering/sorting).
- Pre-compute all display values inside the `ViewModel` or wrap with `remember(keys) { ... }`.

### 5. Stable Keys in Lazy Layouts
- 100% of `items()` in `LazyColumn`, `LazyRow`, and `LazyGrid` MUST specify a stable, unique `key = { it.id }`.
- Provide `contentType = { it.itemType }` for heterogeneous lists to maximize item view recycling.

---

# Coroutine & Asynchronous Performance

### 1. Lifecycle-Aware Flow Collection
- Screen UI MUST collect `StateFlow` using `collectAsStateWithLifecycle()` from `androidx.lifecycle:lifecycle-runtime-compose`.
- **Prohibited:** `flow.collectAsState()`, which keeps collecting when the app is in the background, consuming CPU, GPS, network, and battery.

### 2. Thread Dispatcher Strictness
- `Dispatchers.Main`: Only for UI layout and lightweight state mutations.
- `Dispatchers.IO`: For network requests, disk I/O, database access, and file compression.
- `Dispatchers.Default`: For heavy CPU computation, encryption, complex data parsing, and image processing.
- Avoid unnecessary thread hopping and nested `withContext` switches in hot paths.

---

# Memory & Resource Management (refs: `rules/26-stack-heap-memory.md`)

1. **Stack vs Heap Memory Mandate:**
   - Follow `rules/26-stack-heap-memory.md` strictly for all memory allocation patterns.
   - Use `@JvmInline value class` for domain identifiers to remain unboxed on the Stack.
   - Use specialized primitive snapshot states (`mutableIntStateOf`, `mutableFloatStateOf`, `mutableLongStateOf`) to eliminate Heap autoboxing.
   - Use `.asSequence()` for multi-step chained collection pipelines ($\ge 2$ steps) to avoid intermediate `ArrayList` Heap allocations.
2. **Immediate Resource Release & Leak Prevention:**
   - Always unregister listeners, observers, receivers, and sensors in `DisposableEffect.onDispose { ... }` or `ViewModel.onCleared()`.
   - Never store `Activity`, `Fragment`, `View`, or UI `Context` inside `ViewModel` or `Singleton`.
3. **Bitmap & Media Handling:**
   - Downsample bitmaps before decoding into memory.
   - Use Coil with hardware bitmaps (`Bitmap.Config.HARDWARE`) and memory caching enabled.
   - Release media player (ExoPlayer) resources immediately when leaving playback.
4. **App Quality & Android Vitals (refs: `rules/27-app-quality-vitals.md`):**
   - Comply with all Android Vitals budgets (Crash $< 0.05\%$, ANR $< 0.02\%$, Cold Start $< 500\text{ms}$).
   - Follow 2-Tier Hybrid Splash architecture (System Splash $< 200\text{ms}$, In-App Splash fail-safe timeouts).

---

# Review Checklist Before Merge

- [ ] Frame rate verified at 60/120 FPS with zero visible jank during fast scrolling.
- [ ] 100% compliant with `rules/26-stack-heap-memory.md` (Gate **E16**) and `rules/27-app-quality-vitals.md` (Gate **E17**).
- [ ] No raw `List<T>` parameters in public composables without `@Immutable` / `ImmutableList`.
- [ ] No high-frequency state read in Composition phase (use `graphicsLayer`).
- [ ] 100% Lazy layout items have unique, stable `key = { it.id }`.
- [ ] 100% Flows collected via `collectAsStateWithLifecycle()`.
- [ ] No `SimpleDateFormat` or heavy calculations inside Composable bodies.
- [ ] All `DisposableEffect` blocks contain valid cleanup in `onDispose`.