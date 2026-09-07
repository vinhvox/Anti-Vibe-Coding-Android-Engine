# 26-stack-heap-memory.md

# Purpose

This document establishes the project's foundational mandate for **Stack vs Heap Memory Management** across Android Jetpack Compose, Kotlin Multiplatform (KMP), Kotlin Coroutines, and Data pipelines.

Memory efficiency is not an afterthought; it is a critical pillar of system architecture. The goal is to maximize **Stack frame allocation (Zero-GC, O(1) speed, L1/L2 cache locality)** and strictly govern **Heap memory allocation (GC pressure elimination, 60/120 FPS jank prevention, and zero memory leaks)**.

---

# Related Files

- Rules: `rules/01-tech-stack.md`, `rules/02-architecture.md`, `rules/06-compose.md`, `rules/07-viewmodel.md`, `rules/08-coroutines.md`, `rules/16-performance.md`, `rules/21-enforcement-engine.md` (Gate E10)
- Skills: `skills/stack-heap-memory.md`, `skills/performance.md`, `skills/clean-code.md`

---

# Fundamental Mechanics: Stack vs Heap

| Dimension | Stack Memory (Call Stack) | Heap Memory (Dynamic Memory) |
| :--- | :--- | :--- |
| **Allocation Speed** | Instantaneous ($O(1)$ stack pointer offset) | Variable (Free-list / Bump pointer allocation) |
| **Deallocation** | Automatic on frame exit ($O(1)$ zero overhead) | Non-deterministic Garbage Collection (GC) sweeps |
| **GC Overhead** | **Zero GC Pauses** | **Minor GC / Major GC pauses (Causes frame jank)** |
| **Locality** | High L1/L2 CPU Cache Locality | Distributed memory pages / Pointer chasing |
| **Ideal Payload** | Primitives, Unboxed Value Classes, Frame refs | Domain Aggregates, State Trees, Bitmaps, Long-lived data |
| **Architectural Goal**| **Maximize utilization on Hot Paths & Identifiers** | **Minimize churning, eliminate leaks, optimize lifecycle** |

---

# Mandatory Stack & Heap Rules

## Rule 26.1: Value Classes for Domain Identifiers & Metrics (Stack-Resident)
To prevent boxing primitive identifiers into heavy Heap objects:
1. All domain identifiers, timestamps, durations, and metric wrappers MUST be defined as `@JvmInline value class` (or `value class` in KMP `commonMain`):
   ```kotlin
   // ❌ BAD: Allocates a new Heap object instance for every ID
   data class UserId(val value: Long)
   data class DurationMs(val value: Long)
   
   // ❌ BAD: Primitive obsession without type-safety
   fun getUser(userId: Long)
   
   // ✅ GOOD: Stack-allocated unboxed primitive at runtime with 100% compile-time type safety
   @JvmInline
   value class UserId(val value: Long)
   
   @JvmInline
   value class DurationMs(val value: Long)
   ```
2. **Boxing Guard:** NEVER cast a value class to `Any`, `Comparable`, or an interface in performance-critical loops, as this forces ART/JVM to box the value class onto the Heap.

---

## Rule 26.2: Zero Transient Heap Allocation in Composition & Draw Phases
Composable functions and Canvas draw passes re-execute every frame (8.3ms on 120Hz / 16.6ms on 60Hz). Allocating objects inside the Composable body causes severe Young Gen Heap churning:
1. **Forbidden inside `@Composable` body and `drawBehind {}`:**
   - `SimpleDateFormat`, `DecimalFormat`, `DateTimeFormatter`
   - `Regex` compilation
   - JSON parsing or AST serialization
   - Collection transformations (`.filter()`, `.map()`, `.sorted()`)
   - Transient `Modifier.then()` chains and anonymous object instantiations
2. **Production-Ready Pattern:**
   - Pre-compute all formatted display strings and transformed collections upstream inside the `ViewModel` / `Reducer`.
   - If an allocation is UI-local and unavoidable, wrap it in `remember(key1, key2) { ... }` to allocate once and reuse across recompositions:
   ```kotlin
   // ❌ BAD: Allocates DateFormatter and filtered ArrayList on Heap every frame
   @Composable
   fun TransactionList(items: List<Transaction>) {
       val formatter = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
       val active = items.filter { it.isActive }
       LazyColumn { ... }
   }
   
   // ✅ GOOD: Zero allocations in Composition; data is pre-calculated & memoized
   @Composable
   fun TransactionList(
       items: ImmutableList<TransactionUiModel>, // Pre-formatted upstream
       modifier: Modifier = Modifier
   ) {
       LazyColumn(modifier = modifier) {
           items(items, key = { it.id.value }) { item ->
               TransactionRow(item = item)
           }
       }
   }
   ```

---

## Rule 26.3: Primitive Snapshot State Specialization (Autoboxing Elimination)
Using `mutableStateOf<T>()` with primitive types boxes primitives into `java.lang.Integer`, `java.lang.Float`, etc., creating new wrapper objects on the Heap upon state updates:
1. **Mandatory Snapshot Specialization:**
   - Use `mutableIntStateOf(0)` instead of `mutableStateOf(0)`
   - Use `mutableFloatStateOf(0f)` instead of `mutableStateOf(0f)`
   - Use `mutableLongStateOf(0L)` instead of `mutableStateOf(0L)`
   - Use `mutableDoubleStateOf(0.0)` instead of `mutableStateOf(0.0)`
