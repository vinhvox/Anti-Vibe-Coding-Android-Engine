# 43-xml-compose-interoperability.md

# Purpose

This document defines the strict architectural rules, lifecycle guardrails, and memory leak defense standards for building and maintaining hybrid Android applications that utilize both **imperative XML Views (with ViewBinding)** and **declarative Jetpack Compose**.

The goal is to ensure that hybrid interoperability is:
- **100% Leak-Free:** Zero ViewBinding leaks in Fragments and zero unmanaged Compose runtimes.
- **Lifecycle-Synchronized:** Perfect alignment between Fragment View lifecycles, RecyclerView recycling pools, and Compose Composition trees.
- **Architecturally Unified:** Single Source of Truth (SSOT), shared `BaseViewModel` with Unidirectional Data Flow (UDF), and consistent UI states across both rendering paradigms.
- **Visually Cohesive:** Shared design tokens, synchronized typography, and seamless Light/Dark mode transitions between XML styles and Compose themes.

---

# 1. COMPOSE IN XML (`ComposeView`) LIFECYCLE MANAGEMENT

When embedding Jetpack Compose into XML layouts (Fragments or RecyclerViews) using `<androidx.compose.ui.platform.ComposeView>`:

### Rule 1.1: Mandatory Fragment View Lifecycle Strategy
By default, `ComposeView` uses `ViewCompositionStrategy.DisposeOnDetachedFromWindow`. In a Fragment, when the user navigates away, the Fragment View is destroyed (`onDestroyView()`), but the Fragment instance remains alive in the backstack. The default strategy fails to properly dispose the composition or causes premature disposal on transient detachments.
- **MANDATORY RULE:** Every `ComposeView` inside a `Fragment` MUST explicitly set:
  `composeView.setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)`
- **LOCATION:** Must be invoked inside `onCreateView()` or `onViewCreated()` immediately before calling `setContent {}`.

```kotlin
// ✅ MANDATORY: Proper ComposeView Lifecycle Strategy in Fragment
override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
): View {
    _binding = FragmentFeatureBinding.inflate(inflater, container, false)
    
    binding.composeView.apply {
        setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
        setContent {
            AppTheme {
                FeatureScreen(viewModel = viewModel)
            }
        }
    }
    return binding.root
}
```

### Rule 1.2: RecyclerView ViewHolder Lifecycle Strategy
When a `ComposeView` is embedded inside a `RecyclerView.ViewHolder`:
- **MANDATORY RULE:** Use `ViewCompositionStrategy.DisposeOnDetachedFromWindowOrReleasedFromPool` (or `DisposeOnViewTreeLifecycleDestroyed`).
- This allows Compose to properly tear down or re-attach compositions as views cycle in and out of the `RecyclerView.RecycledViewPool`.

---

# 2. XML IN COMPOSE (`AndroidView`) LIFECYCLE & CLEANUP

When embedding imperative Android Views (such as AdMob `AdView`, Google Maps `MapView`, Media3/ExoPlayer `PlayerView`, CameraX `PreviewView`, or WebViews) into Jetpack Compose:

### Rule 2.1: Separation of `factory` and `update`
- **`factory: (Context) -> View`:** Runs **exactly once** when the node enters composition. ONLY view instantiation and non-varying one-time setup belong here. Heavy state calculations or dynamic properties MUST NOT be passed directly inside `factory`.
- **`update: (View) -> Unit`:** Runs on initial attach AND on every subsequent recomposition when dependent State variables change. Set dynamic properties and trigger view updates here without recreating the View.

### Rule 2.2: Mandatory `onRelease` Resource Cleanup
Every hardware-accelerated, media-playing, or network-streaming View embedded via `AndroidView` MUST provide an explicit `onRelease` block (or be wrapped in a `DisposableEffect`) to destroy and release hardware resources when leaving the screen:

