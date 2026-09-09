# 21-enforcement-engine.md

# Centralized Enforcement Engine

## Purpose

This document is the **single source of truth** for all automated code quality checks.

Every rule file in this project defines WHAT is required. This file defines HOW violations are detected and WHAT happens when they are found.

Before reporting ANY task as complete, the AI MUST run all applicable enforcement checks from this file.

---

# Related Files

- Rules: ALL files `00-20` in `/rules/`
- Workflow: `06-code-review.md`, `07-testing-validation.md`
- Brain: `08-reflection-engine.md`
- Memory: `06-user-preference-memory.md` (Active User Preferences)

---

# Enforcement Priority

This enforcement engine has the **same priority** as build verification (`./gradlew compileDebugKotlin`).

No task may be reported as complete until ALL applicable checks pass with ZERO violations.

---

# ENFORCEMENT CATEGORIES

## E1: Design System (refs: `rules/05-design-system.md`)

### E1.1: No Hardcoded Colors
- **Scan:** `Color(0x` pattern inside `presentation/` layer
- **Reject if:** Any match found
- **Fix:** Replace with `AppTheme.colors.*` token. If no token exists, create one in `core/ui/theme/` FIRST.
- **Exemption:** ONLY inside `core/ui/theme/` definition files

### E1.2: No Hardcoded Dimensions  
- **Scan:** Raw `.dp` values in `padding()`, `size()`, `RoundedCornerShape()`, `Spacer()`, `height()`, `width()`
- **Reject if:** Values not from `AppSpacing.*`, `AppShapes.*`, or `AppDimensions.*`
- **Fix:** Map to spacing/shape tokens. Create tokens if needed.
- **Exemption:** ONLY inside `core/ui/theme/` definition files

### E1.3: No Hardcoded Strings
- **Scan:** `Text("` or `text = "` inside Composable functions
- **Reject if:** Any user-facing hardcoded string found
- **Fix:** Move to `strings.xml` (English) and `values-vi/strings.xml` (Vietnamese). Use `stringResource()`.
- **Exemption:** Log messages, debug strings

### E1.4: No Raw Text() Composables
- **Scan:** `Text(` with inline `fontSize`, `fontWeight`, `color` parameters
- **Reject if:** Found outside Design System component definitions
- **Fix:** Use `Heading1`, `Heading2`, `Heading3`, `Subtitle1`, `Subtitle2`, `Body1`, `Body2`, `Caption`, or `AppText`

### E1.5: Dark Theme Compatibility
- **Scan:** `Color.White`, `Color.Black`, `Color.Red`, `Color.Blue`, `Color.Green`, `Color.Gray`
- **Reject if:** Found inside presentation layer
- **Fix:** Replace with `AppTheme.colors.*` equivalents

---

## E2: Architecture — ViewModel (refs: `rules/07-viewmodel.md`)

### E2.1: BaseViewModel Inheritance
- **Scan:** `class *ViewModel` declarations
- **Reject if:** Extends `ViewModel()` or `AndroidViewModel()` directly
- **Fix:** Migrate to `BaseViewModel<State, Intent, Effect>`
- **Exemption:** NONE — ZERO EXCEPTIONS

### E2.2: safeLaunch Enforcement
- **Scan:** `viewModelScope.launch` inside any ViewModel file
- **Reject if:** Any match found
- **Fix:** Replace with `launch {}` from `BaseViewModel`
- **Exemption:** NONE — ZERO EXCEPTIONS

### E2.3: Dead Code Prevention
- **Scan:** Private methods in ViewModel not referenced by `onIntent()`
- **Reject if:** Unreferenced private method found
- **Fix:** Delete the dead method immediately

### E2.4: Intent Exhaustiveness
- **Scan:** `when (intent)` blocks
- **Reject if:** `else ->` catch-all is used
- **Fix:** Handle each sealed subclass explicitly

---

## E3: Architecture — Clean Architecture (refs: `rules/02-architecture.md`)

### E3.1: Dependency Direction
- **Scan:** Import statements in Domain layer files
- **Reject if:** Domain imports from `presentation/`, `data/`, `android.*` (except `android.os.Parcelable`)
- **Fix:** Move the dependency to the correct layer

### E3.2: No Fake Data in Production
- **Scan:** `delay(` followed by hardcoded data in Repository/UseCase files
- **Reject if:** `delay()` used to simulate work + hardcoded `listOf()` return values
- **Fix:** Implement real data source. If not ready, mark with `⚠️ STUB` and inform user.

### E3.3: Repository Isolation
- **Scan:** ViewModel files for direct Room/Ktor/File access
- **Reject if:** ViewModel imports `dao`, `HttpClient`, `File`, `java.io`
- **Fix:** Route through UseCase → Repository

---

## E4: Compose (refs: `rules/06-compose.md`)

### E4.1: No Scaffold
- **Scan:** `Scaffold(` in screen composables
- **Reject if:** Found in any screen (root `MyAppTheme` already wraps content)
- **Fix:** Use `Box(modifier = Modifier.fillMaxSize().background(AppTheme.colors.background))`

### E4.2: Stability Annotations
- **Scan:** Data classes passed to Composable parameters
- **Warn if:** External models (from network/DB) lack `@Stable` or `@Immutable`
- **Fix:** Add annotation or wrap in stable wrapper

### E4.3: Lambda Memoization
- **Scan:** Lambdas passed to child Composables
- **Warn if:** Inline lambda definitions not wrapped in `remember` or using method references
- **Fix:** Memoize with `remember { }` or use method references

---

## E5: Coroutines (refs: `rules/08-coroutines.md`)

### E5.1: No Unscoped Coroutines
- **Scan:** `CoroutineScope(` created manually outside ViewModel
- **Reject if:** Found without proper lifecycle management
- **Fix:** Use `viewModelScope`, or tie to Android lifecycle component

### E5.2: Dispatcher Enforcement
- **Scan:** IO operations (File, Network, DB) on `Dispatchers.Main`
- **Reject if:** Heavy operations on main thread
- **Fix:** Use `Dispatchers.IO` or `withContext(Dispatchers.IO)`

---

## E6: Navigation (refs: `rules/11-navigation.md`)

### E6.1: Type-Safe Destinations Only
- **Scan:** String-based route patterns, `"route/"` concatenation
- **Reject if:** Any string route construction found
- **Fix:** Use `sealed interface Screen : NavKey` typed destinations

### E6.2: No String Route Parsing
- **Scan:** `NavBackStackEntry.arguments?.getString(` or URI path parsing
- **Reject if:** Manual argument extraction from strings
- **Fix:** Use typed destination properties

---

## E7: Error Handling (refs: `rules/13-error-handling.md`)

### E7.1: No Raw Exception Propagation
- **Scan:** `throw Exception(`, `throw RuntimeException(`
- **Reject if:** Raw exceptions thrown in Domain/Data layers
- **Fix:** Use typed error classes (DomainError, DataError)

### E7.2: Catch Specificity
- **Scan:** `catch (e: Exception)` blocks
- **Warn if:** Generic Exception caught instead of specific types
- **Fix:** Catch specific exceptions (IOException, SerializationException, etc.)

---

## E8: Security (refs: `rules/17-security.md`)

### E8.1: No Hardcoded Secrets
- **Scan:** API keys, passwords, tokens in source code
- **Reject if:** Any hardcoded credential string found
- **Fix:** Use BuildConfig, encrypted SharedPreferences, or secrets.properties

