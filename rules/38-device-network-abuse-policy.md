# 38 - GOOGLE PLAY "DEVICE AND NETWORK ABUSE" POLICY STANDARD

## 1. PURPOSE & HIGHEST MANDATE
This document defines the strict architectural and policy compliance standard for **Google Play's Device and Network Abuse Policy** (Reference: [Google Play Help answer/16559646](https://support.google.com/googleplay/android-developer/answer/16559646)).

Google Play prohibits any app (or integrated third-party SDK) from unauthorized access to, or interference with, the user's device, network, other applications, APIs, Google services, or carrier networks. Any violation results in immediate app suspension, removal, or developer account termination.

Every Android and KMP project developed under Antigravity Engine MUST comply with this standard by default.

---

## 2. THE 6 ARCHITECTURAL PILLARS OF DEVICE & NETWORK DEFENSE

```
+-----------------------------------------------------------------------------------+
|               GOOGLE PLAY "DEVICE AND NETWORK ABUSE" POLICY RADAR                 |
+-----------------------------------------------------------------------------------+
| 1. Dynamic Code Loading (DCL) Ban  --> Zero dex/jar/.so runtime download          |
| 2. Android 14+ FGS Permissions     --> User-initiated, stoppable, explicit types  |
| 3. UIDT Jobs API                   --> Network-only user-prompted transfers       |
| 4. FLAG_SECURE Compliance          --> Respect other apps + protect sensitive UI  |
| 5. REQUIRE_SECURE_ENV              --> Block execution in untrusted containers    |
| 6. Proxy/VPN & Anti-Abuse Rules    --> Core-purpose only, no ad blocking/cheats   |
+-----------------------------------------------------------------------------------+
```

### Pillar 1: Absolute Ban on Dynamic Code Loading (DCL) & Self-Updating
* **Mandate:** An app distributed via Google Play may NOT modify, replace, or update itself using any method other than Google Play's update mechanism (Play Core In-App Updates API).
* **Zero Executable Code Download:** Apps must NEVER download executable binaries (`.dex`, `.jar`, `.so`) from remote servers, CDNs, or external storage at runtime.
* **Interpreter Boundaries:** Interpreted languages (JavaScript, Python, Lua) loaded at runtime must run strictly inside an isolated sandbox (e.g., standard WebView without root access) and must NOT allow Google Play policy circumvention.
* **Third-Party SDK Audit:** Every SDK included in `libs.versions.toml` must be verified to ensure it does NOT contain dynamic loader backdoors (e.g., hot-fix frameworks that download `.dex` files).

### Pillar 2: Permissions for Foreground Services (FGS) on Android 14+ (API 34+)
* **Explicit Type Declaration:** Every `<service>` declared as a foreground service MUST specify `android:foregroundServiceType` in `AndroidManifest.xml`.
* **Eligible Use Cases Only:** FGS is permitted ONLY when:
  1. It provides a core feature beneficial to the user.
  2. It is **initiated by the user** or clearly **user-perceptible** (e.g., active audio playback, active phone call, user-requested photo upload to cloud).
  3. It can be **terminated or stopped** by the user directly.
  4. It **cannot be deferred or interrupted** by the system without severely breaking user experience.
  5. It runs ONLY for as long as strictly necessary to finish the task.
* **Play Console Declaration Form & Demo Video:** Apps targeting Android 14+ must submit a declaration form and a demo video demonstrating user-initiated actions and active notifications.
* **Mandatory Alternative:** If the background work can be deferred or paused, developers MUST use **WorkManager** instead of Foreground Services (especially avoiding `dataSync`).

### Pillar 3: User-Initiated Data Transfer (UIDT) Jobs Standard
* **Android 14+ UIDT API (`JobScheduler` / `WorkManager 2.10+`):**
  - Used strictly for large network transfers directly prompted by the user (e.g., manual file upload/download).
  - Must NEVER be triggered autonomously in the background without direct user command.
  - Must operate exclusively for network data transfer tasks and terminate immediately once finished.

