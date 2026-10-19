---
description: End-to-end automated workflow to integrate or upgrade PandaAds SDK (v1.3.0+ NextGen) in any Android project (Jetpack Compose, XML Views, or Hybrid).
---

# Workflow: Integrate PandaAds SDK (`/integrate-panda-ads`)

Use this step-by-step workflow when asked to integrate, migrate, or audit **PandaAds SDK (`com.panda.ads` v1.3.0+)** in any Android repository.

---

## Stage 1: Target Project Discovery & Architecture Audit
Before modifying any code, inspect the target repository to determine:
1. **Build Configuration**:
   - Inspect `settings.gradle.kts` (or `settings.gradle`), `gradle/libs.versions.toml`, and `app/build.gradle.kts`.
   - Identify the application module name (usually `:app`), `namespace`, `applicationId`, `minSdk`, and `compileSdk`.
2. **UI Toolkit Topology**:
   - **Jetpack Compose**: Uses `@Composable` screens, `NavHost` / Navigation 3, `LazyColumn`, `HorizontalPager`.
   - **Android XML Views**: Uses `Activity` / `Fragment`, `ViewBinding` / `DataBinding`, `RecyclerView`, `ViewPager2`.
   - **Hybrid**: Combines XML Activities/Fragments with Compose screens.
3. **Existing App Journey Entrypoints**:
   - Locate the `Application` subclass (declared in `AndroidManifest.xml`).
   - Locate the cold-start `SplashActivity` / `SplashScreen`.
   - Locate First-Open flows: Language Selection (LFO 1 / LFO 2) and Onboarding Pager.
   - Locate Main Workspace screens: Home, Content Feed (`LazyColumn` / `RecyclerView`), Rewarded actions, and VIP Paywall / Settings.

---

## Stage 2: Gradle Dependencies & `AndroidManifest.xml` Wiring

### 2.1. Configure Maven Repository (`settings.gradle.kts`)
If the project consumes PandaAds from GitHub Packages / Maven:
```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/vinhvox/Panda-NextGen-2027")
            credentials {
                username = System.getenv("GITHUB_ACTOR") ?: (project.findProperty("gpr.user") as? String ?: "")
                password = System.getenv("GITHUB_TOKEN") ?: (project.findProperty("gpr.key") as? String ?: "")
            }
        }
    }
}
```

### 2.2. Add Dependencies (`app/build.gradle.kts`)
```kotlin
dependencies {
    // Umbrella artifact (includes :sdk:api, :sdk:core, :sdk:engine-nextgen, :sdk:consent-ump, :sdk:ui-compose, :sdk:ui-views, :sdk:sink-appsflyer)
    implementation("com.panda.ads:panda-ads:1.3.0")

    // Deterministic JVM unit test harness
    testImplementation("com.panda.ads:testing:1.3.0")
}
```