### E8.2: Zip Slip Protection
- **Scan:** Archive extraction code
- **Reject if:** Extracted file paths not validated with `canonicalPath.startsWith()`
- **Fix:** Add canonical path check before writing extracted files

---

## E9: Testing (refs: `rules/20-testing.md`)

### E9.1: No ExampleUnitTest-Only
- **Warn if:** Only auto-generated test files exist
- **Fix:** Add at minimum: 1 ViewModel test, 1 UseCase test, 1 Repository test per feature

### E9.2: Build Verification
- **Scan:** Run `./gradlew compileDebugKotlin` before completion
- **Reject if:** BUILD FAILED
- **Fix:** Fix all compilation errors before reporting done

### E9.3: Test Verification
- **Scan:** Run `./gradlew test` before completion
- **Reject if:** Any test failure
- **Fix:** Fix failing tests before reporting done

---

## E10: Dependency Injection (refs: `rules/12-dependency-injection.md`)

### E10.1: Constructor Injection Only
- **Scan:** Manual instantiation inside ViewModels (`= Repository()`)
- **Reject if:** Dependencies created manually instead of injected
- **Fix:** Inject via constructor, register in Koin module

### E10.2: Binding Completeness
- **Scan:** New ViewModel/Repository/UseCase created
- **Reject if:** Not registered in `AppModule.kt` or `RepositoryModule.kt`
- **Fix:** Add Koin binding before compilation

---

## E11: SOLID Principles (refs: `rules/25-solid-principles.md`)

### E11.1: Single Responsibility Principle (SRP)
- **Scan:** ViewModel/UseCase/Repository files
- **Reject if:** ViewModel directly performs File I/O, Room queries, Ktor requests, or holds Android `Context` / `View`
- **Reject if:** Composable leaf components hold ViewModel or coroutine launch logic
- **Fix:** Extract to dedicated UseCase / Repository / Stateless Content

### E11.2: Open/Closed Principle (OCP)
- **Scan:** Composable parameters and MVI Intent/State hierarchies
- **Reject if:** UI components use excessive boolean flags (>3) instead of Slot APIs (`@Composable () -> Unit`)
- **Fix:** Refactor to Slot lambdas and `Modifier` parameters; model extensible states via `sealed interface`

### E11.3: Liskov Substitution Principle (LSP)
- **Scan:** Repository implementations and UI State data classes
- **Reject if:** Implementation methods throw unexpected `UnsupportedOperationException`
- **Reject if:** UI State classes contain mutable properties (`var`)
- **Fix:** Ensure all State classes are immutable `data class` (`val`), and test doubles satisfy domain contract invariants

### E11.4: Interface Segregation Principle (ISP)
- **Scan:** Leaf Composable function signatures
- **Reject if:** Entire `ViewModel` or bloated listener interface passed to leaf Composables
- **Fix:** Pass granular, fine-grained lambdas (`onSelect: (Item) -> Unit`)

### E11.5: Dependency Inversion Principle (DIP)
- **Scan:** Presentation and Domain layer import statements
- **Reject if:** Domain/Presentation imports concrete Data layer implementations, DAOs, or Ktor clients directly
- **Fix:** Invert dependency via Domain Repository Contracts & Koin DI injection

---

## CATEGORY E12: JETPACK COMPOSE QUALITY & PITFALL PREVENTION GATE

### E12.1: Lifecycle-Aware Flow Collection
- **Scan:** Composable state collections (`.collectAsState()`)
- **Reject if:** Composable calls `collectAsState()` without lifecycle awareness
- **Fix:** Replace with `collectAsStateWithLifecycle()` from `androidx.lifecycle:lifecycle-runtime-compose`

### E12.2: Lazy Layout Stable Keys
- **Scan:** `LazyColumn`, `LazyRow`, `LazyVerticalGrid` `items()` and `itemsIndexed()` blocks
- **Reject if:** `items()` is missing `key =` parameter or uses index as key (`key = { index }`)
- **Fix:** Provide unique and stable domain identifier: `key = { it.id }`

### E12.3: Child Composable Decoupling (No ViewModel in Leaves)
- **Scan:** Leaf Composable, Atom, Molecule, and List item parameter lists
- **Reject if:** `ViewModel` instance is passed down into child composables
- **Fix:** Refactor child composable to be 100% Stateless (accept only `UiState` and lambda callbacks)

### E12.4: Coroutine Stale Closure Guard
- **Scan:** Long-running `LaunchedEffect` or Coroutines capturing outer lambdas/callbacks
- **Reject if:** Async callback/lambda is referenced directly without `rememberUpdatedState`
- **Fix:** Wrap callback with `val currentCallback by rememberUpdatedState(callback)`

### E12.5: DisposableEffect Cleanup Verification
- **Scan:** `DisposableEffect` implementations
- **Reject if:** Missing `onDispose { ... }` block or empty cleanup when registering listeners/receivers
- **Fix:** Add proper unregistration/cleanup logic inside `onDispose`

### E12.6: Deferred High-Frequency State Reads
- **Scan:** `Modifier.offset(x.dp, y.dp)` or `Modifier.alpha(...)` reading dynamic animated/scroll state in composition phase
- **Reject if:** High-frequency state is evaluated in the Composition phase
- **Fix:** Convert to lambda-based modifier: `Modifier.offset { IntOffset(...) }` or `Modifier.graphicsLayer { ... }`

### E12.7: ViewCompositionStrategy in AndroidView/Fragment Interop
- **Scan:** `ComposeView` usages inside XML layouts, Fragments, or RecyclerView ViewHolders
- **Reject if:** `ComposeView` lacks explicit `setViewCompositionStrategy()`
- **Fix:** Set `setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)` for Fragments, or `DisposeOnDetachedFromWindowOrReleasedFromPool` for RecyclerView

### E12.8: Main Thread State Mutation Verification
- **Scan:** `MutableState` assignments (`.value =`) and `MutableStateFlow` updates across coroutines
- **Reject if:** UI state is mutated directly inside `Dispatchers.IO`, `Dispatchers.Default`, or raw async background callbacks
- **Fix:** Dispatch state mutations to `Dispatchers.Main` / `viewModelScope.launch(Dispatchers.Main)`

### E12.9: Stateless Screen Gate (Zero ViewModel in Screen / Leaf Composables)
- **Scan:** `koinViewModel()`, `viewModel()`, or any parameter of type `*ViewModel` inside `*Screen.kt` or child composables
- **Reject if:** Any ViewModel is instantiated or passed into a Screen / leaf composable
- **Fix:** Extract a Stateful Router (`*Route` / `*Router`) as the entrypoint. Screen must accept ONLY `UiState` and `(UiIntent) -> Unit` (or granular lambdas)

### E12.10: Mandatory Compose Previews Gate (Zero Missing Previews)
- **Scan:** All `*Screen.kt` files for `@Preview` annotations
- **Reject if:** `*Screen.kt` lacks `@Preview` definitions for Light and Dark modes, or preview fails to render due to mock data absence
- **Fix:** Add `@Preview` functions wrapping the stateless Screen in `AppTheme`, and provide `PreviewParameterProvider` with mock states (Loading, Empty, Success, Error)

### E12.11: Router Responsibility Gate (Permissions, Dialogs & Side-Effects at Router)
- **Scan:** `rememberLauncherForActivityResult`, system dialog callbacks, and `LaunchedEffect(viewModel.effect)` side-effects
- **Reject if:** Declared inside Stateless Screen instead of hoisted to the outer `*Route` / `*Router`
- **Fix:** Hoist permission launchers, system dialogs, and side-effect collectors up to the `*Route` composable

---

