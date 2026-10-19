---
name: panda-ads-integration
description: "Complete architectural guide, drop-in blueprints, enterprise monetization (Monet/tROAS) engine, failure visibility modes (GONE/INVISIBLE/SHIMMER), config schema, and AdMob policy checklist for integrating the Panda Ads SDK (v1.3.0+) into Android apps using Jetpack Compose or XML Views. Covers Application init, 2-Phase Splash (Active/Passive + SplashBannerGate), Native & Native List Injection, Exit Dialog, Adaptive/Collapsible Banners, Interstitial, Rewarded (SSV, Retry, Ad-Free Session), App Resume, Cumulative LTV Tracker, and VIP/Premium state."
---

# Panda Ads SDK Integration Skill (`com.panda.ads` v1.3.0+)

## Purpose
Use this skill whenever integrating, auditing, optimizing monetization, or troubleshooting the **Panda Ads SDK** (`com.panda.ads`) in an Android application (Jetpack Compose or XML Views). Every blueprint in this skill complies with **v1.3.0+ API contracts**, zero `.core.internal.*` import leakage, Google AdMob Next-Gen SDK threading rules, and Google Play / AdMob Invalid Traffic policies.

Additional reference files in this skill:
- [references/integration-workflow.md](references/integration-workflow.md) — **8-Stage End-to-End Integration Flow (`/integrate-panda-ads`)** for systematically wiring PandaAds into any target Android project.
- [references/config-schema.md](references/config-schema.md) — Production `assets/panda_ads_config.json` flat-first & nested schema, Enterprise Monetization keys (`fallbackPlacement`, `collapsibleCooldownSec`, `minSessionNumber`, `installGracePeriodSec`, `adFreeAfterRewardSec`, `segmentCooldownMultipliers`, `failMode`), and sanitizer limits (TTL $\ge 5\text{m}$, Refresh $\ge 30\text{s}$).
- [references/testing-guide.md](references/testing-guide.md) — Unit-testing host screens, ViewModels, Monetization scenarios, and XML Views deterministically with `:sdk:testing` (`PandaTestHarness`, `FakeAdEngine`).
- [templates/panda_ads_config.template.json](templates/panda_ads_config.template.json) — Ready-to-copy starter JSON config with Google Test Ad Unit IDs and all 7 Enterprise Monetization rules enabled.

---

## 1. Golden Architectural Rules (Read Before Writing Any Code)

1. **Zero `.core.internal.*` Imports in Host Apps**:
   - Host applications must **only** import from `com.panda.ads`, `com.panda.ads.ui.compose`, `com.panda.ads.ui.views`, `com.panda.ads.consent.ump`, `com.panda.ads.engine.nextgen`, `com.panda.ads.sink.appsflyer`, or `com.panda.ads.config.firebase`.
   - Public type aliases (`BannerSessionState`, `BannerSessionLoading`, `BannerSessionReady`, `BannerSessionFailed`, `BannerSessionHidden`, `NativeListConfig`, `NativeStyleConfig`, `NativeRefreshConfig`) are exported directly in `com.panda.ads`.
2. **NEVER Request All Ads in `Application.onCreate()`**:
   - `PandaAds.init(this) { ... }` in `Application.onCreate()` ONLY initializes the runtime, loads local/cached config, and registers lifecycle trackers.
   - Let `PandaAds.splash.run(...)` (or `load` + `showLoadedAd`) handle the cold-start barrier (Billing + Remote Config + UMP Consent + Splash Ad), and preload screen-specific placements lazily (e.g., `PandaAds.native.preload("native_language_1")` inside `SplashOptions.onBeforeShow`, or `PandaAds.native.preload("native_exit_dialog")` when entering Home).
3. **Enforce AdMob Policy Floors**:
   - Banner & Native auto-refresh intervals **must be $\ge 30,000\text{ ms}$ (30s)** (`0` disables auto-refresh).
   - Fullscreen & Native cache TTL **must be $\ge 300,000\text{ ms}$ (5 minutes)**.
