# Anti-Patterns

Quick-reference table of cross-cutting patterns and Jetpack Compose pitfalls that hurt MVI Android / Compose Multiplatform codebases.

---

## 1. Jetpack Compose Anti-Patterns (Pitfalls & Violations)

| Compose Anti-Pattern | Why it is harmful | Production-Ready Solution | Root Cause / Reference |
| :--- | :--- | :--- | :--- |
| **Unstable Collections (`List<T>`, `Set<T>`)** | Standard `List` is an interface treated as Unstable by Compose Compiler -> 100% recomposition cascade on parent change | Use `ImmutableList<T>` (`kotlinx.collections.immutable`) or `@Immutable data class` wrapper | [compose-essentials.md](compose-essentials.md) |
| **Reading State in Composition Phase** | Reading fast-changing state (`scrollState.value`, offset) in Composable body recomposes whole function 60/120 times/sec | Defer reads to Layout/Draw phases via `Modifier.graphicsLayer { }` or `Modifier.offset { }` | [compose-essentials.md](compose-essentials.md) |
| **Stale Closures in Coroutines** | Long-running `LaunchedEffect` captures old lambda instance across recompositions | Wrap async callbacks/lambdas in `val currentCallback by rememberUpdatedState(callback)` | [compose-essentials.md](compose-essentials.md) |
| **Missing / Index Key in Lazy Layouts** | Omitting `key` or using `key = { index }` breaks item recycling, loses scroll state, breaks animations | Always pass unique & stable domain ID: `items(items, key = { it.id })` | [lists-grids.md](lists-grids.md) |
| **Infinite Nested Scrollables** | Placing `LazyColumn` inside `Column(Modifier.verticalScroll())` crashes with `IllegalStateException` (infinite height) | Combine into a single `LazyColumn` using multiple `item { }` / `items { }` blocks | [lists-grids.md](lists-grids.md) |
| **Direct State Mutation in UI Body** | Writing to `mutableStateOf` during Composition creates an infinite recomposition loop and freezes the UI / CPU | Only mutate state inside Event Handlers (`onClick`) or inside controlled `LaunchedEffect` | [compose-essentials.md](compose-essentials.md) |
| **Direct ViewModel in Screen** | Calling `koinViewModel()` or passing `ViewModel` directly inside `*Screen` composable crashes Studio `@Preview` 100% and couples UI to DI | Wrap with a Stateful `*Route` / `*Router` entrypoint; keep `*Screen` 100% Stateless (accept only `UiState` & lambdas) | [compose-essentials.md](compose-essentials.md) |
| **Missing Compose Previews** | Failing to write `@Preview` forces developers to redeploy whole APK to test small UI changes | Write mandatory `@Preview` (Light/Dark mode) with `PreviewParameterProvider` for all UI states | [compose-essentials.md](compose-essentials.md) |
| **ViewModel Passed to Leaf Composables** | Passing `ViewModel` into child molecules/atoms destroys reusability, testability, and breaks `@Preview` | Keep leaves 100% Stateless (receive immutable `UiState` + emit lambda events) | [architecture.md](architecture.md) |
| **Heavy Allocations in Composable Body** | Instantiating `SimpleDateFormat`, regex, or sorting lists in Composable body executes on every frame | Pre-calculate in `ViewModel` or wrap with `remember(keys) { ... }` | [performance.md](performance.md) |
| **Missing `onDispose` Cleanup** | Registering listeners/receivers in `DisposableEffect` without unregistering leaks memory | Always pair registration with unregistering inside `onDispose { ... }` | [compose-essentials.md](compose-essentials.md) |
| **`LayoutNode` Detached Placement Crash** | Layout pass calls `placeAt()` on an unmounted/detached Composable node (`owner == null`), causing `IllegalStateException` | Mutate state on `Dispatchers.Main`, never leak `Placeable`, and use `ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed` | [compose-essentials.md](compose-essentials.md) |
| **Hardcoded Design Tokens** | Writing raw `Color(0x...)`, `16.dp`, `14.sp` breaks Dark/Light mode and system consistency | Reference centralized `AppTheme.colors.*`, `AppSpacing.*`, `AppTypography.*` | [material-design.md](material-design.md) |

---

## 2. Cross-Cutting MVI & Architectural Anti-Patterns