## CATEGORY E13: KOTLIN MULTIPLATFORM (KMP) & COMPOSE MULTIPLATFORM (CMP) COMPLIANCE GATE

### E13.1: commonMain Purity Gate (Zero Android/Java Platform Leakage)
- **Scan:** Imports in `commonMain/` source sets for `android.*`, `androidx.*` (non-KMP), `java.io.*`, `java.util.*` (where Kotlin stdlib exists)
- **Reject if:** Platform-specific Android or Java SDK APIs are imported inside `commonMain`
- **Fix:** Abstract behind a pure Kotlin `interface` in `commonMain` and provide platform implementations in `androidMain` / `iosMain`, or use KMP multiplatform libraries (`kotlinx-io`, `kotlinx-datetime`)

### E13.2: expect/actual Prudence Gate (Interface + DI over Fat expect/actual)
- **Scan:** `expect class` declarations with business logic or async operations
- **Reject if:** `expect class` is used for heavy services, database operations, or network callers instead of `interface` + Koin DI
- **Fix:** Refactor to `interface` in `commonMain` and bind implementations in platform Koin modules

### E13.3: Multiplatform Resource Gate (Zero Android R.* in commonMain)
- **Scan:** `R.string.*`, `R.drawable.*`, `R.color.*` references in `commonMain`
- **Reject if:** Android-specific `R` resource IDs are referenced inside shared Compose Multiplatform code
- **Fix:** Use Compose Multiplatform Resource Generator: `Res.string.*`, `Res.drawable.*` with `org.jetbrains.compose.resources.stringResource`

### E13.4: Dispatcher Safety Gate in Native iOS
- **Scan:** Direct `Dispatchers.IO` usage on unverified KMP targets or heavy blocking loops on Main thread
- **Reject if:** CPU-heavy cryptography/parsing executes on Main thread or unmanaged thread pools
- **Fix:** Use `Dispatchers.Default` for CPU-intensive tasks and `Dispatchers.IO` (or Ktor/Room KMP query contexts) for I/O

---

## CATEGORY E14: PERMISSION ARCHITECTURE & LIFECYCLE COMPLIANCE GATE

### E14.1: Router-Level Permission Scoping Gate
- **Scan:** `rememberPermissionController`, `rememberLauncherForActivityResult`, or raw permission request calls
- **Reject if:** Invoked inside Stateless Screens (`*Screen.kt`), leaf molecules, or child components
- **Fix:** Hoist permission controller initialization and launcher logic strictly to the Stateful Router (`*Route` / `*Router`)

### E14.2: Permanent Denial Fallback Gate (2-Strike Rule)
- **Scan:** Runtime permission requests without rationale and settings fallback
- **Reject if:** App requests permission via `RequestPermission()` without detecting permanent denial (`!shouldShowRequestPermissionRationale` + previously requested) and showing a dedicated Settings Dialog (`ACTION_APPLICATION_DETAILS_SETTINGS`)
- **Fix:** Use `rememberPermissionController()` which automatically manages Rationale and Settings dialog states

### E14.3: Special Permission Intent Routing Gate
- **Scan:** `RequestPermission()` calls with special permission strings (`MANAGE_EXTERNAL_STORAGE`, `SYSTEM_ALERT_WINDOW`, `PACKAGE_USAGE_STATS`)
- **Reject if:** Standard runtime contract is used for special OS permissions that require system Settings intents
- **Fix:** Route through `AppPermission` special intents (`ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION`, `ACTION_MANAGE_OVERLAY_PERMISSION`, etc.)

---

## CATEGORY E15: PROJECT WORKSPACE BOUNDARY & NATIVE TOOLING COMPLIANCE GATE

### E15.1: In-Project Workspace Scoping Gate
- **Scan:** Target file paths for all creation, edit, or delete operations
- **Reject if:** AI attempts to create, modify, or delete files located OUTSIDE the Project Workspace without explicit, standalone user instruction
- **Fix:** Restrict file mutations strictly within the designated Project Workspace boundary (`app/src/main/`, `domain/`, `data/`, `presentation/`, `di/`, `core/`, `plan/`)

### E15.2: Native File Operations Mandate (Zero Shell File Creation)
- **Scan:** Shell commands (`run_command`) executing file creation redirects (`cat << 'EOF'`, `echo >`, `printf >`, `tee`)
- **Reject if:** Code files or project assets are generated or overwritten using bash/shell command redirects
- **Fix:** Use native IDE tools `write_to_file` and `replace_file_content` for all file operations to eliminate shell permission interruptions

---

## CATEGORY E16: STACK VS HEAP MEMORY ALLOCATION & GC AUDIT GATE (refs: `rules/26-stack-heap-memory.md`)

### E16.1: Primitive State Boxing Gate
- **Scan:** `mutableStateOf<Int>`, `mutableStateOf<Float>`, `mutableStateOf<Long>`, `mutableStateOf<Double>`, `mutableStateOf<Boolean>`
- **Reject if:** Any generic primitive snapshot state wrapper found
- **Fix:** Replace with `mutableIntStateOf()`, `mutableFloatStateOf()`, `mutableLongStateOf()`, `mutableDoubleStateOf()` to eliminate Heap autoboxing

### E16.2: Heavy Allocation in Composable Body Gate
- **Scan:** `SimpleDateFormat(`, `DecimalFormat(`, `Regex(`, `Json {`, `DateTimeFormatter.` inside `@Composable` body or `drawBehind {}`
- **Reject if:** Expensive formatter, parser, or regex instantiated inside composition body without `remember`
- **Fix:** Hoist to `ViewModel` / `Reducer` or wrap with `remember(keys) { ... }`

### E16.3: Chained Collection Heap Churn Gate
- **Scan:** Chained transformations (`.filter { ... }.map { ... }`, `.map { ... }.sortedBy { ... }`) on standard `List` in hot data paths
- **Reject if:** Processing pipelines with $\ge 2$ chained operations on large lists do not use lazy evaluation
- **Fix:** Prefix pipeline with `.asSequence()` and conclude with `.toList()` to eliminate intermediate Heap `ArrayList` allocations

### E16.4: Domain Value Class Identifier Gate
- **Scan:** Domain model ID definitions (`data class *Id(val value: Long)`) or un-encapsulated raw primitive IDs
- **Reject if:** Wrapper ID class is declared as `data class` instead of `@JvmInline value class`
- **Fix:** Convert to `@JvmInline value class *Id(val value: Long)` for Stack allocation and zero-GC overhead

### E16.5: Context & Activity Leak Gate in ViewModel
- **Scan:** `Context`, `Activity`, `Fragment`, `View` field declarations in ViewModels and Singletons
- **Reject if:** Any Android UI component reference stored inside a long-lived class
- **Fix:** Remove UI reference; pass data via MVI Intent or inject `Application` context only

### E16.6: Symmetrical Lifecycle Disposal Gate
- **Scan:** `DisposableEffect` declarations across all presentation composables
- **Reject if:** `onDispose { ... }` block is empty or missing unregistration of active listeners / observers / sensors
- **Fix:** Implement explicit dereferencing and listener unregistration inside `onDispose`

---

## CATEGORY E17: ANDROID VITALS, APP QUALITY & SPLASH ORCHESTRATION GATE (refs: `rules/27-app-quality-vitals.md`)

### E17.1: StrictMode Main-Thread Blocking Gate
- **Scan:** `Dispatchers.Main` code blocks performing disk I/O, Room queries, Ktor networking, or JSON deserialization
- **Reject if:** Any heavy blocking task $> 5\text{ms}$ executes directly on Main thread without `withContext(Dispatchers.IO)` / `withContext(Dispatchers.Default)`
- **Fix:** Offload heavy work to appropriate background Dispatcher; enable StrictMode in Debug builds

