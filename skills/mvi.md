# MVI (Event/State/Effect)

MVI pattern: sealed Event contract processed by a single `onEvent()` entry point. Use when the project has chosen MVI.

For shared architecture concepts (state owner selection, domain layer, module rules), see [architecture.md](architecture.md).

## The 3 MVI Types

A non-trivial screen using MVI defines 3 types: `Event`, `State`, `Effect`.

### Event

User actions from UI: button clicks, field changes, lifecycle-start, retry, refresh, back press. Events are the **only** input from the UI into the screen state holder, processed by a single `onEvent()` function.

### State

Immutable data class that fully describes what the screen should render. Given the same state, the screen always looks the same. One state per screen, owned by the screen state holder via `StateFlow<State>`.

State should be **equality-friendly** — use `data class` with immutable collections. Computed properties (`val hasRequiredFields get() = name.isNotBlank()`) are acceptable for trivial derivations. Store canonical values; derive display values at the UI boundary.

### Effect

One-off UI commands that don't belong in state: navigate, show snackbar, trigger haptic, copy/share, open browser.

**Why effects are not state:** if you model "show snackbar" as a boolean in state, you need "consume" logic to flip it back — a classic source of bugs. Effects fire once and are gone.

## Event Naming

Events should be named from the **user's perspective** — what happened, not what should happen.

| Good | Bad |
|---|---|
| `OnSaveClick` | `SaveCategory` |
| `OnTitleChanged` | `UpdateTitle` |
| `OnRetryClick` | `RetryRequest` |
| `OnBackClick` | `NavigateBack` |

The event describes a user action; the ViewModel decides how to handle it.

## State Modeling

Use immutable `data class` with computed properties for derivations. For detailed guidance (forms, calculators, avoiding duplicated state), see [architecture.md](architecture.md) — State Modeling for Forms and Calculators.

## Effect Delivery

For Channel vs SharedFlow guidance, see [architecture.md](architecture.md) — Effect Delivery. Default: `Channel<Effect>(Channel.BUFFERED)` with `receiveAsFlow()`.

## Event Processing Flow

```text
UI gesture / lifecycle signal
    → Event dispatched via onEvent()
    → ViewModel processes the event in a when() block
    → Synchronous events: updateState { copy(...) }
    → Side effects: sendEffect(effect)
    → Async work: viewModelScope.launch { ... }
    → On async completion: updateState { copy(...) } + sendEffect(...)
```

**Key insight:** `onEvent()` is the single decision point. It decides what happens for each event — update state, send an effect, launch async work, or some combination. This keeps all event→reaction logic in one place.

## Screen State Holder Anatomy

A screen state holder using MVI has three responsibilities:

1. **State ownership** — holds `MutableStateFlow<State>`, exposes `StateFlow<State>`
2. **Effect delivery** — holds `Channel<Effect>` or the project's equivalent, exposes `Flow<Effect>`
3. **Event processing** — implements `onEvent()` to handle all events

State is updated via a thread-safe `update` function (e.g., `MutableStateFlow.update { it.copy(...) }` or a wrapper like `updateState { copy(...) }`). Effects are sent via `channel.trySend(effect)`.

## UI Rendering Boundary: The 3-Layer Pattern

To achieve 100% stable Studio `@Preview` rendering, clear separation of concerns, and full testability, UI rendering is structured in 3 distinct layers:

### 1. Stateful Route Composable (`*Route` / `*Router`)
- **Single Responsibility:** Orchestration and system boundary connection.
- Injects the screen state holder via Koin (`koinViewModel()`).
- Collects UI State with lifecycle awareness (`collectAsStateWithLifecycle()`).
- Collects one-off effects via `LaunchedEffect(viewModel.effect)`.
- Handles platform permissions (`rememberLauncherForActivityResult`).
- Manages system dialogs, bottom sheets, and navigation routing.
- Passes pure immutable `UiState` and `viewModel::onIntent` down to the Screen.
- Contains ZERO complex UI layout or canvas drawing.

