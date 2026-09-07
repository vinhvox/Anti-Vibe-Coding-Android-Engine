# 06-compose.md

# Purpose

This document defines the strict engineering standards and architectural rules for building declarative UI with Jetpack Compose.

The goal is to produce composable functions that are:

- **100% Stateless & Decoupled**
- **Predictable & Deterministic**
- **Lifecycle-Aware & Battery-Efficient**
- **Compiler-Optimized for Smart Skipping (60/120 FPS)**
- **Testable & Preview-Friendly**
- **Systemically Consistent with the Centralized Design System**

---

# Compose Philosophy & Phased Execution

Composable functions describe UI. They MUST NOT own business logic or trigger unmanaged side-effects.

UI is a pure function of State:
```text
State
  ↓
Composable (Stateless)
  ↓
UI
```

Never reverse this flow. UI emits pure `Intent`/`Event` objects up to the `ViewModel` / `Store`.

### The Three Phases Model & Deferred State Reads

Every frame in Jetpack Compose executes in three distinct, sequential phases:
1. **Composition Phase:** Evaluates Composable functions and builds the Slot Table tree.
2. **Layout Phase (Measure & Place):** Measures child constraints and determines screen coordinates.
3. **Drawing Phase:** Emits canvas draw commands to the graphics pipeline.

```text
[ State Change ]
       │
       ├── Reads in Composition ──> Re-runs entire Composable function (HEAVY)
       ├── Reads in Layout      ──> Skips Composition, runs measure/place (FAST)
       └── Reads in Drawing     ──> Skips Composition & Layout, runs Canvas (FASTEST)
```

**MANDATORY RULE (Deferred State Reads):**
High-frequency state changes (such as scroll offsets, timers, drag positions, and animations) MUST NEVER be read directly in the Composition Phase.
State reads MUST be deferred to the Layout or Drawing Phase using lambda-based modifiers:
- Use `Modifier.graphicsLayer { alpha = ...; translationY = ... }` instead of `Modifier.alpha()` or `Modifier.offset()`.
- Use `Modifier.offset { IntOffset(x, y) }` instead of `Modifier.offset(x.dp, y.dp)` with dynamic state.
- Use `Modifier.drawBehind { ... }` for dynamic background drawing.

---

# Single Responsibility & Component Granularity

Every Composable must have a single, well-defined responsibility.

```text
ScreenRoute (Stateful Entrypoint)
    ↓
HomeScreen (Stateless Screen Content)
    ↓
TopBar Molecule
    ↓
SearchInput Molecule
    ↓
ServerList Organism
    ↓
ServerCard Molecule
    ↓
StatusBadge Atom
```

- Prefer many small, focused composables (Atoms & Molecules) over large, monolithic functions.
- Any Composable exceeding 150 lines MUST be broken down into cohesive sub-components.

---

# Compose Compiler Stability & Smart Skipping

A Composable function can only be **Skipped** (bypassing execution when caller recomposes) if ALL of its arguments are evaluated as **Stable** by the Compose Compiler.

### Collections & External Types Stability Rules

1. **Standard Kotlin Collections (`List<T>`, `Set<T>`, `Map<T>`):**
   Standard Kotlin collections are interfaces. Because implementations may be mutable (e.g. `ArrayList`), the Compose Compiler marks them as **Unstable**.
   - **MANDATORY:** Public and reusable Composables MUST NOT accept raw `List<T>` parameters if skipping is required.
   - Use `kotlinx.collections.immutable.ImmutableList<T>` / `PersistentList<T>`, OR wrap the list in an `@Immutable` / `@Stable` data class.

```kotlin
// ❌ FORBIDDEN: Unstable List parameter forces 100% recomposition on every parent change
@Composable
fun ServerList(
    items: List<VpnServer>,
    onSelect: (String) -> Unit
)

// ✅ MANDATORY: ImmutableList guarantees Stable contract and Smart Skipping
@Composable
fun ServerList(
    items: ImmutableList<VpnServer>,
    onSelect: (String) -> Unit,
    modifier: Modifier = Modifier
)
```

