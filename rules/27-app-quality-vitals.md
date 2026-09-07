# 27-app-quality-vitals.md

# Purpose

This document establishes the project's mandatory architecture and engineering standards for **Google Play Android Vitals, App Quality, Zero-Crash / Zero-ANR Engineering, and the 2-Tier Hybrid Splash Architecture**.

App Quality is a functional requirement. Violating Android Vitals thresholds leads directly to Google Play Store ranking demotion, warning banners, and high user uninstall rates.

---

# Related Files

- Rules: `rules/01-tech-stack.md`, `rules/06-compose.md`, `rules/07-viewmodel.md`, `rules/08-coroutines.md`, `rules/13-error-handling.md`, `rules/15-debugging.md`, `rules/16-performance.md`, `rules/18-monetization.md`, `rules/26-stack-heap-memory.md`, `rules/21-enforcement-engine.md` (Gate E17)
- Skills: `skills/app-quality-vitals.md`, `skills/performance.md`, `skills/stack-heap-memory.md`

---

# Quantitative Android Vitals Budgets

| Metric | Google Play Bad Threshold | Antigravity Mandate Budget | Measurement Method |
| :--- | :--- | :--- | :--- |
| **User-Perceived Crash Rate** | $\ge 1.09\%$ | **$< 0.05\%$ (Zero Uncaught Exceptions)** | Firebase Crashlytics & Google Play Console |
| **User-Perceived ANR Rate** | $\ge 0.47\%$ | **$< 0.02\%$ (Zero Main-Thread Blocking)** | StrictMode & Android Vitals |
| **Cold Start (TTID)** | $\ge 5000\text{ms}$ | **$< 500\text{ms}$ (Time to Initial Display)** | Macrobenchmark & `reportFullyDrawn()` |
| **Cold Start (TTFD)** | $\ge 8000\text{ms}$ | **$< 800\text{ms}$ (Time to Full Display)** | Macrobenchmark & Compose Tracer |
| **Warm / Hot Start** | $\ge 2000\text{ms}$ / $\ge 1500\text{ms}$ | **$< 200\text{ms}$ (Warm) / $< 100\text{ms}$ (Hot)** | System Trace / Profiler |
| **Slow Rendering Frames** | $\ge 50\%$ Frames $> 16.6\text{ms}$ | **$< 1\%$ Dropped Frames (120/60 FPS)** | Jetpack FrameMetrics & JankStats |

---

# Mandatory App Quality & Vitals Rules

## Rule 27.1: Zero Main-Thread Blocking & StrictMode Integration
The Main Thread (`Dispatchers.Main`) is strictly reserved for UI layout rendering, measurement, and lightweight state emission.
1. **Forbidden on Main Thread:**
   - Disk I/O (File read/write, SharedPreferences sync reads `.getSharedPreferences()`)
   - SQLite / Room database queries or transactions
   - Network requests (Ktor / OkHttp)
   - Cryptographic operations (AES encryption, KeyStore access)
   - JSON parsing or reflection-based deserialization
   - Synchronous IPC / Binder calls to Android system services
   - `runBlocking { ... }` or thread sleeps
2. **Mandatory StrictMode in Debug Builds:**
   Every Application class MUST enable StrictMode in `isDebug` mode to catch thread policy violations instantly:
   ```kotlin
   if (BuildConfig.DEBUG) {
       StrictMode.setThreadPolicy(
           StrictMode.ThreadPolicy.Builder()
               .detectDiskReads()
               .detectDiskWrites()
               .detectNetwork()
               .detectCustomSlowCalls()
               .penaltyLog()
               .penaltyFlashScreen()
               .build()
       )
   }
   ```

---

## Rule 27.2: Safe Coroutine Launch & Global Crash Interception
Uncaught exceptions in asynchronous Coroutines or background tasks crash the entire application process.
1. **ViewModel Coroutine Safety (Gate E2.2):**
   All ViewModel coroutines MUST be launched via `BaseViewModel.safeLaunch` (or `launch {}` wrapping `CoroutineExceptionHandler`), routing exceptions to `MviEffect` for graceful UI messaging and logging to Firebase Crashlytics:
   ```kotlin
   // ❌ BAD: Uncaught exception crashes app with Fatal Exception
   viewModelScope.launch { repository.fetchRemoteData() }
   
   // ✅ GOOD: Safe launch with centralized exception handling
   launch {
       val result = repository.fetchRemoteData()
       setState { copy(data = result) }
   }
   ```