### E17.2: Splash Screen API Misuse Gate
- **Scan:** `installSplashScreen().setKeepOnScreenCondition` logic in `MainActivity`
- **Reject if:** `setKeepOnScreenCondition` waits for network calls, Remote Config, or Ad loading $> 200\text{ms}$
- **Fix:** Dismiss System Splash in $< 200\text{ms}$ as soon as Compose frame is ready; delegate ad & config loading to In-App `SplashRoute`

### E17.3: Splash Fail-Safe Timeout Gate
- **Scan:** Remote Config and Ad loading coroutines inside `SplashViewModel`
- **Reject if:** Asynchronous startup tasks do not wrap with `withTimeoutOrNull(timeoutMs)`
- **Fix:** Enforce `withTimeoutOrNull(2500L)` for Remote Config and `withTimeoutOrNull(3500L)` for Ads, ensuring fallback navigation

### E17.4: Splash Navigation Backstack Pop Gate
- **Scan:** Navigation call from Splash to Home / Onboarding
- **Reject if:** Navigation does not pop/clear Splash route from the Navigation 3 backstack
- **Fix:** Use `navigator.navigateAndClearBackStack(Screen.Home)` to guarantee user cannot press Back into Splash

### E17.5: Ad Show Safety & Suppression Gate
- **Scan:** Ad show invocations in Presentation layer
- **Reject if:** Fullscreen ad is shown after Splash Composable unmounts, or on the first-launch onboarding screen
- **Fix:** Ensure ads only show while Splash is actively mounted; suppress splash interstitial ads on first launch

### E17.6: Baseline Profiles Release Gate
- **Scan:** Release build configuration and Macrobenchmark module
- **Reject if:** Release APK/AAB is built without `baseline-prof.txt` for Compose and startup acceleration
- **Fix:** Generate and bundle baseline profiles via Jetpack Macrobenchmark before release tagging

---

# CATEGORY E18: SPEC-DRIVEN DEVELOPMENT (SDD) GATE

### E18.1: Spec Contract Alignment Gate
- **Scan:** Code implementations, newly added APIs, entities, or 3rd-party dependencies
- **Reject if:** Implementation introduces logic, domain fields, or libraries that are not defined in the approved `spec.md` / Living Feature Spec
- **Fix:** Align implementation strictly with the Spec contract, or propose a formal Spec revision before coding

### E18.2: Exhaustive 5-State UI Matrix Gate
- **Scan:** Jetpack Compose screens, Organisms, and ViewModel UiState definitions
- **Reject if:** UiState or Screen Composable fails to explicitly define and render all 5 states: `Loading`, `Content/Success`, `Empty`, `Error`, and `Offline`
- **Fix:** Implement exhaustive state handling adhering to Design System tokens and non-blocking retry mechanisms

### E18.3: Gherkin Acceptance Criteria Verification Gate
- **Scan:** Domain Use Cases, MVI Intent handlers, and ViewModel test suites
- **Reject if:** Feature is marked complete without verifying 100% of the `Given-When-Then` behavioral acceptance criteria defined in `spec.md`
- **Fix:** Write and pass unit/UI tests verifying every Gherkin scenario

### E18.4: Task Dependency Ordering Gate
- **Scan:** Task execution sequence and commit structure
- **Reject if:** AI implements Presentation or Navigation layers before Data & Domain layer contracts are established and verified
- **Fix:** Execute tasks strictly in dependency order: `Data` $\rightarrow$ `Domain` $\rightarrow$ `Presentation` $\rightarrow$ `DI/Navigation` $\rightarrow$ `Automated Tests`

---

# CATEGORY E19: UI AESTHETICS & LAYOUT DEFENSE GATE

### E19.1: Row Text Overflow & Weight Gate
- **Scan:** `Row` composables containing dynamic `Text` / `AppText` alongside fixed siblings (Icons, Badges, ActionButtons)
- **Reject if:** Dynamic `Text` or text container in `Row` does not declare `Modifier.weight(1f)`
- **Fix:** Add `Modifier.weight(1f)` to text column and enforce `maxLines` + `overflow = TextOverflow.Ellipsis`

### E19.2: Unanchored Box Multi-Child Collision Gate
- **Scan:** `Box` composables containing $\ge 2$ children
- **Reject if:** Children inside multi-child `Box` lack explicit `Modifier.align(...)` (except 1 background element + 1 root layout)
- **Fix:** Assign explicit `Alignment` (e.g. `Alignment.TopEnd`, `Alignment.Center`) to every floating child

### E19.3: Dynamic Text Safety & Truncation Gate
- **Scan:** All user-facing titles, subtitles, card headers, and list descriptions
- **Reject if:** Dynamic text composable does not specify `maxLines` and `overflow = TextOverflow.Ellipsis`
- **Fix:** Enforce `maxLines = 1` or `maxLines = 2` with `TextOverflow.Ellipsis` on all dynamic content

### E19.4: Horizontal List Wrapping Gate
- **Scan:** Collections of tags, category chips, or filter badges rendered in UI
- **Reject if:** Dynamic collection of $> 2$ chips is placed in a rigid `Row` without `FlowRow`, `LazyRow`, or `horizontalScroll()`
- **Fix:** Replace rigid `Row` with `FlowRow(horizontalArrangement = ..., verticalArrangement = ...)` or `LazyRow`

### E19.5: 8-Point Grid Spacing & Proportions Gate
- **Scan:** Padding, Spacers, arrangement gaps, and dimensions across all presentation files
- **Reject if:** Raw arbitrary `.dp` values (e.g. `10.dp`, `13.dp`, `22.dp`, `55.dp`) are used instead of `AppSpacing.*` or 8pt grid tokens (`4/8/12/16/24/32/48dp`)
- **Fix:** Map dimensions to `AppSpacing` tokens and use consistent `AppShapes` (16-20dp for cards, 12dp for buttons, 8dp for chips)

---

# CATEGORY E20: REAL BUILD & RUNTIME VERIFICATION GATE

### E20.1: Full Assemble Build Gate
- **Scan:** Complete project build output via `./gradlew assembleDebug` (or KMP equivalent)
- **Reject if:** Build fails on AAPT2 resource linking, KSP Room schema processing, ProGuard rules, or compilation errors
- **Fix:** Fix all compilation and resource linking errors until `assembleDebug` succeeds with 0 errors

### E20.2: Koin Dependency Graph Integrity Gate
- **Scan:** Constructors of all newly created or modified ViewModels, UseCases, Repositories, and DataSources against `di/` modules
- **Reject if:** Any constructor parameter or ViewModel class is not explicitly registered in Koin modules (`singleOf`, `viewModelOf`, `factoryOf`)
- **Fix:** Register missing bindings in the appropriate Koin module in `di/` and run Koin verification tests

### E20.3: UI Initial Data Trigger Safety Gate
- **Scan:** ViewModel `init {}` blocks and Screen Composable `LaunchedEffect(Unit)` triggers
- **Reject if:** Screen requires initial data but lacks an automatic loading trigger, causing infinite loading spinners
- **Fix:** Trigger initial data load in ViewModel `init { onIntent(...) }` or Compose `LaunchedEffect(Unit)`

### E20.4: Anti-Over-Mocking & State Assertion Gate
- **Scan:** Unit test suites for ViewModels and UseCases
- **Reject if:** Tests only verify mock method calls (`verify { ... }`) without asserting concrete `UiState` values (`StateFlow.value`)
- **Fix:** Write assertions verifying exact state transitions (`Loading` $\rightarrow$ `Success(data)` / `Error`)