### 2.3. Configure `AndroidManifest.xml`
Ensure `INTERNET` and `ACCESS_NETWORK_STATE` permissions exist, and register the AdMob Application ID inside `<application>`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<application ...>
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-3940256099942544~3347511713" />
</application>
```

---

## Stage 3: Install `app/src/main/assets/panda_ads_config.json`
Copy the starter template from `templates/panda_ads_config.template.json` to `app/src/main/assets/panda_ads_config.json` and customize placement keys to match the target app's screens.
Verify these mandatory policy & monetization rules in the JSON config:
- **Refresh Floor**: All `reloadSec` / `refresh.intervalMs` values are $\ge 30\text{s}$ (`30,000` ms) or `0` (disabled).
- **Cache TTL Floor**: All `global.cache.ttlMs` entries are $\ge 300,000\text{ ms}$ (5 minutes).
- **Failure Visibility Modes (`failMode`)**:
  - Use `"INVISIBLE"` on fixed-footer screens (`native_language_1`, `native_language_2`, `native_ob_*`) so CTA buttons never jump on ad load failure (Zero CLS).
  - Use `"GONE"` on inline cards and feed slots (`native_home`, `native_feed`, `banner_home`) so surrounding content reclaims space cleanly.
- **Enterprise Monetization Rules**:
  - `resume.fallbackPlacement`: Backfills App Open Resume with Interstitial when AOA has no fill.
  - `reward_unlock.fallbackPlacement`: Backfills Rewarded Video with Rewarded Interstitial when Rewarded has no fill.
  - `banner_home.collapsibleCooldownSec`: Prevents Collapsible Banner fatigue (e.g., `180` seconds).
  - `inter_home.minSessionNumber` & `installGracePeriodSec`: Protects Day-0 new-user retention.
  - `global.adFreeAfterRewardSec`: Grants post-reward immunity from unsolicited Interstitial/Resume ads.

---

## Stage 4: Initialize `PandaAds` in `Application.onCreate()`
Wire `PandaAds.init(this) { ... }` inside `Application.onCreate()`:
- **CRITICAL**: Do **NOT** call `preload()` for placements inside `Application.onCreate()`.
```kotlin
PandaAds.init(this) {
    appId = "ca-app-pub-3940256099942544~3347511713"
    defaultConfigAsset = "panda_ads_config.json"
    engine = NextGenAdEngine(this@MainApplication)
    consentProvider = UmpConsentProvider(
        context = this@MainApplication,
        debugSettings = if (BuildConfig.DEBUG) {
            ConsentDebugSettings(
                debugGeography = ConsentDebugSettings.DebugGeography.DEBUG_GEOGRAPHY_EEA,
                resetConsent = false,
            )
        } else null,
    )
    revenueSinks += AppsFlyerRevenueSink()
}
```

---

## Stage 5: Wire 2-Phase Splash Orchestration (`SplashActivity`)
1. Disable App Resume during Splash: `PandaAds.resume.setEnabled(false)`.
2. If the Splash UI is built with **Jetpack Compose**:
   - Create `val splashBannerGate = SplashBannerGate()` in the `SplashViewModel` (and call `splashBannerGate.reset()` before starting the splash flow).
   - Pass `splashBannerGate = splashBannerGate` and `bottomBannerPlacement = Placement("banner_splash")` to `SplashOptions`.
   - Render `PandaBanner(placement = Placement("banner_splash"), splashGate = splashBannerGate)` at the bottom of the Splash screen.
3. If the Splash UI is built with **XML Views**:
   - Pass `bannerContainer = findViewById(R.id.splashBannerContainer)` and `bottomBannerPlacement = Placement("banner_splash")` to `SplashOptions`.
4. Pre-warm the next screen's Native ad inside `onBeforeShow = { PandaAds.native.preload("native_language_1") }`.
5. Re-enable App Resume (`PandaAds.resume.setEnabled(true)`) right before navigating away from Splash.

---

## Stage 6: Wire Screen-by-Screen Ad Placements

### 6.1. Language Selection (LFO 1 & LFO 2)
- Configure `"poolGroup": "lfo_native_pool"` on both `native_language_1` and `native_language_2`.
- Preload `native_language_2` when LFO 1 appears (`PandaAds.native.preload("native_language_2")`).
- Render `PandaNative` (Compose) or `PandaNativeView` (XML) with `failVisibilityMode = AdFailVisibilityMode.INVISIBLE` (`app:panda_fail_mode="invisible"`).

### 6.2. Onboarding Pager (`HorizontalPager` / `ViewPager2`)
- Gate each page's Native ad with `isActive = (currentPage == pageIndex)` so off-screen pages do not drain the Native pool prematurely.
- On the final "Get Started" CTA, call `PandaAds.interstitial.showThen(activity, Placement("inter_onboarding"), overlay = DialogOverlayPresenter()) { navigateToHome() }`.

### 6.3. Main Home, Inline Native, Collapsible Banner & Exit Dialog
- Pre-warm `native_exit_dialog` when entering Home: `PandaAds.native.preload("native_exit_dialog")`.
- Render bottom collapsible banner:
  - Compose: `PandaBanner(placement = Placement("banner_home"), collapsible = CollapsibleAnchor.BOTTOM, failVisibilityMode = AdFailVisibilityMode.GONE)`
  - XML: `<com.panda.ads.ui.views.PandaBannerView app:panda_placement="banner_home" app:panda_collapsible="bottom" app:panda_fail_mode="gone" />`
- Intercept system Back press on Home to display `PandaNativeExitDialog` (Compose) or `PandaNativeExitDialogHelper.show(...)` (XML).

### 6.4. Scrollable Content Feeds (`LazyColumn` & `RecyclerView`)
- **Compose `LazyColumn`**: Use `val listState = rememberPandaNativeListState(placement = Placement("native_feed"), itemCount = items.size)` and `pandaNativeItems(state = listState, items = items) { ... }`.
- **XML `RecyclerView`**: Wrap the content adapter with `val injector = PandaNativeListInjector(placement = Placement("native_feed"), lifecycleOwner = this)` and **always** map click positions via `injector.toContentPositionOrNull(holder.bindingAdapterPosition)`.

### 6.5. Rewarded Video, SSV, Retry & Ad-Free Session
- Use `rememberRewardedRetryHandler(maxFailedAttempts = 3)` (Compose) or `RewardedRetryHandler(maxFailedAttempts = 3)` (XML/ViewModel) with `RewardSsvData(userId, customData)` and `DialogOverlayPresenter()`.
- Record completed rewarded views via `PandaAds.adFreeSession.recordRewardedWatched()`.

### 6.6. VIP / Paywall & LTV / tROAS Tracking
- Add `DisableAppResumeEffect()` (Compose) or `PandaAds.resume.setEnabled(false)` (XML `onResume`/`onPause`) on Paywall/Checkout screens.
- Sync Google Play Billing VIP status via `PandaAds.setPremium(isVip)`.
- Observe `PandaAds.ltv.state` for cumulative LTV / `AdWhaleTier` and adjust cooldown pressure via `PandaAds.setUserSegment(...)`.

---

## Stage 7: Write Deterministic JVM Unit Tests (`:sdk:testing`)
Create unit tests using `PandaTestHarness` and `FakeAdEngine` (always calling `PandaTestHarness.uninstall()` in `@After`) covering:
1. Cold-start Splash Active/Passive flow & VIP short-circuit (`ShowResult.Blocked(BlockReason.PREMIUM)`).
2. Interstitial cooldown, session grace period, and post-reward grace period (`BlockReason.REWARD_GRACE_PERIOD`).
3. Rewarded SSV grant and 3-strike `RewardedRetryHandler` fallback.
4. XML / ViewModel VIP state transitions (`OFF -> ON -> OFF`) and `AdFailVisibilityMode` (`GONE`, `INVISIBLE`, `SHIMMER`).

---

## Stage 8: Final Verification Checklist
Run `./gradlew testDebugUnitTest assembleDebug` and verify:
- [ ] Zero `.core.internal.*` imports in host app source code.
- [ ] Zero bulk `preload()` calls in `Application.onCreate()`.
- [ ] All XML `PandaNativeView`, `PandaBannerView`, and `PandaNativeListInjector` instances hide immediately (`View.GONE`, 0 ad rows) when `PandaAds.isPremium == true` and recover cleanly when VIP is turned off.
- [ ] All unit tests pass and debug APK builds with 0 errors.