### 2. Stateless Screen Composable (`*Screen` / `*Content`)
- **Single Responsibility:** Pure declarative UI rendering.
- Function signature: `(uiState: UiState, onIntent: (Intent) -> Unit, modifier: Modifier = Modifier)`.
- Has ZERO ViewModel references, ZERO Koin/DI calls, and ZERO Android Context leaks.
- Handles all UI state branches: `Loading`, `Success`, `Empty`, `Error`.

### 3. Mandatory Previews (`*ScreenPreview`)
- Must provide `@Preview` annotations for Light and Dark modes.
- Uses `PreviewParameterProvider` to supply mock UI states for instant visual debugging.

### Leaf Composables
- Render sub-state, emit specific granular callbacks, keep only tiny visual-local state.
- NEVER pass `ViewModel` or broad `onIntent` to reusable leaves — adapt to specific lambda callbacks (`onSelect: (Item) -> Unit`).

### Domain and Data Layer Boundaries

See [architecture.md](architecture.md) — Domain Layer and Where Logic Belongs.

## When MVI Is Appropriate

- Project already uses MVI with a base class or convention
- Screen has many user actions and you want them enumerated in one sealed type
- Team values explicit event contracts for debugging, analytics, or time-travel debugging
- You need exhaustive `when` handling for all UI actions
- Complex screens with interrelated state transitions

## Code Examples

### BAD: Business logic & ViewModel directly inside Screen

```kotlin
// ❌ BAD: Direct ViewModel injection breaks Compose @Preview and entangles business logic
@Composable
fun LoanCalculatorScreen(
    viewModel: LoanViewModel = koinViewModel() // BREAKS PREVIEW!
) {
    val uiState by viewModel.uiState.collectAsState()
    // Validation, permission, and direct business calls tangled inside UI
}
```

### GOOD: 3-Layer Router -> Screen -> Preview

```kotlin
// ✅ 1. ROUTE (Stateful Entrypoint)
@Composable
fun LoanCalculatorRoute(
    onNavigateBack: () -> Unit,
    viewModel: LoanViewModel = koinViewModel(),
    modifier: Modifier = Modifier
) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    LaunchedEffect(viewModel.effect) {
        viewModel.effect.collect { effect ->
            // handle navigation / toast effects
        }
    }

    LoanCalculatorScreen(
        uiState = uiState,
        onIntent = viewModel::onIntent,
        onNavigateBack = onNavigateBack,
        modifier = modifier
    )
}

// ✅ 2. SCREEN (100% Stateless UI)
@Composable
fun LoanCalculatorScreen(
    uiState: LoanUiState,
    onIntent: (LoanIntent) -> Unit,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxSize().background(AppTheme.colors.background)) {
        // Pure declarative UI matching Design System tokens
    }
}

// ✅ 3. PREVIEW (Instant Feedback in Studio)
@Preview(name = "Loan Calculator - Light", showBackground = true)
@Preview(name = "Loan Calculator - Dark", uiMode = Configuration.UI_MODE_NIGHT_YES)
@Composable
private fun LoanCalculatorScreenPreview() {
    AppTheme {
        LoanCalculatorScreen(
            uiState = LoanUiState(),
            onIntent = {},
            onNavigateBack = {}
        )
    }
}
```

### GOOD: MVI contract — Event, State, Effect

```kotlin
sealed interface CreateItemEvent {
    data class OnTitleChanged(val title: String) : CreateItemEvent
    data class OnAmountChanged(val amount: String) : CreateItemEvent
    data object OnSaveClick : CreateItemEvent
    data object OnBackClick : CreateItemEvent
}

data class CreateItemState(
    val title: String = "",
    val amount: String = "",
    val isSaving: Boolean = false,
    val errors: Map<String, String> = emptyMap()
) {
    val canSave: Boolean get() = title.isNotBlank() && amount.isNotBlank()
}

sealed interface CreateItemEffect {
    data object NavigateBack : CreateItemEffect
    data class ShowMessage(val text: String) : CreateItemEffect
}
```