4. **Separate Purchased VIP (`setPremium`) from Temporary Ad-Free (`AdFreeSessionManager`)**:
   - Call `PandaAds.setPremium(isVip)` for Google Play Billing purchases/subscriptions.
   - Use `PandaAds.adFreeSession` for "watch N rewarded ads for X minutes ad-free".
   - Both Compose (`PandaBanner`, `PandaNative`, `pandaNativeItems`, `PandaNativeExitDialog`) and XML Views (`PandaBannerView`, `PandaNativeView`, `PandaNativeListInjector`) automatically observe `PandaAds.isPremiumFlow` (`userPremium || adFreeActive`) to collapse immediately (`View.GONE`, `0dp`, 0 ad rows in `RecyclerView`) when VIP is active and automatically reload when VIP is turned off (`OFF -> ON -> OFF`).
5. **Choose the Right Failure Visibility Mode (`AdFailVisibilityMode`)**:
   - `AdFailVisibilityMode.GONE`: Collapses the view (`View.GONE`, `0dp`) when an ad fails to load so surrounding content reclaims the space.
   - `AdFailVisibilityMode.INVISIBLE`: Hides the view (`View.INVISIBLE`) while preserving the full template skeleton height so buttons below never shift (Zero CLS — ideal for Language, Onboarding, or sticky footer slots).
   - `AdFailVisibilityMode.SHIMMER`: Keeps the shimmer skeleton visible while awaiting pool/auto-refresh recovery.

---

## 2. Gradle Dependencies & Manifest Setup

### 2.1. Module Selection (`build.gradle.kts`)

```kotlin
dependencies {
    // Option A: Umbrella dependency (Core + NextGen Engine + UMP + Compose + Views + AppsFlyer Sink)
    implementation("com.panda.ads:panda-ads:1.3.0")

    // Option B: Modular selection
    implementation("com.panda.ads:core:1.3.0")
    implementation("com.panda.ads:engine-nextgen:1.3.0")
    implementation("com.panda.ads:consent-ump:1.3.0")
    implementation("com.panda.ads:ui-compose:1.3.0")
    implementation("com.panda.ads:ui-views:1.3.0")
    implementation("com.panda.ads:sink-appsflyer:1.3.0")
    implementation("com.panda.ads:config-firebase:1.3.0") // Optional Firebase RC bridge

    // Unit testing fakes
    testImplementation("com.panda.ads:testing:1.3.0")
}
```

### 2.2. `AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <application android:name=".MainApplication" ...>
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="${admobAppId}" />
    </application>
</manifest>
```

---

## 3. Drop-In Integration Blueprints

### Blueprint 1: `Application.onCreate()` Initialization

```kotlin
package com.example.app

import android.app.Application
import com.panda.ads.LogFormat
import com.panda.ads.PandaAds
import com.panda.ads.VioLog
import com.panda.ads.consent.ump.ConsentDebugSettings
import com.panda.ads.consent.ump.UmpConsentProvider
import com.panda.ads.engine.nextgen.NextGenAdEngine
import com.panda.ads.sink.appsflyer.AppsFlyerRevenueSink

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        VioLog.isEnabled = BuildConfig.DEBUG
        VioLog.format = LogFormat.BOXED

        PandaAds.init(this) {
            appId = BuildConfig.ADMOB_APP_ID
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
    }
}
```

---

### Blueprint 2: 2-Phase Splash Orchestration (Active & Passive + `SplashBannerGate`)

- **Compose Splash (`SplashBannerGate`)**: Pass `splashBannerGate` to both `SplashOptions` and `PandaBanner(placement = Placement("banner_splash"), splashGate = splashBannerGate)`. Always call `splashBannerGate.reset()` before starting/replaying a splash flow.
- **XML Splash (`FrameLayout`)**: Or pass `bannerContainer = findViewById(R.id.splashBannerContainer)` to `SplashOptions`.
- **Active vs Passive Mode**:
  - **Active (`PandaAds.splash.run(options)`)**: Automatically shows the loaded App Open / Interstitial ad as soon as Phase 2 completes.
  - **Passive (`PandaAds.splash.load(options)` + `PandaAds.splash.showLoadedAd(activity)`)**: Resolves Phase 1 & preloads the splash ad into memory, letting the host UI decide the exact moment to call `showLoadedAd()`.

```kotlin
class SplashViewModel : ViewModel() {
    val splashBannerGate = SplashBannerGate()