### E20.5: Android Resources & AAPT2 Safety Gate
- **Scan:** All string resources, drawables, and XML layout references
- **Reject if:** Code references `R.string.*` or `R.drawable.*` that does not exist in `res/values/strings.xml` or `res/drawable/`
- **Fix:** Add missing resource IDs in English in `strings.xml` and ensure valid drawables exist

---

## E21: Mobile Engineering 19-Core Defense Gate (refs: `rules/31-mobile-engineering-core.md`)

### E21.1: State & Process Death Safety Gate
- **Scan:** State management in ViewModels and UI entrypoints
- **Reject if:** Critical user form inputs or navigation arguments are stored only in memory without `SavedStateHandle` or `rememberSaveable`; or if bundles exceed 500KB
- **Fix:** Persist minimal restore keys into `SavedStateHandle` / `rememberSaveable`; re-hydrate detailed data from Room on restore

### E21.2: Background Execution & Cooperative Cancellation Gate
- **Scan:** `CoroutineWorker`, `WorkManager` tasks, and background loops
- **Reject if:** Long-running workers lack `isStopped` checks, or catch `CancellationException` without proper cleanup in `withContext(NonCancellable)`
- **Fix:** Add `if (isStopped) return Result.retry()` and ensure idempotent worker execution

### E21.3: Permission JIT Verification & Graceful Degradation Gate
- **Scan:** Hardware API invocations (Camera, Location, Audio, Bluetooth)
- **Reject if:** Permission checks are cached statically or called without immediate runtime verification (`checkSelfPermission`); or if permanent denial causes unhandled crash
- **Fix:** Implement Just-In-Time runtime checks, provide Rationale Banner, and direct intent to App Settings

### E21.4: Single Source of Truth (SSOT) & Local Outbox Queue Gate
- **Scan:** Networking and data persistence layers
- **Reject if:** Presentation layer directly observes network responses instead of observing Local Database (Room); or mutations are lost when offline
- **Fix:** Implement `networkBoundResource` pattern and queue mutations into a persistent Outbox table with UUID idempotency keys

### E21.5: Zero-Loss Persistence & Migration Integrity Gate
- **Scan:** Room database builders and migration files
- **Reject if:** Production database builder contains `fallbackToDestructiveMigration()`; or schema changes lack `MigrationTestHelper` test suite
- **Fix:** Implement explicit `Migration` scripts, enable SQLite WAL mode, and write migration tests

### E21.6: State-Driven Navigation 3 & Single-Click Debounce Gate
- **Scan:** Navigation calls, backstack manipulations, and click handlers
- **Reject if:** Raw String URLs are used for internal routes; or rapid multi-clicks push duplicate screens into backstack
- **Fix:** Use `@Serializable` route destinations and apply a 400ms debounce guard on navigation actions

### E21.7: WindowSizeClass Adaptive UI & IME Padding Defense Gate
- **Scan:** Screen layouts, forms, and input dialogs
- **Reject if:** Screen lacks `WindowSizeClass` responsiveness; or text input fields get obscured by virtual keyboard due to missing `imePadding()` / `BringIntoViewRequester`
- **Fix:** Support `Compact`/`Medium`/`Expanded` layouts and wrap scrollable forms with `.imePadding()`

### E21.8: Accessibility 48dp Touch Target & Non-Linear Font Scaling Gate
- **Scan:** Composable interactive elements (`IconButton`, `Button`, `clickable`) and text containers
- **Reject if:** Interactive touch bounds < 48x48dp; or text containers have hardcoded `.height()` that clips when font scale is set to 200%
- **Fix:** Apply `.minimumInteractiveComponentSize()` and use `wrapContentHeight()` / `defaultMinSize()` for text containers

### E21.9: RTL Start/End Layout Anchoring & Localized String Tokens Gate
- **Scan:** Layout modifiers and string references
- **Reject if:** Layout uses `padding(left = ..., right = ...)` instead of `start`/`end`; or hardcoded strings exist without `stringResource` / `getQuantityString`
- **Fix:** Migrate to `start`/`end` for RTL compatibility; use `strings.xml` and plural resources

### E21.10: Main-Thread Purity & Atomic StateFlow Updates Gate
- **Scan:** Coroutine dispatchers and StateFlow mutations
- **Reject if:** Heavy I/O, DB, or JSON parsing runs on `Dispatchers.Main`; or StateFlow is updated via `_state.value = ...` instead of `_state.update { ... }`
- **Fix:** Offload heavy work to `Dispatchers.IO`/`Default`; use atomic `_state.update { copy(...) }`

### E21.11: Heap Allocation Defense & Compose Stability Gate
- **Scan:** Composable function bodies and Canvas draw blocks
- **Reject if:** Object allocations (`SimpleDateFormat`, `Regex`, new lambdas capturing scope) occur repeatedly inside Composable body without `remember`
- **Fix:** Hoist allocations, memoize via `remember`, and use `@Immutable` / `@Stable` annotations

### E21.12: Android OS SDK Version Branching & Predictive Back Gate
- **Scan:** Platform-specific API calls and back gesture handling
- **Reject if:** New Android APIs (Tiramisu, UpsideDownCake, VanillaIceCream) are called without `Build.VERSION.SDK_INT` check; or Predictive Back is unhandled
- **Fix:** Add SDK version checks and implement `PredictiveBackHandler`

### E21.13: Cross-Platform Pigeon Type Safety Gate (Flutter / KMP)
- **Scan:** MethodChannel and cross-platform bridge code
- **Reject if:** Untyped string channels or dynamic JSON maps are used for IPC without type safety
- **Fix:** Generate type-safe contracts with Pigeon and perform heavy computations in background isolates

### E21.14: Lifecycle-Bound Hardware Sensors Gate
- **Scan:** SensorManager, CameraX, GPS location listeners
- **Reject if:** Listeners remain active when app enters background (`ON_PAUSE` / `ON_STOP`)
- **Fix:** Bind listeners to `LifecycleOwner` via `DisposableEffect` with automatic unregister on dispose

### E21.15: Hardware-Backed Keystore & Window Screen Defense Gate
- **Scan:** Token storage and sensitive payment/vault screens
- **Reject if:** Auth tokens/passwords stored in plaintext SharedPreferences; or sensitive screens lack `FLAG_SECURE`
- **Fix:** Use `EncryptedSharedPreferences` / `EncryptedFile` with Android Keystore MasterKey; apply `FLAG_SECURE` on sensitive windows

### E21.16: 16KB Memory Page Alignment & In-App Updates Gate
- **Scan:** NDK C++ build flags and version update checks
- **Reject if:** C++ native libs lack `-Wl,-z,max-page-size=16384` alignment flag; or app lacks `AppUpdateManager` update handling
- **Fix:** Add 16KB page alignment flags and integrate In-App Update listeners

### E21.17: Structured Crashlytics Breadcrumbs & TTFD Tracing Gate
- **Scan:** Feature navigation and critical business flows
- **Reject if:** Major user flows lack breadcrumb logging in Crashlytics; or app fails to call `reportFullyDrawn()` after startup
- **Fix:** Log navigation/intent breadcrumbs and instrument startup TTFD metrics

### E21.18: Turbine Flow Testing & Real Assemble Build Gate
- **Scan:** Test suites and build artifacts
- **Reject if:** Flow emissions are not asserted via Turbine; or build fails `./gradlew assembleDebug testDebugUnitTest`
- **Fix:** Write Turbine tests and verify real `BUILD SUCCESSFUL`