### GOOD: ViewModel with onEvent

Full `save()` (validation + `viewModelScope.launch`): identical body to [mvvm.md](mvvm.md) — **GOOD: ViewModel with named functions**; here it is invoked from `onEvent` instead of public named functions.

```kotlin
class CreateItemViewModel(
    private val repository: ItemRepository,
) : ViewModel() {
    private val _state = MutableStateFlow(CreateItemState())
    val state: StateFlow<CreateItemState> = _state.asStateFlow()

    private val _effect = Channel<CreateItemEffect>(Channel.BUFFERED)
    val effect: Flow<CreateItemEffect> = _effect.receiveAsFlow()

    fun onEvent(event: CreateItemEvent) {
        when (event) {
            is CreateItemEvent.OnTitleChanged -> _state.update { it.copy(title = event.title, errors = it.errors - "title") }
            is CreateItemEvent.OnAmountChanged -> _state.update { it.copy(amount = event.amount, errors = it.errors - "amount") }
            CreateItemEvent.OnSaveClick -> save()
            CreateItemEvent.OnBackClick -> _effect.trySend(CreateItemEffect.NavigateBack)
        }
    }

    // save(): validate, set isSaving, launch coroutine, update state, trySend ShowMessage / NavigateBack on success or failure
    private fun save() { /* … */ }
}
```

### GOOD: Same pattern with a base class or interface

`class CreateItemViewModel(...) : ViewModel(), MviHost<CreateItemEvent, CreateItemState, CreateItemEffect>` — same `onEvent` / `save()` shape; `updateState` / `sendEffect` from the host. Full base-class pattern: [clean-code.md](clean-code.md), [architecture.md](architecture.md).

### GOOD: Route/Screen/Leaf split

Layering: [architecture.md](architecture.md) — **State Collection and Slicing**. Full Route + `CollectEffect` sample: [mvvm.md](mvvm.md) — Route/Screen/Leaf (swap named callbacks for `onEvent`).

```kotlin
@Composable
fun CreateItemRoute(vm: CreateItemViewModel = koinViewModel(), snackbar: SnackbarHostState, onBack: () -> Unit) {
    val state by vm.state.collectAsStateWithLifecycle()
    CollectEffect(vm.effect) { e -> when (e) {
        CreateItemEffect.NavigateBack -> onBack()
        is CreateItemEffect.ShowMessage -> snackbar.showSnackbar(e.text)
    }}
    CreateItemScreen(state, vm::onEvent)
}

@Composable
fun CreateItemScreen(state: CreateItemState, onEvent: (CreateItemEvent) -> Unit) {
    Column {
        OutlinedTextField(state.title, { onEvent(CreateItemEvent.OnTitleChanged(it)) })
        OutlinedTextField(state.amount, { onEvent(CreateItemEvent.OnAmountChanged(it)) })
        Button(onClick = { onEvent(CreateItemEvent.OnSaveClick) }, enabled = !state.isSaving && state.canSave) {
            Text(if (state.isSaving) "Saving..." else "Save")
        }
    }
}
```

### GOOD: Event model for form-heavy screens

```kotlin
enum class FormField { Area, MaterialRate, LaborRate, TaxPercent, Notes }

sealed interface FormEvent {
    data class FieldChanged(val field: FormField, val raw: String) : FormEvent
    data class IncludeWasteChanged(val enabled: Boolean) : FormEvent
    data object SubmitClicked : FormEvent
    data object RetryClicked : FormEvent
    data object ScreenShown : FormEvent
    data object ClearClicked : FormEvent
}
```

Pragmatic default for large forms: specific intent names for screen-level actions, generic `FieldChanged(field, raw)` only when many fields are structurally similar.
