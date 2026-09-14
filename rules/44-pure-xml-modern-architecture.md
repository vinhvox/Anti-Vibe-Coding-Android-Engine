# 44-pure-xml-modern-architecture.md

# Purpose

This document defines the strict engineering standards, lifecycle guardrails, and 120 FPS performance rules for building and maintaining **100% Pure XML Android Applications** (traditional Android Views, ViewBinding, and Fragments/Activities).

The goal is to ensure that 100% XML codebases achieve enterprise excellence:
- **Zero Leaked Fragment Views:** Strict ViewBinding lifecycle management.
- **Lifecycle-Aware Reactive State:** Safe coroutine flow collection using `repeatOnLifecycle(STARTED)`.
- **120 FPS List Scrolling:** Mandatory `ListAdapter` with background `DiffUtil.ItemCallback`.
- **Android 15+ Enforced Edge-to-Edge:** Flawless system bar and IME insets handling via `WindowInsetsCompat`.
- **Type-Safe Navigation:** Jetpack Navigation Component with SafeArgs (zero string bundle keys).
- **Material Design 3 Compliance:** Semantic attributes and DayNight theme tokens.

---

# 1. VIEWBINDING LIFECYCLE & MEMORY LEAK DEFENSE

In pure XML applications, ViewBinding is the mandatory view-access mechanism. Raw `findViewById()` and legacy Kotlin Synthetics are strictly FORBIDDEN.

### Rule 1.1: Fragment ViewBinding Nullification Pattern
Because a Fragment's view hierarchy has a shorter lifecycle than the Fragment instance (when retained in the backstack):
- **MANDATORY DECLARATION:**
  ```kotlin
  class FeatureFragment : Fragment(R.layout.fragment_feature) {
      private var _binding: FragmentFeatureBinding? = null
      private val binding get() = _binding!!

      override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
          super.onViewCreated(view, savedInstanceState)
          _binding = FragmentFeatureBinding.bind(view)
          setupUI()
          observeState()
      }

      override fun onDestroyView() {
          super.onDestroyView()
          _binding = null // ✅ MANDATORY: Releases the entire XML view tree immediately
      }
  }
  ```
- **REJECT IF:** ViewBinding is declared as an immutable `val binding` at the class level, or `_binding = null` is omitted inside `onDestroyView()`.

### Rule 1.2: Activity ViewBinding Pattern
In Activities, initialize ViewBinding before `setContentView()`:
```kotlin
class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupInsets()
    }
}
```

---

# 2. LIFECYCLE-AWARE REACTIVE FLOW COLLECTION

Presentation logic in 100% XML architectures must adhere to Unidirectional Data Flow (UDF). The `ViewModel` exposes an immutable `StateFlow<UiState>`.

### Rule 2.1: Mandatory `repeatOnLifecycle`
- Flow emissions MUST be collected inside `viewLifecycleOwner.lifecycleScope` guarded by `repeatOnLifecycle(Lifecycle.State.STARTED)`:
  ```kotlin
  private fun observeState() {
      viewLifecycleOwner.lifecycleScope.launch {
          viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
              viewModel.uiState.collect { state ->
                  renderUi(state)
              }
          }
      }
  }
  ```
- **REJECT IF:** `Flow` or `StateFlow` is collected directly inside `lifecycleScope.launch` without `repeatOnLifecycle`, which leaks background coroutines and processes emissions when views are invisible.

---

# 3. RECYCLERVIEW 120 FPS ENGINEERING: `LISTADAPTER` & `DIFFUTIL`

To guarantee 120 FPS scrolling performance without frame drops:

### Rule 3.1: Mandatory `ListAdapter` with Background `DiffUtil`
- All dynamic lists MUST extend `androidx.recyclerview.widget.ListAdapter<T, VH>` with a dedicated `DiffUtil.ItemCallback<T>`.
- `areItemsTheSame` MUST compare unique IDs (`oldItem.id == newItem.id`).
- `areContentsTheSame` MUST compare data equality (`oldItem == newItem`).
- **REJECT IF:** Using generic `RecyclerView.Adapter` with manual list mutation, or invoking `notifyDataSetChanged()`.