```kotlin
// ✅ MANDATORY: Complete AndroidView Lifecycle & onRelease Cleanup
@Composable
fun HybridAdView(
    adUnitId: String,
    modifier: Modifier = Modifier
) {
    AndroidView(
        modifier = modifier,
        factory = { context ->
            AdView(context).apply {
                setAdSize(AdSize.BANNER)
                this.adUnitId = adUnitId
                loadAd(AdRequest.Builder().build())
            }
        },
        update = { adView ->
            // Update dynamic parameters if needed
        },
        onRelease = { adView ->
            // BẮT BUỘC: Hủy view triệt để để chống rò rỉ bộ nhớ
            adView.destroy()
        }
    )
}
```

---

# 3. VIEWBINDING LIFECYCLE & MEMORY LEAK DEFENSE

In imperative XML Fragments, ViewBinding references MUST NOT outlive the Fragment's view hierarchy:

### Rule 3.1: Strict Nullification Pattern
- Declare: `private var _binding: FragmentXxxBinding? = null`
- Expose: `private val binding get() = _binding!!`
- **MANDATORY:** Inside `onDestroyView()`, assign `_binding = null` before calling `super.onDestroyView()`.
- **FORBIDDEN:** Storing ViewBinding as a non-nullable `val` or failing to nullify it in `onDestroyView()`, which permanently leaks the entire XML View tree while the Fragment is in the backstack.

```kotlin
// ✅ MANDATORY: Safe Fragment ViewBinding Pattern
class ExampleFragment : Fragment(R.layout.fragment_example) {
    private var _binding: FragmentExampleBinding? = null
    private val binding get() = _binding!!

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        _binding = FragmentExampleBinding.bind(view)
        // Setup UI
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null // Zero Leaked Fragment Views
    }
}
```

---

# 4. SHARED ARCHITECTURE & UNIDIRECTIONAL DATA FLOW (UDF)

A single business feature MUST have exactly ONE ViewModel, regardless of whether its UI is rendered in XML, Compose, or a mixture of both:

### Rule 4.1: Unified StateFlow Contract
- The `BaseViewModel<State, Intent, Effect>` exposes an immutable `StateFlow<UiState>`.
- **In Compose:** Collected via `val state by viewModel.uiState.collectAsStateWithLifecycle()`.
- **In XML Fragments:** Collected inside `viewLifecycleOwner.lifecycleScope.launch { viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) { ... } }`.
- **FORBIDDEN:** Collecting Flow using raw `lifecycleScope.launch` in Fragments without `repeatOnLifecycle`, which wastes CPU and leaks UI events while in the background.

```kotlin
// ✅ MANDATORY: Lifecycle-aware Flow Collection in XML Fragment
override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    viewLifecycleOwner.lifecycleScope.launch {
        viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
            viewModel.uiState.collect { state ->
                renderUiState(state)
            }
        }
    }
}
```

---

# 5. DESIGN SYSTEM INTEROPERABILITY (THEME BRIDGE)

XML Styles and Compose Material 3 Themes must look and behave identically:

1. **Tokens SSOT:** All color primitives must be defined in `res/values/colors.xml`.
2. **XML Theme:** `res/values/themes.xml` inherits from `Theme.Material3.DayNight.NoActionBar` and references color tokens.
3. **Compose Theme:** `AppTheme` maps its color scheme to the same token values, ensuring that screens transition smoothly between XML and Compose without color jumping or typography shifts.

---

# 6. ENFORCEMENT & QUALITY GATES (CATEGORY E35)

Every code change touching hybrid XML/Compose files must satisfy **CATEGORY E35** in `rules/21-enforcement-engine.md`:
* `E35.1`: `ComposeView` Lifecycle Disposal Gate (`DisposeOnViewTreeLifecycleDestroyed`)
* `E35.2`: ViewBinding Nullification Gate (`_binding = null` in `onDestroyView()`)
* `E35.3`: `AndroidView` Lifecycle & `onRelease` Resource Cleanup Gate
* `E35.4`: Shared UDF `repeatOnLifecycle` XML Gate
