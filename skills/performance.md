# Performance & Recomposition

Comprehensive performance engineering guide for Jetpack Compose, Kotlin Coroutines, and MVI architecture.

---

## 1. The Three Phases Model & State Read Optimization

Jetpack Compose executes frames in three sequential phases: **Composition -> Layout -> Drawing**.
State reads in later phases bypass earlier phases. Deferring reads from Composition to Layout/Drawing completely eliminates recompositions for visual-only updates.

```kotlin
// ❌ BAD: Reads scrollState in Composition -> Recomposes every frame/pixel
Box(modifier = Modifier.offset(y = scrollState.value.dp))

// ✅ GOOD: Reads in Layout phase via lambda -> Skips Composition entirely
Box(modifier = Modifier.offset { IntOffset(0, scrollState.value) })

// ✅ GOOD: Reads in Drawing phase via graphicsLayer -> Skips Composition & Layout
Box(modifier = Modifier.graphicsLayer { translationY = scrollState.value.toFloat(); alpha = 0.9f })
```

---

## 2. Compose Compiler Stability & Smart Skipping

A Composable function can only be skipped if ALL its parameters are evaluated as **Stable** by the Compose Compiler.

### Stability Pitfalls & Fixes

| Issue | Root Cause | Production-Ready Fix |
| :--- | :--- | :--- |
| **Standard Collections (`List<T>`, `Set<T>`)** | Interfaces can be backed by mutable classes (e.g. `ArrayList`); compiler marks them Unstable | Use `kotlinx.collections.immutable.ImmutableList<T>` / `PersistentList<T>` or wrap in `@Immutable data class` |
| **External / Multi-Module Classes** | Classes from libraries or non-Compose modules lack stability metadata | Annotate UI State / DTOs with `@Immutable` / `@Stable` or configure `stability_config.conf` |
| **Lambdas with Captured Unstable Scope** | Creating inline non-memoized lambdas inside hot loops | Use method references (`viewModel::onIntent`) or `remember(key) { { ... } }` |
| **Primitive Boxing Overhead** | Using `mutableStateOf<Int>()` boxes primitive types | Use `mutableIntStateOf()`, `mutableFloatStateOf()`, `mutableLongStateOf()` |

---

## 3. Jetpack Compose Performance Checklist

| # | Pitfall / Issue | Production-Ready Solution |
|---|---|---|
| **1** | Unstable parameters in public composables | Use `ImmutableList<T>` and `@Immutable` data models |
| **2** | Broad state observation in parent composables | Collect once at Route level; pass narrow, granular props to child leaves |
| **3** | Anonymous lambda recreation in large lazy lists | Use `remember(item.id, callback)` or pass stable domain IDs |
| **4** | Heavy calculations inside Composable body | Move upstream to `ViewModel` / `Reducer` or wrap with `remember(keys)` |
| **5** | Redundant `derivedStateOf` wrapping cheap math | Use `derivedStateOf` ONLY when source state changes more frequently than output |
| **6** | `rememberSaveable` on large object graphs | Restrict `rememberSaveable` to small UI-local state (text input, selected tab) |
| **7** | Missing or index-based keys in `LazyColumn` | Always provide unique & stable domain ID: `key = { it.id }` |
| **8** | Nested infinite scrollable crash | Never place `LazyColumn` inside `Modifier.verticalScroll()`; combine DSL blocks |
| **9** | Flow collection without lifecycle awareness | Always use `collectAsStateWithLifecycle()` to pause collection in background |
| **10** | Direct State mutation in Composable body | Never mutate state during composition; trigger events in callbacks only |

---

## 4. Code Examples

### BAD vs. GOOD: Heavy Computation in Composable Body

```kotlin
// ❌ BAD: Calculates and sorts in Composable body on every recomposition
@Composable
fun TransactionHistory(transactions: List<Transaction>) {
    val formatter = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
    val sorted = transactions.filter { it.amount > 0 }.sortedByDescending { it.timestamp }
    LazyColumn {
        items(sorted) { tx -> Text("${tx.title}: ${formatter.format(Date(tx.timestamp))}") }
    }
}

// ✅ GOOD: Pre-calculated in ViewModel / Reducer; 100% stable input
@Composable
fun TransactionHistory(
    transactions: ImmutableList<TransactionUiModel>,
    modifier: Modifier = Modifier
) {
    LazyColumn(modifier = modifier) {
        items(transactions, key = { it.id }) { tx ->
            Text(text = "${tx.title}: ${tx.formattedDate}")
        }
    }
}
```

---

## 5. Compiler Metrics & Macrobenchmark

1. **Enable Compose Compiler Reports:**
   Configure `freeCompilerArgs` in `build.gradle.kts` to inspect stability reports (`reports/` and `metrics/`):
   ```kotlin
   freeCompilerArgs += listOf(
       "-P", "plugin:androidx.compose.compiler.plugins.kotlin:reportsDestination=$buildDir/compose_reports",
       "-P", "plugin:androidx.compose.compiler.plugins.kotlin:metricsDestination=$buildDir/compose_metrics"
   )
   ```
2. **Baseline Profiles (Android):**
   Pre-compile hot code paths using Jetpack Macrobenchmark to achieve instant cold start (< 150ms) and 120 FPS scrolling with zero dropped frames.