    fun startSplash(activity: Activity, isPassiveMode: Boolean = false) {
        splashBannerGate.reset()
        PandaAds.resume.setEnabled(false)

        viewModelScope.launch {
            val options = SplashOptions(
                activity = activity,
                appOpenPlacement = Placement("ad_open_app"),
                interstitialPlacement = Placement("inter_splash"),
                bottomBannerPlacement = Placement("banner_splash"),
                splashBannerGate = splashBannerGate,
                timeoutMs = null, // Uses splash.totalTimeoutSec from config
                minDisplayMs = 1_500L,
                billingChecker = { PandaAds.isPremium },
                isShowAdSplashChecker = { remoteConfig ->
                    remoteConfig.getBoolean("enable_splash_ad", true)
                },
                onBeforeShow = {
                    PandaAds.native.preload("native_language_1")
                },
            )

            if (!isPassiveMode) {
                PandaAds.splash.run(options)
                PandaAds.resume.setEnabled(true)
                navigateToNext()
            } else {
                PandaAds.splash.load(options)
                // Ready! Call PandaAds.splash.showLoadedAd(activity) when host UI is ready
            }
        }
    }
}
```

---

### Blueprint 3: Native Ads, Exit Dialog & Failure Visibility Mode (`AdFailVisibilityMode`)

#### 3A. Jetpack Compose (`PandaNative` & `PandaNativeExitDialog`)
```kotlin
// 1. Standalone Native Ad (with HorizontalPager isActive gating & Fail Visibility Mode)
PandaNative(
    placement = Placement("native_language_1"),
    modifier = Modifier.fillMaxWidth(),
    templateBase = NativeTemplateBase.SMALL, // SMALL, MEDIUM, LARGE, FULLSCREEN, EXIT_DIALOG
    isActive = isPageSelected,
    failVisibilityMode = AdFailVisibilityMode.INVISIBLE, // GONE | INVISIBLE | SHIMMER
)

// 2. Native Exit Confirmation Dialog (pre-warm "native_exit_dialog" when entering Home)
if (showExitDialog) {
    PandaNativeExitDialog(
        placement = Placement("native_exit_dialog"),
        title = "Exit Application?",
        message = "Are you sure you want to leave?",
        confirmText = "Exit",
        dismissText = "Stay",
        onConfirmExit = { activity.finish() },
        onDismiss = { showExitDialog = false },
    )
}
```

#### 3B. XML Views (`PandaNativeView`, `PandaBannerView`, & `panda_fail_mode`)
```xml
<com.panda.ads.ui.views.PandaNativeView
    android:id="@+id/nativeHeaderView"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:panda_placement="native_home"
    app:panda_template="small"
    app:panda_fail_mode="gone" /> <!-- gone | invisible | shimmer -->

<com.panda.ads.ui.views.PandaBannerView
    android:id="@+id/bannerBottomView"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:panda_placement="banner_home"
    app:panda_anchor="bottom"
    app:panda_fail_mode="invisible" />
```

Programmatic control in Activity/Fragment:
```kotlin
// Change failure visibility mode dynamically:
nativeHeaderView.failVisibilityMode = AdFailVisibilityMode.INVISIBLE
bannerBottomView.failVisibilityMode = AdFailVisibilityMode.GONE

// Reload ad on demand (safely no-ops if user is in VIP mode):
nativeHeaderView.requestNewAd()
bannerBottomView.requestNewAd()
```

---

### Blueprint 4: Native Ads in Lists (Compose `LazyColumn` & XML `RecyclerView`)

#### 4A. Jetpack Compose `LazyColumn` (`rememberPandaNativeListState` + `pandaNativeItems`)
Automatically resolves `NativeListConfig`, `templateBase`, and `style` from `PandaAds.native` when omitted:
```kotlin
@Composable
fun DiscoveryFeedList(articles: List<Article>) {
    val nativeListState = rememberPandaNativeListState(
        placement = Placement("native_feed"),
        itemCount = articles.size,
    )

    LazyColumn {
        pandaNativeItems(
            state = nativeListState,
            items = articles,
            key = { article -> article.id },
        ) { article ->
            ArticleRow(article)
        }
    }
}
```

#### 4B. XML `RecyclerView` (`PandaNativeListInjector`)
Automatically resolves `poolProvider`, `config`, `templateBase`, and `style` from `PandaAds.native`, and **automatically removes all ad slots (`getItemCount() == contentAdapter.itemCount`) when `PandaAds.isPremium == true`**:
```kotlin
val injector = PandaNativeListInjector(
    placement = Placement("native_feed"),
    lifecycleOwner = viewLifecycleOwner,
)
injector.failVisibilityMode = AdFailVisibilityMode.GONE
recyclerView.adapter = injector.wrap(contentAdapter)