2. **External / Multi-Module Data Models:**
   Classes from external libraries or non-Compose modules are treated as Unstable unless annotated with `@Immutable` or `@Stable`.
   - Annotate all UI State models and UI DTOs with `@Immutable` or `@Stable`.

---

# State Hoisting & Single Source of Truth (SSOT)

State must live in the highest appropriate owner (the `ViewModel` / Antigravity Store for business state, or the parent Composable for ephemeral UI state).

- **FORBIDDEN (Duplicate State):** Never maintain duplicate copies of state between a ViewModel and a local Composable `remember { mutableStateOf(...) }`.
- **FORBIDDEN (Direct State Mutation):** UI components must NEVER mutate State directly. UI emits immutable `Intent` / `Event` objects.

### Local UI State vs. Business State
Local state (`remember { mutableStateOf(...) }`) is strictly restricted to:
- Expanded / Collapsed accordions
- Dialog / BottomSheet visibility
- Local animation / drag gesture progress
- Focus / Scroll state

All data, loading flags, network states, and business logic MUST reside in the `ViewModel`.

---

# Lifecycle-Aware State & Effect Collection

### 1. `collectAsStateWithLifecycle()` is Mandatory
Always collect `StateFlow` using `collectAsStateWithLifecycle()` from `androidx.lifecycle:lifecycle-runtime-compose`.
- **FORBIDDEN:** Using `collectAsState()` for screen-level UI state. `collectAsState()` does not pause when the app is in the background, causing continuous processing, GPS/network leaks, and battery drain.

```kotlin
// ❌ FORBIDDEN: Leaks background work and ignores Android Lifecycle
val uiState by viewModel.uiState.collectAsState()

// ✅ MANDATORY: Automatically stops collection when Lifecycle drops below STARTED
val uiState by viewModel.uiState.collectAsStateWithLifecycle()
```

---

# Side-Effects Guardrails & Stale Closure Prevention

Choose the exact side-effect API for each use case:

| Purpose | Correct API | Constraints |
| :--- | :--- | :--- |
| Suspend work on Enter / Key change | `LaunchedEffect(key1, ...)` | Keys must be stable; never pass changing lambdas as keys |
| Resource registration & cleanup | `DisposableEffect(key1, ...)` | Must provide non-empty `onDispose { ... }` cleanup block |
| Event callback inside Coroutine | `rememberUpdatedState(callback)` | Mandatory for capturing latest lambda in long-running effects |
| User interaction async trigger | `rememberCoroutineScope()` | Only for UI-local animations / snackbars; not business logic |
| Execute after every composition | `SideEffect { ... }` | Use sparingly for stateless synchronization (e.g. analytics) |

### The Stale Closure Trap & `rememberUpdatedState`

When a `LaunchedEffect` or long-running coroutine runs across recompositions, referencing a parameter lambda directly captures the initial instance (stale closure).
- **MANDATORY:** Always wrap external callbacks and lambdas with `rememberUpdatedState` inside long-running effects.

```kotlin
// ❌ FORBIDDEN: Captures stale onTimeout lambda if parent recomposes during delay
@Composable
fun TimerEffect(onTimeout: () -> Unit) {
    LaunchedEffect(Unit) {
        delay(3000)
        onTimeout() // Stale closure bug!
    }
}

// ✅ MANDATORY: Always accesses the freshest lambda instance
@Composable
fun TimerEffect(onTimeout: () -> Unit) {
    val currentOnTimeout by rememberUpdatedState(onTimeout)
    LaunchedEffect(Unit) {
        delay(3000)
        currentOnTimeout() // Safe & fresh
    }
}
```

---

# Lazy Layouts & List Performance (`LazyColumn` / `LazyRow` / `LazyGrid`)

1. **Mandatory Stable Keys:**
   Every `items()` and `itemsIndexed()` call in a Lazy layout MUST supply a stable, unique `key = { item.id }`.
   - **FORBIDDEN:** Omitting `key` or using list index `key = { index }`.
   - **Reason:** Missing keys break item recycling, destroy scroll state preservation, cause full-list recompositions on insert/delete, and corrupt `Modifier.animateItemPlacement()`.