### E21.19: The 10 Ultimate Failure Modes Defense Gate
- **Scan:** Feature design against the 10 failure modes (App Kill, Backgrounding, Permission Revoke, Network Loss, Disk Full, Migration Fail, Stale Async, Duplicate Click, Missing Hardware, Thermal Throttling)
- **Reject if:** Any of the 10 failure modes results in an unhandled crash or frozen UI
- **Fix:** Implement defensive fallbacks, catch `IOException`, apply debouncing, and provide offline degradation

---

# CATEGORY E22: ANTI-OVERENGINEERING & MINIMALIST CODE QUALITY GATES (Rule 32)

### E22.1: Redundant Helper/Wrapper Gate
- **Scan:** New and modified classes, utility objects, and wrapper layers
- **Reject if:** Creating a static helper object (`DateUtils`, `StringUtils`, `ViewHelper`) or wrapper class when a focused, top-level Kotlin extension function or Stdlib API solves the problem
- **Fix:** Delete the wrapper/helper class and replace with an idiomatic Kotlin extension function or Stdlib call

### E22.2: Over-Architected Intermediate Layer Gate
- **Scan:** Domain UseCases and delegate classes
- **Reject if:** A UseCase contains no domain business logic, data transformation, or validation, and merely acts as a 1-line delegate to a Repository/DAO (`repository.getData()`)
- **Fix:** Remove the redundant UseCase; allow the ViewModel to interact directly with the Repository contract

### E22.3: Single-Expression Idiom Gate
- **Scan:** Function declarations across ViewModel, Repository, and Utility code
- **Reject if:** A function body consists of a single return statement wrapped in block syntax `{ return ... }` instead of using Kotlin single-expression `= expression`
- **Fix:** Convert to Kotlin single-expression syntax `fun doSomething(): Type = expression`

### E22.4: Native Platform & Stdlib First Gate
- **Scan:** Custom UI components, debounce utilities, and formatting helpers
- **Reject if:** Writing custom canvas/layout implementations for standard UI elements (e.g., date pickers, color pickers, debounce loops) when Jetpack Compose Material 3 or Kotlin Coroutines Flow already provides native operators (`DatePicker`, `Flow.debounce()`)
- **Fix:** Replace custom implementation with native Compose M3 component or Flow operator

### E22.5: Zero-Dependency-Bloat Gate
- **Scan:** `libs.versions.toml` and `build.gradle.kts`
- **Reject if:** Adding a new 3rd-party library without prior user approval, or when an existing installed dependency / Kotlin Stdlib / Android Platform SDK can fulfill the requirement
- **Fix:** Remove unnecessary dependency and use Stdlib / Platform API

### E22.6: Trivial Comment Noise Gate
- **Scan:** Inline and function-level comments across all modified files
- **Reject if:** Trivial, redundant, or micro-comments exist that merely repeat what the code or variable does (e.g., `// Load data`, `// User ID`, `// Handle click`, `// Initialize viewModel`)
- **Fix:** Remove the redundant comment; ensure variable and function names are 100% self-documenting. Comments are allowed ONLY for complex algorithms, OS/library workarounds, or hardware concurrency constraints.

---

# CATEGORY E23: AI BLIND SPOTS & DEFENSIVE EXECUTION GATES

### E23.1: Lazy Layout Stable Key & ContentType Gate
- **Scan:** `LazyColumn`, `LazyRow`, `LazyVerticalGrid`, and `LazyHorizontalGrid` declarations
- **Reject if:** Missing explicit `key = { it.id }` or `contentType` in `items()` calls
- **Fix:** Provide unique, stable keys and content types to prevent full list recomposition and scroll jank

### E23.2: Duplicate Click & Re-entrancy Protection Gate
- **Scan:** Button click handlers, payment triggers, and ViewModel intent handlers
- **Reject if:** Critical mutating actions (e.g. submit, checkout, navigate) can be fired concurrently upon rapid double-clicking without a loading lock or UI debounce
- **Fix:** Add `if (state.value.isLoading) return@safeLaunch` in ViewModel and apply 400ms debounce on navigation actions

### E23.3: Form State Survival Gate
- **Scan:** Form input fields, text editing states, and search queries in UI
- **Reject if:** Ephemeral user inputs rely solely on `remember { mutableStateOf("") }` and are lost upon screen rotation or Process Death
- **Fix:** Migrate to `rememberSaveable` or hoist directly into `SavedStateHandle` / `ViewModel`

### E23.4: Keyboard IME Auto-Scroll & Viewport Gate
- **Scan:** Input fields located in scrollable screens and modal bottom sheets
- **Reject if:** Input fields at the bottom of the viewport lack auto-scrolling when IME opens, causing virtual keyboard obstruction
- **Fix:** Combine `Modifier.imePadding()` with scrollable containers and `BringIntoViewRequester`

### E23.5: Modern Compose & Navigation 3 Import Purity Gate
- **Scan:** Imports in Compose and Navigation files
- **Reject if:** Importing deprecated Accompanist packages or legacy string route navigation (`"home/{id}"`)
- **Fix:** Use native Jetpack Compose Material 3 APIs and strongly typed `@Serializable` destinations in Navigation 3

### E23.6: Localization & Plurals Compliance Gate
- **Scan:** String formatting and display logic in Composable functions
- **Reject if:** Manual string concatenation is used for dynamic counts or currencies (e.g. `"$ " + price`, `"$count items"`)
- **Fix:** Use `pluralStringResource(R.plurals.items_count, count, count)` and `stringResource(R.string.price_format, price)`

### E23.7: Zero-Fluff Direct Communication Standard
- **Scan:** AI response prose and architectural reports
- **Reject if:** Conversational fluff, generic apologies, or redundant pleasantries dilute technical clarity
- **Fix:** Output dense, direct, CTO-level architectural assessments and clean drop-in diffs

---

# CATEGORY E24: MODERN TESTING & QUALITY ASSURANCE GATES (Rule 33)

### E24.1: Turbine Flow Emission Gate
- **Scan:** ViewModel and Flow test cases
- **Reject if:** Flow emissions are asserted via static getters or manual collectors without `Turbine` (`viewModel.state.test { ... }`)
- **Fix:** Refactor test to use `Turbine` with `awaitItem()`, `expectNoEvents()`, and `cancelAndIgnoreRemainingEvents()`

### E24.2: Fakes Over Mocks Gate
- **Scan:** Test doubles in unit test files
- **Reject if:** Deep, brittle MockK configurations with 10+ `every { ... } returns ...` mock statements are used for simple data structures
- **Fix:** Replace over-mocked dependencies with clean, deterministic in-memory Fakes (`FakeUserRepository`)

### E24.3: Zero-Flakiness Coroutine Gate
- **Scan:** Test dispatchers and coroutines execution in tests
- **Reject if:** Tests utilize `Thread.sleep()`, arbitrary `delay()`, or unmanaged `GlobalScope`
- **Fix:** Use `runTest` with `StandardTestDispatcher` and `advanceUntilIdle()` for 100% deterministic time control

### E24.4: Koin DI Graph Self-Verification Gate
- **Scan:** DI configuration tests
- **Reject if:** Project lacks an automated `appModule.verify()` test suite
- **Fix:** Implement `KoinTest` verifying all ViewModel, UseCase, and Repository constructor bindings