// Inside content ViewHolder click listener:
itemView.setOnClickListener {
    val contentPos = injector.toContentPositionOrNull(bindingAdapterPosition) ?: return@setOnClickListener
    onItemClicked(items[contentPos])
}
```

---

### Blueprint 5: Interstitial, Rewarded, SSV, Retry & Ad-Free Session

```kotlin
// 1. Interstitial with Loading Overlay & Guaranteed Continuation
PandaAds.interstitial.preload("inter_home")
PandaAds.interstitial.showThen(
    activity = activity,
    placement = Placement("inter_home"),
    overlay = DialogOverlayPresenter(),
) { showResult ->
    navigateToDetail()
}

// 2. Composable Rewarded Retry Handler (3-Strike Graceful Fallback)
val retryHandler = rememberRewardedRetryHandler(maxFailedAttempts = 3)
retryHandler.showWithRetry(
    activity = activity,
    controller = PandaAds.rewarded,
    placement = Placement("reward_unlock"),
    ssv = RewardSsvData(userId = "u_1", customData = "{\"reward\":\"pro\"}"),
    overlay = DialogOverlayPresenter(),
) { outcome ->
    when (outcome) {
        is RewardedRetryHandler.Outcome.Granted -> {
            grantReward()
            PandaAds.adFreeSession.recordRewardedWatched()
        }
        is RewardedRetryHandler.Outcome.FallbackPassed -> grantReward()
        is RewardedRetryHandler.Outcome.NeedsRetry -> showRetryPrompt(outcome.attempt, outcome.maxAttempts)
        RewardedRetryHandler.Outcome.CancelledByUser -> showWatchFullVideoPrompt()
    }
}
```

---

### Blueprint 6: Enterprise Monetization (Monet) & LTV / tROAS Engine

```kotlin
// 1. Observe Cumulative Ad LTV, D1/D7 tROAS Milestones, and Ad Whale Tier
val ltvSnapshot by PandaAds.ltv.state.collectAsStateWithLifecycle()
// ltvSnapshot.totalRevenueUsd, ltvSnapshot.d1RevenueUsd, ltvSnapshot.d7RevenueUsd
// ltvSnapshot.whaleTier (AdWhaleTier.NONE, TOP_20_PCT, TOP_10_PCT)
// ltvSnapshot.unlockedMilestones (D1_CENTS_01..D1_DOLLAR_100, D7_CENTS_01..D7_DOLLAR_100)

// 2. Dynamically adjust user segment cooldown multiplier
// Multiplies global & placement cooldowns by global.segmentCooldownMultipliers[segment]
PandaAds.setUserSegment("AD_WHALE") // e.g., 0.7x cooldown for whales, 1.8x for "CHURN_RISK"
```

---

## 4. Pre-Release Audit Checklist

| # | Gate | Requirement |
|---|---|---|
| 1 | **Zero `.core.internal.*` Imports** | Host app imports only public `com.panda.ads.*` packages and type aliases. |
| 2 | **Zero Bulk Preload in `Application`** | `Application.onCreate()` calls `PandaAds.init` only — no bulk `preload()` calls. |
| 3 | **Refresh Floor $\ge 30\text{s}$ & TTL $\ge 5\text{m}$** | Auto-refresh intervals $\ge 30\text{s}$; fullscreen/native cache TTL $\ge 5\text{m}$. |
| 4 | **Splash `SplashBannerGate.reset()`** | Call `splashBannerGate.reset()` before starting/replaying a Compose splash flow. |
| 5 | **Native List Click Mapping** | `RecyclerView` click listeners use `injector.toContentPositionOrNull(bindingAdapterPosition)`. |
| 6 | **VIP & Failure Visibility Modes** | Verify VIP toggle (`OFF -> ON -> OFF`) hides and recovers all Compose & XML ads, and `AdFailVisibilityMode` (`GONE` vs `INVISIBLE` vs `SHIMMER`) matches screen UX requirements. |