```kotlin
// ❌ FORBIDDEN: No key causes full list recomposition and broken animations
LazyColumn {
    items(servers) { server -> ServerRow(server) }
}

// ✅ MANDATORY: Unique and stable domain identifier as key
LazyColumn {
    items(
        items = servers,
        key = { it.id },
        contentType = { it.itemType }
    ) { server ->
        ServerRow(server = server)
    }
}
```

2. **FORBIDDEN: Nested Infinite Scrollables:**
   Never place a `LazyColumn` or `LazyRow` inside a scrollable container with infinite height (e.g. `Column(Modifier.verticalScroll())`). This causes `IllegalStateException: Vertically scrollable component was measured with an infinity maximum height constraints`.
   - Combine multiple item blocks into a single `LazyColumn` using `item { }` and `items { }`.

3. **Zero Heavy Calculations in Items:**
   Never format dates, sort collections, or allocate heavy objects inside item composables. Pre-calculate all formatted strings in the `ViewModel` / `UiState`.

---

# LayoutNode Lifecycle & Attachment Safety (Crash Prevention)

To prevent the fatal crash `IllegalStateException: LayoutNode should be attached to an owner` (at `MeasurePassDelegate.placeOuterCoordinator` / `placeAt`):

1. **Main Thread State Mutations Mandatory:**
   - ALL `MutableState` writes and `StateFlow` updates consumed by UI MUST execute on `Dispatchers.Main`.
   - **FORBIDDEN:** Mutating UI state directly from `Dispatchers.IO`, background coroutines, or asynchronous hardware/sensor callbacks. Thread hopping during a layout pass corrupts the LayoutNode hierarchy.

2. **No Placeable Leaks across Measure Passes:**
   - In custom `Layout` or `Modifier.layout`, `placeable.placeRelative()` or `placeable.placeAt()` MUST be invoked ONLY within the `layout(width, height) { ... }` block of that exact same measure pass.
   - **FORBIDDEN:** Caching or persisting `Placeable` or `Measurable` instances inside `remember { }` or class fields across recompositions.

3. **Mandatory ViewCompositionStrategy in AndroidView / Fragment Interop:**
   - When embedding `ComposeView` inside XML layouts or Android `Fragment`s:
     - Use `ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed` for Fragments.
     - Use `ViewCompositionStrategy.DisposeOnDetachedFromWindowOrReleasedFromPool` for RecyclerView items.
   - **FORBIDDEN:** Leaving default composition strategy in Fragments, which causes composition to outlive the View lifecycle and attempt layout on a detached `AndroidComposeView`.

4. **Stable Keys in Dynamic SubcomposeLayout / LazyLayouts:**
   - Always supply stable domain keys to prevent abrupt node detachment during fast scrolling or list mutations.

---

# Architecture: Stateful Router -> Stateless Screen -> Mandatory Previews Pattern

Every screen in the application MUST be strictly separated into a 3-layer architecture:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        Navigation 3 Entrypoint                         │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│               1. STATEFUL ROUTER (*Route / *Router)                     │
│  - Injects ViewModel via Koin (`koinViewModel()`)                      │
│  - Collects UI State via `collectAsStateWithLifecycle()`               │
│  - Collects One-off Effects via `LaunchedEffect(viewModel.effect)`     │
│  - Handles Permissions: `rememberLauncherForActivityResult(...)`        │
│  - Manages System Dialogs, Bottom Sheets & Navigation Triggers         │
│  - ZERO complex layout/drawing code                                    │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
               Passes pure UiState  │  Dispatches pure UiIntent
                 & Lambdas down     │  upwards (`viewModel::onIntent`)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                2. STATELESS SCREEN (*Screen / *Content)                │
│  - 100% Pure Declarative Composable (Stateless Function of State)      │
│  - Standard Parameters: `(uiState, onIntent, onNavigateBack, modifier)`│
│  - ZERO ViewModel references, ZERO Koin/DI calls, ZERO Context leaks   │
│  - Renders all UI states: Loading, Success, Empty, Error               │
└───────────────────────────────────▲────────────────────────────────────┘
                                    │
                                    │ Renders mock UiState offline
                                    │
