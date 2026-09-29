---
name: policy
description: "Quick tag `#policy`: Instantly executes a Google Play Policy & Device/Network Abuse Compliance Audit based on Rule 38 and Gate E29 (Zero DCL, Android 14+ FGS, UIDT API, REQUIRE_SECURE_ENV, FLAG_SECURE, and WebView JS hardening)."
---

# Quick Tag: #policy (Google Play Device & Network Abuse Audit Engine)

## Purpose
The `#policy` quick tag triggers an automated, deterministic audit of the codebase against **Google Play's Device and Network Abuse Policy** (Reference: [Google Play Help answer/16559646](https://support.google.com/googleplay/android-developer/answer/16559646)) and **Gate E29** in `rules/21-enforcement-engine.md`.

---

## When Invoked via `#policy`
Whenever the user writes `#policy` in their prompt or requests a policy audit:
1. Announce: `"Activating Google Play Policy & Device/Network Abuse Audit Engine (#policy)..."`
2. Perform a comprehensive static scan across the 6 Pillars of Rule 38 and Gates E29.1 to E29.6.
3. Output the **Compliance Audit Report** with specific PASS/FAIL status for each gate.
4. If violations are detected, immediately supply drop-in code fixes using the Rule 38 blueprints.

---

## The 6 Pillars & Gate E29 Audit Checklist

### 1. [E29.1] Zero Dynamic Code Loading (Zero DCL) Gate
- **Scan:** `libs.versions.toml`, `build.gradle.kts`, `DexClassLoader`, `PathClassLoader`, reflection calls, and remote file downloads.
- **Reject if:** The app or any 3rd-party SDK downloads or executes binary code (`.dex`, `.jar`, `.so`) at runtime, or attempts self-updating outside Google Play Core In-App Updates.
- **Fix:** Package all executable code inside the AAB. Remove hotfix libraries that download remote dex files.

### 2. [E29.2] Android 14+ Foreground Service (FGS) Eligibility & Declaration Gate
- **Scan:** `AndroidManifest.xml` `<service>` tags, `startForegroundService` calls, and notification handlers.
- **Reject if:**
  - Any FGS lacks an explicit `android:foregroundServiceType` attribute.
  - An FGS is used for deferrable work (e.g. background syncing without active user interaction).
  - Background work is not user-initiated or cannot be stopped by the user.
- **Fix:** Specify `android:foregroundServiceType` and request corresponding `FOREGROUND_SERVICE_*` permission; migrate deferrable background work to `WorkManager` (Blueprint 38.2).

### 3. [E29.3] On-Device Android Container Defense Gate (`REQUIRE_SECURE_ENV`)
- **Scan:** `AndroidManifest.xml` inside `<application>`.
- **Reject if:** `<meta-data android:name="android.os.REQUIRE_SECURE_ENV" android:value="true" />` is missing.
- **Fix:** Declare `REQUIRE_SECURE_ENV` in the manifest to legally block untrusted container apps (Parallel Space, Dual Space, VirtualApp) from hooking app memory.

### 4. [E29.4] FLAG_SECURE Anti-Bypass & Surface Protection Gate
- **Scan:** Window management, screenshot handlers, auth screens, payment screens, and vault screens.
- **Reject if:**
  - The app attempts to bypass, mirror, or intercept `FLAG_SECURE` in other apps.
  - Sensitive authentication, payment, or credential screens fail to apply `FLAG_SECURE`.
- **Fix:** Implement `SecureScreenEffect` (Blueprint 38.1) on all sensitive Composable screens.

### 5. [E29.5] WebView Untrusted JavaScript Interface Gate
- **Scan:** `WebView` implementations and `addJavascriptInterface` calls.
- **Reject if:** `addJavascriptInterface` is attached to a WebView that loads unverified or cleartext (`http://`) web content.
- **Fix:** Restrict JS interfaces strictly to verified first-party `https://` URLs loaded from local assets or trusted domain whitelists.

### 6. [E29.6] User-Initiated Data Transfer (UIDT) & Anti-Proxy Gate
- **Scan:** Network transfer workers, background dispatchers, and proxy/VPN services.
- **Reject if:**
  - Large data transfer jobs execute autonomously without direct user trigger.
  - App facilitates secondary/hidden proxy or VPN services without being the primary, user-facing core feature.
  - App interferes with ads displayed in other apps or tampers with external games/services.
- **Fix:** Enforce `FileUploadWorker` with `Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED)` and `OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST`.

---

## Drop-In Compliance Blueprints

### Blueprint 38.1: Composable `SecureScreenEffect`
```kotlin
package com.base.compose.core.security

import android.view.WindowManager
import androidx.activity.ComponentActivity
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.ui.platform.LocalContext

@Composable
fun SecureScreenEffect(enabled: Boolean = true) {
    val activity = LocalContext.current as? ComponentActivity ?: return

    DisposableEffect(enabled, activity) {
        if (enabled) {
            activity.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
        onDispose {
            if (enabled) {
                activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            }
        }
    }
}
```

### Blueprint 38.2: WorkManager User-Initiated Data Transfer (UIDT)
```kotlin
package com.base.compose.core.worker

import android.content.Context
import androidx.work.*

class FileUploadWorker(
    appContext: Context,
    params: WorkerParameters
) : CoroutineWorker(appContext, params) {

    override suspend fun doWork(): Result {
        return try {
            // User-initiated network transfer logic
            Result.success()
        } catch (e: Exception) {
            Result.retry()
        }
    }

    companion object {
        fun enqueue(context: Context) {
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

            val request = OneTimeWorkRequestBuilder<FileUploadWorker>()
                .setConstraints(constraints)
                .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                .build()

            WorkManager.getInstance(context).enqueue(request)
        }
    }
}
```

---

## Pre-Submit Verification Report Template

```markdown
### 🛡️ Google Play Policy & Device/Network Abuse Audit (#policy)

| Gate | Category | Status | Details |
|:---|:---|:---:|:---|
| **E29.1** | Zero DCL | PASS / FAIL | No remote binary execution detected |
| **E29.2** | Android 14+ FGS | PASS / FAIL | All services declare foregroundServiceType |
| **E29.3** | REQUIRE_SECURE_ENV | PASS / FAIL | Manifest container protection declared |
| **E29.4** | FLAG_SECURE Protection | PASS / FAIL | SecureScreenEffect applied to sensitive UI |
| **E29.5** | WebView JS Hardening | PASS / FAIL | addJavascriptInterface restricted to HTTPS |
| **E29.6** | UIDT & Anti-Proxy | PASS / FAIL | Large transfers user-prompted; zero ad/game interference |
```