### E24.5: 5-State UI Matrix Test Coverage Gate
- **Scan:** UI and ViewModel test coverage
- **Reject if:** Test suites fail to assert all 5 mandatory UI states (`Loading`, `Content`, `Empty`, `Error`, `Offline`)
- **Fix:** Add exhaustive test cases covering all 5 UI state transitions

---

# CATEGORY E25: SDK & MODULAR QUALITY GATES (Rule 34)

### E25.1: Public API Surface & Visibility Isolation Gate
- **Scan:** Class, interface, and top-level declarations in SDK and core library modules
- **Reject if:** Implementation classes, network clients, database entities, or helpers are exposed as `public` instead of `internal`
- **Fix:** Mark all non-contract classes and implementation details as `internal`

### E25.2: Mandatory Test Double / Fake Artifact Gate
- **Scan:** Module architecture and test fixtures
- **Reject if:** An internal SDK or core module lacks a companion `:testing` submodule providing an in-memory Fake (`Fake<SdkName>`)
- **Fix:** Create `:core:<module>:testing` submodule exporting thread-safe, high-performance in-memory fakes for consumers

### E25.3: Zero Startup Penalty Gate
- **Scan:** AndroidManifest.xml and initialization logic of SDK modules
- **Reject if:** SDK uses `ContentProvider` or forced eager auto-initialization at app cold start
- **Fix:** Implement explicit `SdkConfiguration` with lazy / on-demand initialization

### E25.4: Gradle Dependency Isolation Gate
- **Scan:** `build.gradle.kts` dependency blocks across modules
- **Reject if:** Internal dependencies are exposed via `api` instead of `implementation`, or circular dependencies exist
- **Fix:** Convert internal dependencies to `implementation` to protect ABI boundaries and speed up compilation

### E25.5: Host App Error Isolation Gate
- **Scan:** Public API methods in SDK modules
- **Reject if:** Public methods throw unhandled exceptions or fail to wrap results in `SdkResult<T>`
- **Fix:** Wrap public API endpoints in `SdkResult<T>` with structured error codes (`SdkErrorCode`)

### E25.6: SemVer & Deprecation Lifecycle Gate
- **Scan:** Refactored and modified public SDK methods
- **Reject if:** Public API signatures are altered or removed without a `@Deprecated(ReplaceWith = ...)` transition cycle
- **Fix:** Add deprecation annotation with automated replacement hints before deleting legacy APIs

---

# CATEGORY E26: DB MIGRATION & R8 PROGUARD RELEASE GATES (Rule 35)

### E26.1: Zero-Destructive-Migration Gate
- **Scan:** Room database builder configurations across all modules
- **Reject if:** Calling `fallbackToDestructiveMigration()` or destructive downgrade wipes in production code
- **Fix:** Remove destructive migration calls and implement explicit `Migration` or Room `@AutoMigration`

### E26.2: Room Schema Export & Migration Test Gate
- **Scan:** KSP Room compiler arguments and database test suites
- **Reject if:** `room.schemaLocation` is not configured, or a database version bump lacks a `MigrationTestHelper` test asserting historical data preservation
- **Fix:** Configure schema export directory and write automated `MigrationTestHelper` tests for all migration paths

### E26.3: Consumer Proguard Rules Isolation Gate
- **Scan:** Module `build.gradle.kts` files and `consumer-rules.pro` definitions
- **Reject if:** Internal library or SDK modules fail to specify `consumerProguardFiles("consumer-rules.pro")` protecting their internal DTOs, DAOs, and entities
- **Fix:** Add `consumer-rules.pro` with explicit keep rules for `@Serializable`, `@Entity`, and `@Dao`

### E26.4: R8 Serialization & Keep Annotation Gate
- **Scan:** API DTOs, Room Entities, Navigation 3 routes, and reflective models
- **Reject if:** Boundary models lack `@Serializable` or `@Keep` annotations, risking R8 field/constructor stripping in release builds
- **Fix:** Annotate models with `@Serializable` or `@Keep` and verify R8 keep rules

### E26.5: Real Release Minify Build Gate
- **Scan:** Release build artifacts and CI test verification
- **Reject if:** Release preparation tasks skip minified compilation verification (`./gradlew assembleRelease testReleaseUnitTest`)
- **Fix:** Execute real minified release build to prove zero R8/ProGuard runtime crashes

---

# CATEGORY E27: UI/UX & AESTHETIC POLISH GATES (Rule 36)

### E27.1: Anti-AI-Design-Cliché Gate
- **Scan:** Composable colors, brush gradients, and card nesting
- **Reject if:** Code contains forbidden AI tropes: purple/violet on dark backgrounds, glowing neon border outlines, biscuit pill badges with pulsing dots, gradient text fills on single keywords, or 3+ layers of nested cards
- **Fix:** Remove cliché tropes; apply clean, function-driven Material 3 styling

### E27.2: Visual Depth & Subtle Border Gate
- **Scan:** Surface and Card composable definitions
- **Reject if:** Cards/containers lack visual depth or use flat harsh gray sheets without subtle borders
- **Fix:** Apply a 0.5dp semi-transparent border (`AppTheme.colors.outlineVariant.copy(alpha = 0.5f)`) and layered tonal surfaces (`surfaceContainerLowest` to `surfaceContainerHigh`)

### E27.3: Typography Hierarchy & Contrast Gate
- **Scan:** Typography styling and colors across all text composables
- **Reject if:** Headings, section titles, and body texts have flat indistinguishable styling or fail WCAG AA contrast (4.5:1 for body)
- **Fix:** Enforce 3-tier hierarchy: Hero Display (28-34sp Bold with -0.5sp tracking) > Title (18-22sp SemiBold) > Body (14-16sp Regular with 1.4x line-height) > Meta (11-12sp onSurfaceVariant)

### E27.4: 8-Point Grid Visual Rhythm Gate
- **Scan:** Padding, spacer sizes, and component dimensions
- **Reject if:** Arbitrary non-grid values (e.g. 7dp, 13dp, 19dp) are used for layout spacing
- **Fix:** Snap all dimensions to strict 8-point geometric tokens (`4dp`, `8dp`, `16dp`, `24dp`, `32dp`)

### E27.5: Domain-Tailored Aesthetics Gate
- **Scan:** Color palettes and component styling against application vertical
- **Reject if:** Generic cookie-cutter gray templates are applied indiscriminately to specialized domains (e.g., Fintech missing tabular numbers and high-trust palettes; E-commerce missing high-contrast CTAs)
- **Fix:** Adopt domain-tailored color palettes and component aesthetics from `skills/ui-ux-pro-max`

### E27.6: Micro-Interactions & State Polish Gate
- **Scan:** Interactive surfaces, buttons, and loading screens
- **Reject if:** Interactive elements lack ripple indication, or loading screens show abrupt spinners instead of fluid shimmer skeletons
- **Fix:** Implement fluid ripple feedback and shimmer skeleton placeholders

---

# CATEGORY E28: UBIQUITOUS LANGUAGE & DOMAIN PRECISION GATES (Rule 37)

### E28.1: Domain Dictionary & CONTEXT.md Compliance Gate
- **Scan:** Feature domain models, specs, and planning documents
- **Reject if:** Project lacks a `docs/CONTEXT.md` (or `CONTEXT.md`) glossary, or code uses ambiguous synonyms instead of established domain terms (e.g. "Folder" instead of "Container", "Logged In" instead of "Session Unlocked")
- **Fix:** Create or update `docs/CONTEXT.md` and refactor models to strictly use official domain terms