┌───────────────────────────────────┴────────────────────────────────────┐
│               3. MANDATORY PREVIEWS (*ScreenPreview)                   │
│  - @Preview(name = "Light Mode", showBackground = true)                │
│  - @Preview(name = "Dark Mode", uiMode = UI_MODE_NIGHT_YES)           │
│  - Uses @PreviewParameter(XxxPreviewParameterProvider::class)          │
│  - 100% Offline, Zero Crash, Instant UI Feedback in Studio             │
└────────────────────────────────────────────────────────────────────────┘
```

### Reference Implementation

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

    // A. Smart Permission Controller (Unified Runtime & Special Permissions + Resume Auto-Action)
    val permissionController = rememberPermissionController(
        onPermissionGranted = { permission ->
            viewModel.onIntent(ServerIntent.OnPermissionGranted(permission))
        }
    )

    // B. One-off Effects Handling (Navigation, Toast, System Actions)
    LaunchedEffect(viewModel.effect) {
        viewModel.effect.collect { effect ->
            when (effect) {
                is ServerEffect.NavigateToDetail -> onNavigateToDetail(effect.serverId)
                is ServerEffect.ShowToast -> Toast.makeText(context, effect.message, Toast.LENGTH_SHORT).show()
                is ServerEffect.RequestLocationPermission -> {
                    permissionController.request(AppPermission.Location)
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

    // D. Dialogs / System Modal Overlays controlled by Router & UiState
    if (uiState.showConfirmDialog) {
        AppConfirmDialog(
            title = stringResource(R.string.confirm_title),
            message = stringResource(R.string.confirm_msg),
            onConfirm = { viewModel.onIntent(ServerIntent.ConfirmAction) },
            onDismiss = { viewModel.onIntent(ServerIntent.DismissDialog) }
        )
    }

    // E. Automated Permission Dialog Host (Rationale & Settings Redirect)
    PermissionDialogHost(controller = permissionController)
}

// 2. STATELESS SCREEN (Pure Declarative UI - 100% Decoupled from ViewModel/DI)
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
```

---

# Modifier Chaining & Layout Insets Rules

1. **Modifier Parameter Standard:**
   Every public Composable function MUST accept a `modifier: Modifier = Modifier` parameter as its first optional parameter and apply it to the root layout node.

2. **Chaining Order is Semantic:**
   Modifiers apply from outer to inner. Understand the ordering semantics:
   - `Modifier.clickable { }.padding(16.dp)`: Ripple covers padding area (larger touch target).
   - `Modifier.padding(16.dp).clickable { }`: Ripple only covers content inside padding.
   - `Modifier.clip(shape).background(color)`: Clips background to shape. (Reverse will produce square corners).

3. **WindowInsets & Edge-to-Edge Compliance:**
   When targeting Android 15+ Edge-to-Edge:
   - Always consume `WindowInsets` or apply `paddingValues` from layout containers.
   - Never allow interactive UI to be submerged under the Status Bar, Display Cutouts, or Navigation Bar.

---

# Anti-Patterns & Prohibited Practices

- ❌ **NO ViewModel in Child Composables:** Never pass `ViewModel` instances to Molecules, Atoms, or list items.
- ❌ **NO Direct State Mutation in UI:** UI only emits events.
- ❌ **NO Missing Keys in Lazy Layouts:** Every `items()` call must have `key = { it.id }`.
- ❌ **NO Raw `collectAsState()`:** Always use `collectAsStateWithLifecycle()`.
- ❌ **NO Heavy Calculations in Composition:** No date formatting, regex, or sorting inside `@Composable`.
- ❌ **NO Unchecked Stale Closures:** Always use `rememberUpdatedState` for async callbacks in long-running effects.
- ❌ **NO Hardcoded Design Tokens:** All colors, typography, shapes, and spacings must reference `AppTheme` / `AppSpacing`.
- ❌ **NO Infinite Nested Scrollables:** Never put `LazyColumn` inside `Modifier.verticalScroll()`.
- ❌ **NO Missing Previews:** All Stateless screens and components MUST provide `@Preview` functions.