2. **Safe DTO Mapping:** Tầng Data mapping DTO sang Domain Model bắt buộc phải có giá trị mặc định an toàn (default fallback values), không bao giờ để `NullPointerException` hoặc `SerializationException` lọt lên tầng Domain/UI.

---

## Rule 27.3: 2-Tier Hybrid Splash Architecture (Fast TTID + Orchestrator)
To balance instant system startup (TTID $< 500\text{ms}$) with complex startup pipelines (Remote Config, GDPR Consent, Ad Loading):
1. **Tier 1 — System Splash (`androidx.core.splashscreen.SplashScreen`):**
   - Must be installed in `MainActivity.onCreate()` via `installSplashScreen()`.
   - `setKeepOnScreenCondition` is ONLY allowed for instantaneous local initialization (Theme, Core DI, local DataStore) and MUST dismiss in **$< 200\text{ms}$**.
   - **PROHIBITED:** Keeping `setKeepOnScreenCondition = true` to wait for Remote Config, Network, or Ads.
2. **Tier 2 — In-App Brand Splash (Jetpack Compose `SplashRoute`):**
   - Handles the branded UI (Logo, animation, subtle progress indicator, status text).
   - Coordinates the asynchronous startup pipeline in parallel with strict fail-safe timeouts:
     - Remote Config Fetch: Timeout $\le 2500\text{ms}$ (Fallback to local default cache if timed out).
     - Splash Ad Load: Timeout $\le 3500\text{ms}$ (Skip ad and proceed immediately if timed out).
     - Total Splash Time Budget: **$\le 5.0\text{s}$ under all network conditions**.

---

## Rule 27.4: Splash Ad Safety & Backstack Clean-up
Monetization ads during app startup must never violate Google Ad Policies or corrupt navigation:
1. **No Ad after Unmount:** If the user has already transitioned to `HomeScreen` or `OnboardingScreen`, NEVER trigger a delayed fullscreen ad. Ads may only show while the `SplashRoute` is active.
2. **Navigation Backstack Clean-up:**
   When navigating from `Splash` to `Home`, the Splash route MUST be cleared from the Navigation 3 backstack:
   ```kotlin
   // ✅ GOOD: Clears Splash so pressing Back on Home exits app, never returning to Splash
   navigator.navigateAndClearBackStack(Screen.Home)
   ```
3. **First-Launch D1 Retention Guard:**
   On the user's very first launch (Onboarding flow), **DO NOT show Splash Interstitial/AppOpen Ads** to maximize Day-1 onboarding completion and user retention.

---

## Rule 27.5: Startup Acceleration via Baseline Profiles & Lazy DI
1. **Baseline Profiles (Macrobenchmark):**
   All production release builds MUST include a pre-compiled Baseline Profile (`baseline-prof.txt`) generated via Jetpack Macrobenchmark. This enables Android Runtime (ART) Ahead-Of-Time (AOT) compilation for:
   - Compose runtime and Material 3 theme classes
   - Navigation graph route initializers
   - Splash and Home screen Composables
2. **Lazy DI Graph Resolution:**
   Koin modules must favor `factory` or `single(createdAtStart = false)` over eager initialization to prevent blocking the Main Thread during `Application.onCreate()`.

---

# Architecture Compliance Checklist

Before reporting ANY startup, splash, or quality task as complete, verify:

- [ ] Zero blocking operations (`> 5ms`) on `Dispatchers.Main`; StrictMode configured in Debug.
- [ ] 100% of ViewModel coroutines launched via `safeLaunch` with global error reporting.
- [ ] System Splash API (`installSplashScreen`) dismisses in $< 200\text{ms}$ (No ad waiting on Tier 1).
- [ ] Splash pipeline uses `withTimeoutOrNull` for Remote Config ($\le 2.5\text{s}$) and Ads ($\le 3.5\text{s}$).
- [ ] Splash route is cleared from backstack upon navigating to Home.
- [ ] No interstitial ads shown on first launch onboarding.
- [ ] Baseline Profiles configured for Release builds.
- [ ] 100% compliant with Enforcement Gate **E17** in `rules/21-enforcement-engine.md`.