| Anti-pattern | Why it is harmful | Better replacement | Detailed in |
|---|---|---|---|
| Business logic inside composables | forks source of truth, hurts testability, reruns during composition | move logic into ViewModel/domain services | [architecture.md](architecture.md) |
| Giant god-ViewModel | blast radius too large, slow reasoning, hard ownership | one ViewModel per screen or independent flow | [architecture.md](architecture.md) |
| Scattered `updateState`/`sendEffect` with no structure | state transitions hard to trace, mutations across callbacks | disciplined `onEvent()` as single entry point | [clean-code.md](clean-code.md) |
| Unstable state models (mutable collections, lambdas in state) | defeats Compose skipping, more recomposition | immutable data classes, immutable collections | [performance.md](performance.md) |
| Duplicated derived data (`total`, `formattedTotal`, `hasTotal` all stored) | bugs from drift, harder transitions | keep canonical value + derive via computed property | [architecture.md](architecture.md) |
| Broad state reads in parent composables | recomposition cascades to all children | slice state, pass only required props to each child | [performance.md](performance.md) |
| Mutable state passed deep into tree | hidden writes, unpredictable data flow | explicit props + callbacks | [compose-essentials.md](compose-essentials.md) |
| One-off events stored as consumable state (`showSnackbarOnce = true`) | event replay on config change, stale effects | separate `Effect` via `Channel` | [architecture.md](architecture.md) |
| No-op state emissions (copy state when nothing changed) | wasted recomposition cycles | guard unchanged values before updating | [performance.md](performance.md) |
| Full-screen loading wipes existing content | bad UX, layout jumps, lost user trust | keep old content + inline refresh indicator | [ui-ux.md](ui-ux.md) |
| ViewModel doing platform work directly (share, analytics, navigation) | breaks testability, platform coupling | emit effects, handle in Route composable | [architecture.md](architecture.md) |
| Animation state in ViewModel for no reason (`shakeCount`, `alpha`) | pollutes business state | local composable animation state | [animations.md](animations.md) |
| Poor lazy list keys (no key or index-based) | state jumps between rows, broken animations | stable key by domain ID | [lists-grids.md](lists-grids.md) |
| Complex Objects passed across Navigation Routes | causes `TransactionTooLargeException`, freezes stale data | pass only primitive IDs (`userId: String`) | [navigation.md](navigation.md) |

---

## 3. Concrete Code Comparisons (BAD vs. GOOD)

### 3.1 Unstable List vs. ImmutableList Smart Skipping

```kotlin
// ❌ BAD — List<User> is Unstable -> Recomposes every time parent recomposes
@Composable
fun UserList(items: List<User>, onUserClick: (String) -> Unit) {
    LazyColumn {
        items(items) { user -> UserRow(user, onUserClick) }
    }
}

// ✅ GOOD — ImmutableList is 100% Stable -> Skips recomposition when items don't change
@Composable
fun UserList(
    items: ImmutableList<User>,
    onUserClick: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    LazyColumn(modifier = modifier) {
        items(items, key = { it.id }) { user ->
            UserRow(user = user, onClick = onUserClick)
        }
    }
}
```

### 3.2 Reading State in Composition vs. Layout/Draw Phase

```kotlin
// ❌ BAD — Reads scrollState in Composition phase -> Recomposes Box on every pixel scrolled
@Composable
fun ParallaxHeader(scrollState: ScrollState) {
    Box(
        modifier = Modifier
            .offset(y = (scrollState.value * 0.5f).dp)
            .alpha(1f - (scrollState.value / 300f).coerceIn(0f, 1f))
    )
}

// ✅ GOOD — Reads scrollState inside graphicsLayer lambda -> Skips Composition, 120 FPS
@Composable
fun ParallaxHeader(scrollState: ScrollState, modifier: Modifier = Modifier) {
    Box(
        modifier = modifier.graphicsLayer {
            translationY = scrollState.value * 0.5f
            alpha = 1f - (scrollState.value / 300f).coerceIn(0f, 1f)
        }
    )
}
```

### 3.3 Stale Closure in LaunchedEffect

```kotlin
// ❌ BAD — Captures stale lambda if parent recomposes while delay is running
@Composable
fun AutoDismissAlert(onDismiss: () -> Unit) {
    LaunchedEffect(Unit) {
        delay(4000)
        onDismiss() // Stale closure bug!
    }
}

// ✅ GOOD — rememberUpdatedState ensures freshest lambda reference
@Composable
fun AutoDismissAlert(onDismiss: () -> Unit) {
    val currentOnDismiss by rememberUpdatedState(onDismiss)
    LaunchedEffect(Unit) {
        delay(4000)
        currentOnDismiss() // 100% safe
    }
}
```