### E28.2: 1-to-1 Domain-to-Code Mapping Gate
- **Scan:** Kotlin models, UseCases, and Navigation destinations
- **Reject if:** Business domain entities do not map 1-to-1 to explicit typed code symbols (`@Serializable data class Screen`, sealed MVI intents, domain data classes)
- **Fix:** Bind every business domain concept to a strongly-typed Kotlin symbol

### E28.3: Anti-Fluff Communication Gate ("20 Words Where 1 Will Do")
- **Scan:** Agent planning responses, code comments, and documentation
- **Reject if:** Agent uses verbose conversational workarounds to describe well-defined domain concepts
- **Fix:** Enforce concise, domain-precise vocabulary across all communications

### E28.4: Tracer-Bullet Vertical Slicing Gate
- **Scan:** Task decomposition in plans (`plan.md` and `tasks.md`)
- **Reject if:** Tasks are decomposed in isolated horizontal layers (all DAOs ➔ all Repos ➔ all ViewModels ➔ all UI)
- **Fix:** Reorganize tasks into end-to-end vertical slices (Tracer Bullets) connecting Data through UI for each individual user interaction

### E28.5: Living ADR Auto-Extraction Gate
- **Scan:** Major architectural trade-offs in plan proposals
- **Reject if:** Significant technology choices, library replacements, or paradigm shifts lack an Architectural Decision Record in `docs/adr/`
- **Fix:** Extract the decision into a formal ADR file (`docs/adr/00xx-<title>.md`)

---

# CATEGORY E29: GOOGLE PLAY DEVICE & NETWORK ABUSE POLICY GATES (Rule 38)

### E29.1: Zero Dynamic Code Loading (Zero DCL) Gate
- **Scan:** Dependencies, reflection calls, ClassLoader usages (`DexClassLoader`, `PathClassLoader`), and remote binary downloads
- **Reject if:** App or any integrated SDK downloads executable binaries (`.dex`, `.jar`, `.so`) from remote servers at runtime or attempts self-updating outside Google Play
- **Fix:** Package all executable code inside the Android App Bundle (AAB); use Google Play Core In-App Updates API exclusively

### E29.2: Android 14+ Foreground Service (FGS) Eligibility & Declaration Gate
- **Scan:** `AndroidManifest.xml` `<service>` declarations and background task dispatchers
- **Reject if:** A Foreground Service lacks a valid `android:foregroundServiceType`; or uses FGS for deferrable work (e.g. background syncing without active user interaction); or lacks an eligible user-initiated trigger
- **Fix:** Specify explicit `foregroundServiceType` and declare corresponding `FOREGROUND_SERVICE_*` permission; migrate non-urgent or deferrable tasks to `WorkManager`

### E29.3: On-Device Android Container Defense Gate (`REQUIRE_SECURE_ENV`)
- **Scan:** `AndroidManifest.xml` `<application>` block
- **Reject if:** App processes sensitive user credentials, auth tokens, financial data, or enterprise storage but fails to declare `<meta-data android:name="android.os.REQUIRE_SECURE_ENV" android:value="true" />`
- **Fix:** Add `REQUIRE_SECURE_ENV` meta-data to block untrusted container, app-cloner, and dual-space hooking environments

### E29.4: FLAG_SECURE Anti-Bypass & Surface Protection Gate
- **Scan:** Window management, screenshot handlers, and sensitive Compose screens
- **Reject if:** App attempts to bypass or intercept `FLAG_SECURE` in third-party applications; or payment/auth/vault screens fail to apply `FLAG_SECURE`
- **Fix:** Enforce `SecureScreenEffect` on sensitive screens; ensure accessibility tools do not cache or transmit `FLAG_SECURE` content outside the device

### E29.5: WebView Untrusted JavaScript Interface Gate
- **Scan:** `WebView` implementations and `addJavascriptInterface` declarations
- **Reject if:** `addJavascriptInterface` is attached to a WebView that loads unverified or cleartext (`http://`) web content
- **Fix:** Restrict JS interfaces strictly to verified first-party `https://` URLs loaded from local assets or trusted domain whitelists

### E29.6: User-Initiated Data Transfer (UIDT) & Anti-Proxy Gate
- **Scan:** Network transfer workers and proxy services
- **Reject if:** UIDT API / large transfer jobs are triggered autonomously without direct user action; or app runs proxy/VPN services that are not the primary, user-facing core purpose of the application
- **Fix:** Restrict UIDT to direct user-prompted commands; enforce core-purpose requirement for proxy/VPN features

---

# EXECUTION PROTOCOL


When completing a task, the AI MUST:

```text
1. Identify which enforcement categories apply:
   - UI changes → E1 (Design System) + E4 (Compose) + E18.2 (5-State Matrix) + E19 (Layout Defense) + E21.7 (Adaptive UI/IME) + E21.8 (a11y 48dp) + E22 (Anti-Overengineering) + E23 (Blind Spots Defense) + E24.5 (UI Test Coverage) + E27 (UI/UX Polish & Anti-Cliché)
   - ViewModel changes → E2 (Architecture-VM) + E18.3 (Gherkin Verification) + E20.2 (Koin Integrity) + E20.3 (Data Trigger) + E21.1 (Process Death) + E21.10 (Atomic StateFlow) + E22.2 (No Redundant UseCases) + E22.3 (Single Expression) + E23.2 (Re-entrancy Lock) + E24.1 (Turbine) + E24.2 (Fakes) + E24.3 (Zero Flakiness)
   - Data & Networking → E3 + E21.4 (SSOT Outbox) + E21.5 (Zero Data Loss Migration) + E21.15 (Keystore Security) + E22.5 (Zero Dependency Bloat) + E24.2 (Fakes) + E26.1 (No Destructive Migration) + E26.2 (Schema Test)
   - SDK & Core Modules → E25 (Full SDK Audit: Public Surface, Fake Artifacts, Zero Auto-Init, Error Isolation) + E26.3 (Consumer Proguard)
   - Release & Build → E9 + E20.1 (Assemble Debug) + E26.4 (Keep Rules) + E26.5 (Assemble Release Minify)
   - Background & Hardware → E21.2 (WorkManager Cancellation) + E21.3 (JIT Permissions) + E21.14 (Lifecycle Sensors) + E29 (Device & Network Abuse Policy)
   - Security & Storage → E17 + E21.15 (Keystore Security) + E29.3 (Container Defense) + E29.4 (FLAG_SECURE)
   - New feature → E1 + E2 + E3 + E4 + E6 + E10 + E18 + E19 + E20 + E21 + E22 + E23 + E24 + E25 + E26 + E27 + E28 + E29 (Full 19-Core + Minimalist + Blind Spots + Testing + SDK + Release + UI/UX + Ubiquitous + Abuse Policy Audit)
   - Any code change → E9 + E20.1 (Full Assemble Build & Test verification)

2. Run applicable scans on ALL modified files

3. For each violation found:
   a. Fix the violation immediately
   b. Log the fix in the completion report

4. Re-scan after fixes to confirm ZERO violations

5. Run full build verification (E20.1: `./gradlew assembleDebug testDebugUnitTest`)

6. Report completion with enforcement summary
```

---

# VIOLATION RESPONSE PROTOCOL

When encountering EXISTING violations in files being modified:

1. **REPORT** the violation to the user
2. **PROPOSE** fixing it alongside the current task
3. **NEVER** add new code that follows the same violation pattern
4. **LOG** the violation for future cleanup if user declines immediate fix

---

# Final Rule

Enforcement is not optional.

Rules without enforcement are merely suggestions.

This engine transforms every rule in the project from a suggestion into a gate.

No code passes through the gate unless it meets every applicable standard.