### Pillar 4: FLAG_SECURE Compliance & Display Surface Protection
* **Respecting Other Apps:** Apps must NEVER facilitate, create workarounds, or provide tools to bypass `WindowManager.LayoutParams.FLAG_SECURE` in other apps (e.g., screenshot grabbers, unpermitted screen mirroring tools).
* **Self-Protection:** Apps handling sensitive personal data, authentication tokens, credentials, or payment details MUST declare `FLAG_SECURE` on sensitive Compose windows/screens to prevent unauthorized screen captures, screen sharing leaks, or app switcher caching.
* **Accessibility Exception:** Accessibility tools are exempt ONLY if they do NOT transmit, save, or cache `FLAG_SECURE` protected content outside the user's device.

### Pillar 5: On-Device Android Containers Defense (`REQUIRE_SECURE_ENV`)
* **Simulated Environment Threat:** On-device Android container apps (App Cloners, Parallel Spaces, Dual Spaces, VirtualApp) simulate the Android OS without complete hardware-backed security, exposing apps to hooking, tampering, and credential theft.
* **Mandatory Manifest Defense:**
  ```xml
  <application ...>
      <meta-data
          android:name="android.os.REQUIRE_SECURE_ENV"
          android:value="true" />
  </application>
  ```
* Container apps distributed on Google Play are legally and policy-bound to check for this flag and REFUSE to load any app declaring it.

### Pillar 6: Proxy/VPN Services, Sandboxing & Anti-Abuse
* **Proxy/VPN Primary Purpose:** An app facilitating proxy services or VPN to third parties is permitted ONLY if proxy/VPN functionality is the **primary, user-facing core purpose** of the app. Secondary/hidden proxying or bandwidth sharing is strictly banned.
* **Zero Sandbox Circumvention:** Apps must not circumvent Android user-space sandboxing to infer user identities or track activity across other apps.
* **No Ad Interference or Game Cheating:** Apps must not block or tamper with ads displayed in other apps, nor alter the memory/gameplay of third-party apps.
* **Full-Screen Intent Discipline:** The `USE_FULL_SCREEN_INTENT` permission must NEVER be abused to force user interaction with ads or disruptive spam notifications.

---

## 3. DROP-IN CODE BLUEPRINTS

### Blueprint 38.1: Composable `SecureScreenEffect` (Jetpack Compose)
Place in `:core:common` or `:core:ui:security`:

```kotlin
package com.base.compose.core.security

import android.view.WindowManager
import androidx.activity.ComponentActivity
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.ui.platform.LocalContext

/**
 * Enforces FLAG_SECURE on the current Window during the lifecycle of a sensitive Composable screen.
 * Automatically clears the flag when navigating away or disposing.
 */
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

### Blueprint 38.2: WorkManager User-Initiated Data Transfer (Android 14+)
Use WorkManager with Expedited or User-Initiated constraints instead of risky `dataSync` FGS:

```kotlin
package com.base.compose.core.worker

import android.content.Context
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import androidx.work.WorkerParameters

class FileUploadWorker(
    appContext: Context,
    params: WorkerParameters
) : CoroutineWorker(appContext, params) {

    override suspend fun doWork(): Result {
        // Safe, non-FGS, policy-compliant background execution
        return try {
            // Perform actual user-initiated network upload
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

## 4. ENFORCEMENT CHECKLIST (Pre-Submit Gate)
1. [ ] **Manifest Protection:** `<meta-data android:name="android.os.REQUIRE_SECURE_ENV" android:value="true" />` is declared inside `<application>`.
2. [ ] **Zero DCL:** No `DexClassLoader`, `PathClassLoader` dynamically loading external files from disk/network.
3. [ ] **FGS Precision:** If any service uses `foregroundServiceType`, verify eligibility, demo video, and Play Console declaration.
4. [ ] **WorkManager First:** All background syncs/uploads leverage `WorkManager` with `NetworkType.CONNECTED`.
5. [ ] **FLAG_SECURE Guard:** Sensitive payment/auth screens are protected with `SecureScreenEffect`.
6. [ ] **WebView Hardening:** No `addJavascriptInterface` loading non-HTTPS or arbitrary unverified URLs.