```kotlin
class TaskAdapter(
    private val onClick: (TaskItem) -> Unit
) : ListAdapter<TaskItem, TaskAdapter.ViewHolder>(TaskDiffCallback) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemTaskBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding, onClick)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    class ViewHolder(
        private val binding: ItemTaskBinding,
        private val onClick: (TaskItem) -> Unit
    ) : RecyclerView.ViewHolder(binding.root) {
        fun bind(item: TaskItem) {
            binding.tvTitle.text = item.title
            binding.root.setOnClickListener { onClick(item) }
        }
    }

    object TaskDiffCallback : DiffUtil.ItemCallback<TaskItem>() {
        override fun areItemsTheSame(oldItem: TaskItem, newItem: TaskItem) = oldItem.id == newItem.id
        override fun areContentsTheSame(oldItem: TaskItem, newItem: TaskItem) = oldItem == newItem
    }
}
```

### Rule 3.2: Performance Optimizations
- If item dimensions do not change dynamically: specify `binding.recyclerView.setHasFixedSize(true)`.
- When using nested horizontal lists or ViewPager2: share a singleton `RecyclerView.RecycledViewPool`.
- Prefer flat `ConstraintLayout` structures over deeply nested `LinearLayout` chains (depth > 3).

---

# 4. ANDROID 15+ ENFORCED EDGE-TO-EDGE IN XML

Starting with Android 15 (API 35), edge-to-edge display is enforced by the operating system. System navigation bars and status bars overlap XML layouts.

### Rule 4.1: Mandatory WindowInsets Handling
- In every Activity, invoke `enableEdgeToEdge()` before `setContentView()`.
- On root views of Activities and Fragments, consume window insets using `ViewCompat.setOnApplyWindowInsetsListener`:

```kotlin
ViewCompat.setOnApplyWindowInsetsListener(binding.root) { view, windowInsets ->
    val insets = windowInsets.getInsets(
        WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.ime()
    )
    view.updatePadding(
        top = insets.top,
        bottom = insets.bottom,
        left = insets.left,
        right = insets.right
    )
    windowInsets
}
```
- **REJECT IF:** Screens hardcode top/bottom margins to dodge system bars, or fail to handle IME (software keyboard) insets, causing inputs to be clipped.

---

# 5. NAVIGATION COMPONENT & SAFEARGS TYPE-SAFETY

Single-Activity architecture powered by Jetpack Navigation Component is mandatory for 100% XML apps:

### Rule 5.1: Zero String Bundle Keys
- Inter-destination navigation MUST use Gradle SafeArgs generated Directions (`XxxDirections.actionListToDetail(id)`).
- Destination argument extraction MUST use `navArgs()` delegate (`val args: XxxArgs by navArgs()`).
- **REJECT IF:** Arguments are bundled via raw string keys (`intent.putExtra("ID", ...)` or `bundle.putString("ID", ...)`).

---

# 6. MATERIAL DESIGN 3 THEME IN XML (MDC-ANDROID)

### Rule 6.1: Semantic Color Tokens
- Inherit from `Theme.Material3.DayNight.NoActionBar`.
- In XML layouts, use semantic theme attributes (`?attr/colorSurface`, `?attr/colorOnSurface`, `?attr/colorPrimary`, `?attr/colorSurfaceContainer`) instead of hardcoded colors (`@color/white`, `#FFFFFF`).
- Ensure all clickable views satisfy the 48dp accessibility touch target (`android:minWidth="48dp"`, `android:minHeight="48dp"`).

---

# 7. ENFORCEMENT & QUALITY GATES (CATEGORY E36)

Every code change in 100% Pure XML files must satisfy **CATEGORY E36** in `rules/21-enforcement-engine.md`:
* `E36.1`: XML ViewBinding Nullification & Lifecycle Gate
* `E36.2`: RecyclerView ListAdapter & DiffUtil Gate
* `E36.3`: XML Android 15 Enforced Edge-to-Edge WindowInsetsCompat Gate
* `E36.4`: Navigation Component SafeArgs Type-Safe Gate