2. **Benefit:** Stores raw primitive values directly on the stack/specialized backing field, completely eliminating Heap wrapper allocation and GC pressure.

---

## Rule 26.4: Inline Functions & Closure Zero-Allocation
Kotlin closures compile to Heap-allocated `Function0`, `Function1`, or `Function2` objects if they capture variables from their enclosing scope:
1. **Higher-Order Utility Functions:** All general utility functions, measurement blocks, and scope helpers in hot paths MUST be marked `inline`:
   ```kotlin
   // ✅ GOOD: Inlined into the caller's Stack frame; zero Function object allocation on Heap
   inline fun <T> measureExecutionTime(tag: String, block: () -> T): T {
       val start = System.nanoTime()
       val result = block()
       val elapsedMs = (System.nanoTime() - start) / 1_000_000
       Logger.d(tag, "Executed in $elapsedMs ms")
       return result
   }
   ```
2. **Compose Callbacks:** For Composable event callbacks that cannot be inlined, use **Method References** (`viewModel::onIntent`) or `remember(key) { { ... } }` to avoid allocating new lambda instances on the Heap on every recomposition.

---

## Rule 26.5: Collection Heap Churn Elimination (Sequences vs Iterables)
Chaining standard Kotlin collection operators (`.filter().map().take()`) creates intermediate `ArrayList` instances on the Heap at each step:
1. **Multi-step Transformations:** For collections with $\ge 10$ elements or processing pipelines with $\ge 2$ chained operations, use `.asSequence()` to enable lazy streaming without intermediate Heap allocations:
   ```kotlin
   // ❌ BAD: Creates 3 intermediate ArrayList objects on Heap
   val topActiveUsers = users
       .filter { it.isActive }       // Heap ArrayList #1
       .map { it.toUiModel() }       // Heap ArrayList #2
       .take(10)                     // Heap ArrayList #3
   
   // ✅ GOOD: Single pipeline iteration; zero intermediate Heap collections
   val topActiveUsers = users.asSequence()
       .filter { it.isActive }
       .map { it.toUiModel() }
       .take(10)
       .toList()                     // Only 1 final List allocated on Heap
   ```
2. **Primitive Arrays:** In computation-heavy loops, audio/video DSP, cryptography, and canvas path calculations, use **Primitive Arrays** (`IntArray`, `FloatArray`, `ByteArray`) instead of `Array<Int>` or `List<Int>` to store continuous raw memory directly without boxed object overhead.

---

## Rule 26.6: Strict Heap Lifecycle & Memory Leak Elimination
Heap retention of short-lived UI components causes severe OOM (Out Of Memory) crashes and background battery drain:
1. **Prohibited Context Retention:**
   - NEVER store `Activity`, `Fragment`, `View`, or UI `Context` references inside `ViewModel`, `Repository`, `Singleton`, or long-lived `CoroutineScope`.
   - If a context is strictly necessary in a singleton/manager, use `applicationContext` only.
2. **Symmetrical Lifecycle Cleanup:**
   - All BroadcastReceivers, Hardware Sensors, Event Listeners, and WebSocket connections MUST have symmetrical disposal inside `DisposableEffect.onDispose { ... }` or `ViewModel.onCleared()`:
   ```kotlin
   // ✅ GOOD: Guarantees listener is dereferenced from Heap when Composable leaves composition
   DisposableEffect(sensorManager, listener) {
       sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_UI)
       onDispose {
           sensorManager.unregisterListener(listener)
       }
   }
   ```
3. **Structured Concurrency Scoping:**
   - Never use `GlobalScope` or unbounded `CoroutineScope(Dispatchers.Default)`.
   - UI StateFlow collections MUST use `collectAsStateWithLifecycle()` to pause and release background resources.

---

## Rule 26.7: Direct & Graphic Memory Optimization (16KB & Bitmaps)
Large binary payloads and graphical assets must not overwhelm the Java/Kotlin Heap:
1. **Hardware Bitmaps:** Image loading (Coil) must prefer `Bitmap.Config.HARDWARE` on Android, keeping pixel data directly in GPU Graphic Memory (GraphicBuffers) rather than polluting the JVM Heap.
2. **16KB Memory Page Alignment:** All native libraries (`.so`) and JNI buffers must comply with 16KB ELF alignment (Android 15+) and use Direct ByteBuffers (`ByteBuffer.allocateDirect()`) for high-throughput zero-copy streaming.

---

# Architecture Compliance Checklist

Before reporting ANY task or PR as complete, verify:

- [ ] All domain IDs and timestamp metrics are unboxed `@JvmInline value class` instances.
- [ ] Zero object instantiations (`SimpleDateFormat`, `Regex`, transient Modifier chains) inside `@Composable` bodies and `drawBehind {}`.
- [ ] 100% of primitive snapshot states use `mutableIntStateOf()`, `mutableFloatStateOf()`, or `mutableLongStateOf()`.
- [ ] High-frequency higher-order utility functions are marked `inline`.
- [ ] Multi-step collection transformations use `.asSequence()` to eliminate intermediate Heap lists.
- [ ] Zero `Activity` / `View` / `Context` references stored in ViewModels or Singletons.
- [ ] All `DisposableEffect` blocks contain explicit, verified cleanup in `onDispose`.
- [ ] 100% compliant with Enforcement Gate **E10** in `rules/21-enforcement-engine.md`.
