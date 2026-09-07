# Compose Essentials

Foundational Compose patterns, compiler stability mechanics, and lifecycle safeguards that complement MVI architecture. Consult this when working with Compose APIs directly.

---

## 1. The Three Phases Model & Deferred State Reads

Every frame in Jetpack Compose executes in three distinct, sequential phases. Understanding which phase reads state prevents unnecessary recompositions:

1. **Composition Phase:** Executes `@Composable` functions, evaluates state reads, and constructs/updates the Slot Table tree. State reads here trigger a full recomposition of the enclosing scope.
2. **Layout Phase (Measure & Layout):** Measures sizes and determines coordinates (`measure` and `layout` blocks). Can read state without triggering composition.
3. **Drawing Phase:** Emits draw commands to the Canvas / GPU pipeline (`Canvas`, `drawBehind`, `graphicsLayer`). Reads here only repaint without recomposing or re-measuring.

```text
[ State Change ]
       │
       ├── Reads in Composition ──> Re-runs Composable function (HEAVY, drops FPS)
       ├── Reads in Layout      ──> Skips Composition, runs measure/place (FAST)
       └── Reads in Drawing     ──> Skips Composition & Layout, runs Canvas (FASTEST)
```

### Deferred State Reads Example

```kotlin
// ❌ BAD: Reads scrollState in Composition phase -> Recomposes Box & children every single pixel!
Box(
    modifier = Modifier
        .offset(y = scrollState.value.dp)
        .alpha(1f - (scrollState.value / 300f).coerceIn(0f, 1f))
)

// ✅ GOOD: Defers reads to Layout/Draw phases -> 100% skips Composition phase!
Box(
    modifier = Modifier
        .graphicsLayer {
            translationY = scrollState.value.toFloat()
            alpha = 1f - (scrollState.value / 300f).coerceIn(0f, 1f)
        }
)
```

---

## 2. Compose Compiler Stability & Smart Skipping

Compose Compiler classifies types into **Stable** or **Unstable**. A Composable can only be **Skipped** during recomposition if ALL its parameters are Stable.

### Collections & External Types Stability Rules

1. **Standard Kotlin Collections (`List<T>`, `Set<T>`, `Map<T>`):**
   Standard Kotlin collections are interfaces. Because implementations may be mutable (e.g. `ArrayList`), the Compose Compiler marks them as **Unstable**.
   - **Fix:** Use `kotlinx.collections.immutable.ImmutableList<T>` / `PersistentList<T>`, OR wrap in an `@Immutable` data class.

```kotlin
// ❌ BAD: Unstable List parameter -> Composable can NEVER be skipped!
@Composable
fun ServerList(items: List<VpnServer>, onSelect: (String) -> Unit)

// ✅ GOOD: ImmutableList guarantees stability and smart skipping
@Composable
fun ServerList(
    items: ImmutableList<VpnServer>,
    onSelect: (String) -> Unit,
    modifier: Modifier = Modifier
)
```

2. **External / Multi-Module Models:**
   Classes from non-Compose modules or Java libraries are considered Unstable by default.
   - Annotate all UI State models and UI DTOs with `@Immutable` or `@Stable`.

---

## 3. State Primitives & Snapshot Optimization

Use type-specific state holders to avoid boxing overhead:

```kotlin
val count = mutableIntStateOf(0)       // no boxing
val progress = mutableFloatStateOf(0f) // no boxing
val isReady = mutableStateOf(true)     // boolean
val name = mutableStateOf("Alice")     // general-purpose
```

### Golden Rule of `derivedStateOf`
Only use `derivedStateOf` when the source State changes **much more frequently** than the resulting output:

```kotlin
// ❌ BAD: Redundant derivedStateOf (first and last name change at same frequency as output)
val fullName by remember { derivedStateOf { "$firstName $lastName" } }

// ✅ GOOD: listState scrolls thousands of times, but boolean changes only when crossing index 0
val isScrollToTopVisible by remember {
    derivedStateOf { listState.firstVisibleItemIndex > 0 }
}
```

---

## 4. Side Effects & Stale Closure Prevention

| API | Purpose | Lifecycle Behavior |
| :--- | :--- | :--- |
| `LaunchedEffect(key)` | Launch coroutines tied to composition | Restarts when `key` changes; cancels on leave |
| `DisposableEffect(key)` | Resource registration & cleanup | Runs `onDispose` when `key` changes or leaves |
| `rememberUpdatedState` | Capture latest lambda in long-running coroutines | Prevents Stale Closures without restarting effect |
| `rememberCoroutineScope` | Launch coroutines from UI event handlers | Bound to calling composition lifecycle |
| `SideEffect` | Post-composition synchronization | Runs after EVERY successful composition |

### The Stale Closure Trap & `rememberUpdatedState`

When a `LaunchedEffect` coroutine runs across recompositions, referencing a parameter lambda directly captures the initial instance (stale closure).

```kotlin
// ❌ BAD: Captures stale onTimeout lambda if parent recomposes during delay
@Composable
fun TimerComponent(onTimeout: () -> Unit) {
    LaunchedEffect(Unit) {
        delay(3000)
        onTimeout() // Bug: Calls stale lambda instance!
    }
}

// ✅ GOOD: Always calls the freshest lambda instance
@Composable
fun TimerComponent(
    onTimeout: () -> Unit,
    modifier: Modifier = Modifier
) {
    val currentOnTimeout by rememberUpdatedState(onTimeout)

    LaunchedEffect(Unit) {
        delay(3000)
        currentOnTimeout() // Safe & 100% fresh!
    }
}
```

---

## 5. Lifecycle-Aware Flow Collection

Use `collectAsStateWithLifecycle()` from `androidx.lifecycle:lifecycle-runtime-compose` instead of `collectAsState()`.

```kotlin
// ❌ BAD: Leaks processing in background when app is minimized
val state by viewModel.uiState.collectAsState()

// ✅ GOOD: Automatically pauses collection when app drops below STARTED
val state by viewModel.uiState.collectAsStateWithLifecycle()
```

---

## 6. Modifier Ordering & Semantic Chaining

Modifiers apply from outer to inner (wrapping model):

```kotlin
// Case A: Ripple effect covers padding area (larger touch target)
Modifier
    .clickable { }
    .padding(16.dp)

// Case B: Ripple effect only covers content inside padding
Modifier
    .padding(16.dp)
    .clickable { }

// Case C: Corner clipping MUST precede background
Modifier
    .clip(RoundedCornerShape(8.dp))
    .background(AppTheme.colors.surface)
```

---

## 7. Architecture: Stateful Router -> Stateless Screen -> Mandatory Previews Pattern

To guarantee 100% stable `@Preview` rendering and clean separation of concerns, every Compose screen follows a strict 3-tier architecture:

```kotlin
// 1. STATEFUL ROUTER (Entry Point: DI, Lifecycle, Permissions, Dialogs, Effects)
@Composable
fun ServerRoute(
    onNavigateBack: () -> Unit,
    onNavigateToDetail: (String) -> Unit,
    viewModel: ServerViewModel = koinViewModel(),
    modifier: Modifier = Modifier
) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    val context = LocalContext.current

    // A. Permission Launcher (Hoisted to Router)
    val permissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        viewModel.onIntent(ServerIntent.OnPermissionResult(isGranted))
    }

    // B. One-off Side Effects Handling
    LaunchedEffect(viewModel.effect) {
        viewModel.effect.collect { effect ->
            when (effect) {
                is ServerEffect.NavigateToDetail -> onNavigateToDetail(effect.serverId)
                is ServerEffect.ShowToast -> Toast.makeText(context, effect.message, Toast.LENGTH_SHORT).show()
                is ServerEffect.RequestPermission -> {
                    permissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
                }
            }
        }
    }

    // C. Render Pure Stateless Screen
    ServerScreen(
        uiState = uiState,
        onIntent = viewModel::onIntent,
        onNavigateBack = onNavigateBack,
        modifier = modifier
    )

    // D. Dialogs / System Overlays (Controlled by Router & UiState)
    if (uiState.showConfirmDialog) {
        AppConfirmDialog(
            title = stringResource(R.string.confirm_title),
            message = stringResource(R.string.confirm_msg),
            onConfirm = { viewModel.onIntent(ServerIntent.ConfirmAction) },
            onDismiss = { viewModel.onIntent(ServerIntent.DismissDialog) }
        )
    }
}

// 2. STATELESS SCREEN (100% Pure Declarative UI - Zero ViewModel, Zero Koin)
@Composable
fun ServerScreen(
    uiState: ServerUiState,
    onIntent: (ServerIntent) -> Unit,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .background(AppTheme.colors.background)
    ) {
        when {
            uiState.isLoading -> {
                LoadingIndicator(modifier = Modifier.align(Alignment.Center))
            }
            uiState.error != null -> {
                ErrorView(
                    message = uiState.error,
                    onRetry = { onIntent(ServerIntent.Retry) },
                    modifier = Modifier.align(Alignment.Center)
                )
            }
            uiState.servers.isEmpty() -> {
                EmptyStateView(
                    message = stringResource(R.string.no_servers_found),
                    modifier = Modifier.align(Alignment.Center)
                )
            }
            else -> {
                ServerList(
                    items = uiState.servers,
                    selectedId = uiState.selectedId,
                    onSelect = { onIntent(ServerIntent.SelectServer(it)) },
                    modifier = Modifier.fillMaxSize()
                )
            }
        }
    }
}

// 3. MANDATORY PREVIEWS & PREVIEW PARAMETER PROVIDER
class ServerUiStatePreviewParameterProvider : PreviewParameterProvider<ServerUiState> {
    override val values: Sequence<ServerUiState> = sequenceOf(
        // Success state
        ServerUiState(
            isLoading = false,
            servers = persistentListOf(
                VpnServer(id = "1", country = "United States", city = "New York", ping = 35),
                VpnServer(id = "2", country = "Singapore", city = "Singapore", ping = 15)
            ),
            selectedId = "1"
        ),
        // Loading state
        ServerUiState(isLoading = true),
        // Empty state
        ServerUiState(isLoading = false, servers = persistentListOf()),
        // Error state
        ServerUiState(isLoading = false, error = "Network connection failed")
    )
}

@Preview(name = "Server Screen - Light Mode", showBackground = true)
@Preview(name = "Server Screen - Dark Mode", uiMode = Configuration.UI_MODE_NIGHT_YES)
@Composable
private fun ServerScreenPreview(
    @PreviewParameter(ServerUiStatePreviewParameterProvider::class) uiState: ServerUiState
) {
    AppTheme {
        ServerScreen(
            uiState = uiState,
            onIntent = {},
            onNavigateBack = {}
        )
    }
}

---

## 8. LayoutNode Lifecycle & Crash Prevention (`LayoutNode should be attached to an owner`)

### Root Cause Analysis
- **`LayoutNode`:** Internal node in Compose UI tree.
- **`Owner` (`AndroidComposeView`):** Bridge between Compose UI and the Android View/Window hierarchy.
- **Mechanism of Crash:** When a Composable is unmounted or detached (e.g., fast back navigation, dynamic `if/else`, fast list scrolling, or Fragment destruction), its `layoutNode.owner` becomes `null`. If an asynchronous layout/placement frame is triggered on that detached node (`placeAt()`), Compose invokes `requireOwner()` and throws:
  `Fatal Exception: java.lang.IllegalStateException: LayoutNode should be attached to an owner`.

### Prevention Strategies
1. **Thread Dispatcher Discipline:**
   Always perform `MutableState` writes and `StateFlow` updates on `Dispatchers.Main`. Multi-threaded state mutations during active layout passes corrupt the tree.
2. **Never Cache `Placeable` Instances:**
   In custom `Layout` or `Modifier.layout`, call `placeable.placeRelative()` strictly inside the `layout()` lambda of that immediate measure pass. Never store `Placeable` in `remember { }`.
3. **Explicit `ViewCompositionStrategy` for Interop:**
   When hosting `ComposeView` in XML/Fragments:
   ```kotlin
   composeView.setViewCompositionStrategy(
       ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed
   )
   ```
4. **Stable Keys in `LazyLayout`s:**
   Provide unique domain keys in `LazyColumn`/`LazyRow`/`Pager` to avoid abrupt subcomposition disposal races.

