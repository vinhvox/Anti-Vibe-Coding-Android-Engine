# 38 - GOOGLE PLAY DEVELOPER PROGRAM POLICIES & DEVICE/NETWORK ABUSE STANDARD (2026–2027) [Quick Tag: `#policy`]

## 1. PURPOSE & HIGHEST MANDATE
This document establishes the mandatory architectural and engineering compliance standard for the complete **Google Play Developer Program Policies (2026–2027 Enforcement Roadmap)**.

Google Play enforces strict automated AI analysis, Android Vitals P90 telemetry, and human review. Violating policies results in **Update Rejections / Publishing Blocks**, **App Suspension/Removal**, or **Developer Account Termination**.

Every Android and KMP project developed under the Antigravity Engine MUST comply with these 7 pillars by default.

---

# 2. THE 7 PILLARS OF GOOGLE PLAY DEVELOPER POLICIES (2026–2027)

```text
+---------------------------------------------------------------------------------------------------+
|                     GOOGLE PLAY DEVELOPER PROGRAM POLICIES RADAR (2026–2027)                      |
+---------------------------------------------------------------------------------------------------+
| 1. Security & Device Abuse     --> Zero DCL, 16KB Page Size (05/2026 & 02/2027), Target SDK 36,   |
|                                    REQUIRE_SECURE_ENV, FLAG_SECURE, Zero Manual WakeLocks         |
| 2. Privacy, Pickers & Auth     --> Data Safety, Web Account Deletion, PhotoPicker, ContactPicker  |
|                                    (01/2027), CallLog Ban (01/2027), Zero-Tap Restore (04/2027)   |
| 3. Monetization & Ads          --> Play Billing / Registered App Stores, 15s Ad Close Limit       |
| 4. Quality & Vitals (P90)      --> Crash < 1.09%, ANR < 0.47%, WakeLock < 2h, Memory/Bitmap &     |
|                                    R8 DEX Optimization >= 25% (02/2027; Mandate >= 75%)           |
| 5. Families & Child Safety     --> COPPA, Certified Ad SDKs, Neutral Age Gate, Anonymous Chat     |
|                                    Minor Ban (08/2026), Zero AAID                                 |
| 6. Generative & 3rd-Party AI   --> Prominent Disclosure before sending User Data to 3rd-Party AI  |
|                                    (08/2026), In-App Content Reporting/Flagging, Safety Filters   |
| 7. Developer Verification      --> Global Android Developer Verification & Package Registration   |
|                                    (09/2026 -> 2027 Global), D-U-N-S, 20 Testers / 14 Days        |
+---------------------------------------------------------------------------------------------------+
```

---

### Pillar 1: Security, Malware & Device/Network Abuse Defense
1. **Zero Dynamic Code Loading (Zero DCL):**
   * An app distributed via Google Play may NOT download, modify, or update executable binaries (`.dex`, `.jar`, `.so`) from remote servers, CDNs, or external storage at runtime.
   * Self-updating outside Google Play is strictly banned. Only the official Play Core In-App Updates API is permitted.
2. **Target SDK 36 (Aug 31, 2026) & 16KB Memory Page Alignment (May 1, 2026 / Feb 2027):**
   * All new apps and updates must target **Android 16 (API level 36)** starting August 31, 2026.
   * All native NDK C/C++ libraries (`.so`, including Flutter, React Native, Unity) MUST be compiled with `-Wl,-z,max-page-size=16384` (NDK r28+) to prevent SIGSEGV crashes and pass Google Play's May 1, 2026 & February 2027 upload blocks.
3. **Container Defense (`REQUIRE_SECURE_ENV`):**
   * Apps handling sensitive data must declare `<meta-data android:name="android.os.REQUIRE_SECURE_ENV" android:value="true" />` to block untrusted container apps (Parallel Space, Dual Space) from hooking runtime memory.
4. **Surface Protection (`FLAG_SECURE`):**
   * Sensitive auth, password, and payment screens must enable `FLAG_SECURE` to block unauthorized screen captures and task switcher snooping.
5. **Foreground Service Geofencing Removal (Jan 27, 2027) & Wake Lock Discipline (Mar 2026):**
   * **Geofencing** is removed as an approved `foregroundServiceType="location"` use case effective **January 27, 2027**; apps must migrate to `GeofencingClient`.
   * Holding non-exempt `PARTIAL_WAKE_LOCK`s for $\ge 2\text{ hours}$ in 24h is penalized under Android Vitals starting **March 2026**.

---

### Pillar 2: Privacy, User Data, System Pickers & Zero-Tap Login Restoration (2026–2027)
1. **Accurate Data Safety Declaration:**
   * 100% of data collected or shared (directly or via 3rd-party SDKs like Firebase, AdMob, AI APIs) must be accurately declared in the Google Play Console Data Safety section.
2. **Mandatory Public Web Account Deletion Link (Fatal Trap):**
   * Any app that allows users to create an account **MUST** provide:
     1. An in-app account and data deletion path (e.g., in Settings/Profile).
     2. A **public web URL link** outside the app where users can request account and data deletion without reinstalling the app.
3. **Zero Storage Permission Abuse (`PickVisualMedia`):**
   * Requesting `READ_EXTERNAL_STORAGE`, `READ_MEDIA_IMAGES`, or `READ_MEDIA_VIDEO` for picking user photos/videos is strictly prohibited. Apps MUST use the **AndroidX System Photo Picker** (`PickVisualMedia`).
4. **System Contact Picker Mandate (`READ_CONTACTS` Restriction — Jan 27, 2027):**
   * Effective **January 27, 2027**, apps without core contact-management functionality are prohibited from requesting broad `READ_CONTACTS` permission and MUST transition to the **Android System Contact Picker** (`ActivityResultContracts.PickContact()`).
5. **Call Log Account Verification Ban (`READ_CALL_LOG` — Jan 27, 2027):**
   * Effective **January 27, 2027**, phone-call / missed-call account verification is no longer a permitted use case for `READ_CALL_LOG`. Apps MUST migrate to the **Digital Credentials API** or **SMS Retriever API**.
6. **Health Connect Granular Permissions (Android 16 / Jan 27, 2027):**
   * Apps accessing Health Connect data must request granular permissions (including new sensitive categories: Menstrual Cycle Phases, Alcohol Consumption, Symptoms) and are strictly prohibited from using health data for employment, credit, or insurance eligibility.
7. **Zero-Tap Sign-In / Login Restoration Mandate (April 2027):**
   * Effective **April 2027**, all non-game apps offering mandatory or optional user login **MUST** automatically restore the user's authenticated state upon first launch on a new Android device using the **AndroidX Restore Credentials API** (`androidx.credentials`).

---

### Pillar 3: Monetization & Better Ads Standards
1. **Google Play Billing & Registered Commerce Programs:**
   * Digital goods, in-game currencies, premium features, and subscriptions must use the Google Play Billing Library or comply with official Google Play alternative billing / external link programs.
2. **Subscription Transparency:**
   * Subscription screens must clearly display localized price, billing period, free-trial terms, and direct deep-links to the Google Play Subscription Center for cancellation.
3. **Better Ads Experiences (Non-Intrusive Ads):**
   * **No Unexpected Interstitials:** Full-screen interstitial ads MUST NOT pop up abruptly when the user is actively engaged in gameplay or right after tapping an action button.
   * **15-Second Close Button:** All interstitial ads must provide a visible, working close button within **15 seconds**.
   * **No Lock-Screen or Background Ads:** Ads displayed outside the active app window or on the device lock screen are strictly banned.

---

### Pillar 4: App Quality, Memory & DEX Optimization (February 2027 Enforcement)
1. **Minimum Functionality (Anti-Spam):**
   * Apps that merely wrap a website in a WebView without native functionality, apps with limited utility, or apps that spam similar content will be rejected.
2. **Core Crash, ANR & Wake Lock Compliance:**
   * Maintain User-perceived Crash Rate $< 1.09\%$ (Mandate $< 0.05\%$), ANR Rate $< 0.47\%$ (Mandate $< 0.02\%$), and Partial Wake Locks $< 2\text{ hours}$ per 24h across 28-day rolling windows.
3. **Memory, Bitmap & DEX Optimization Thresholds (Effective February 2027):**
   * **Dynamic Memory (RSS + Swap) & Bitmap Memory:** Must stay below P90 bad behavior thresholds ($< 200\text{ MB}$ retained bitmaps in Background/Service, $< 400\text{ MB}$ in Cached state; Antigravity Mandate $< 50\text{ MB}$ in Background).
   * **DEX Code Optimization:** Apps with $> 10\text{ MB}$ DEX code (and games $> 50\text{ MB}$) must achieve at least **25% R8 optimization, shrinking, and obfuscation coverage** (Antigravity Mandate: $\ge 75\%$ Optimization, $\ge 80\%$ Obfuscation with `android.enableR8.fullMode=true`).

---

### Pillar 5: Families Policy, Child Safety & Anonymous Chat Ban (August 26, 2026)
1. **Anonymous & Random Chat Apps Restriction (Effective Aug 26, 2026):**
   * Apps featuring anonymous or random chat/pairing are strictly prohibited from targeting children or allowing minor access, and MUST enforce a neutral age-gating screen blocking users under 18.
2. **Certified Ad SDKs Only (Under 13):**
   * If the target audience includes children under 13, only integrate ad networks from Google Play's Certified Ad SDKs list.
3. **Zero Identifiers & Neutral Age Screen:**
   * Never transmit the Android Advertising ID (AAID) or personally identifiable information of children; implement a neutral age screen (`NeutralAgeVerificationScreen`).

---

### Pillar 6: Generative AI & Third-Party AI Data Privacy Policy (August 2026)
1. **Third-Party AI Data Sharing Prominent Disclosure (Effective Aug 2026):**
   * Before transmitting any user data (prompts, documents, photos, voice, or profile metadata) to a **third-party AI model or SDK**, the app MUST display a **Prominent In-App Disclosure** explaining what data is shared and with whom, obtain explicit user consent, and declare the sharing in Google Play Console's *Data Safety* section.
2. **Mandatory In-App Content Reporting:**
   * Users must be able to report or flag offensive/harmful AI-generated content directly within the UI (`GenAiReportContentDialog`).
3. **Moderation Guardrails & No Impersonation:**
   * AI integrations must enforce filters against CSAM, non-consensual deepfakes, self-harm, hate speech, and deceptive impersonation.

---

### Pillar 7: Android Developer Verification & Package Registration (Sept 30, 2026 ➔ Global 2027)
1. **Mandatory Android Developer Verification & Package Registration:**
   * Rolling out starting **September 30, 2026** (Brazil, Indonesia, Singapore, Thailand) and expanding **globally across all certified Android devices in 2027**, developers must complete identity verification (KYC / D-U-N-S) and explicitly register their **Package Names** via Google Play Console (or Android Developer Console for off-Play distribution). Unverified apps face removal or high-friction OS installation blocks (*Advanced Flow* with 24-hour delay).
2. **Organization & Personal Account Testing Mandates:**
   * Organization accounts require a verified **D-U-N-S Number**. Personal accounts must complete a Closed Testing track with **at least 20 opted-in testers for 14 continuous days** prior to Production access.

---

# 3. DROP-IN COMPLIANCE BLUEPRINTS

### Blueprint 38.1: Composable `SecureScreenEffect` (FLAG_SECURE)
```kotlin
package com.base.compose.core.security

import android.view.WindowManager
import androidx.activity.ComponentActivity
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.ui.platform.LocalContext

@Composable
internal fun SecureScreenEffect(isEnabled: Boolean = true) {
    val activity = LocalContext.current as? ComponentActivity ?: return

    DisposableEffect(isEnabled, activity) {
        if (isEnabled) {
            activity.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
        onDispose {
            if (isEnabled) {
                activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            }
        }
    }
}
```

---

### Blueprint 38.2: Account Deletion Web Link & Privacy Settings
```kotlin
package com.base.compose.core.account

import android.content.Context
import android.content.Intent
import android.net.Uri

internal object AccountPolicyManager {
    private const val ACCOUNT_DELETION_WEB_URL = "https://yourdomain.com/account/delete-request"

    fun openAccountDeletionWebPage(context: Context) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(ACCOUNT_DELETION_WEB_URL))
        context.startActivity(intent)
    }
}
```

---

### Blueprint 38.3: Generative AI Content Report Dialog
```kotlin
@Composable
internal fun GenAiReportContentDialog(
    contentId: String,
    onDismiss: () -> Unit,
    onSubmitReport: (reason: String) -> Unit,
    modifier: Modifier = Modifier
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        modifier = modifier,
        title = { AppText(text = stringResource(R.string.report_ai_content_title)) },
        text = { AppText(text = stringResource(R.string.report_ai_content_description)) },
        confirmButton = {
            TextButton(onClick = { onSubmitReport(contentId) }) {
                AppText(text = stringResource(R.string.action_report))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                AppText(text = stringResource(R.string.action_cancel))
            }
        }
    )
}
```

---

### Blueprint 38.4: Zero-Tap Sign-In Restoration (`Restore Credentials API` — April 2027 Mandate)
```kotlin
package com.base.compose.core.auth

import android.content.Context
import androidx.credentials.ClearCredentialStateRequest
import androidx.credentials.CreateRestoreCredentialRequest
import androidx.credentials.CredentialManager
import androidx.credentials.GetCredentialRequest
import androidx.credentials.GetRestoreCredentialOption
import androidx.credentials.RestoreCredential
import kotlin.coroutines.cancellation.CancellationException

internal class RestoreCredentialHelper(
    context: Context
) {
    private val credentialManager = CredentialManager.create(context.applicationContext)

    suspend fun saveRestoreKey(registrationJson: String): Result<Unit> = try {
        val request = CreateRestoreCredentialRequest(registrationJson = registrationJson)
        credentialManager.createCredential(request = request)
        Result.success(Unit)
    } catch (cancellationException: CancellationException) {
        throw cancellationException
    } catch (throwable: Throwable) {
        Result.failure(throwable)
    }

    suspend fun restoreSessionJson(requestJson: String): Result<String?> = try {
        val option = GetRestoreCredentialOption(requestJson = requestJson)
        val request = GetCredentialRequest(credOptions = listOf(option))
        val response = credentialManager.getCredential(request = request)
        val restoreCredential = response.credential as? RestoreCredential
        Result.success(restoreCredential?.authenticationResponseJson)
    } catch (cancellationException: CancellationException) {
        throw cancellationException
    } catch (throwable: Throwable) {
        Result.failure(throwable)
    }

    suspend fun clearRestoreKeyOnLogout(): Result<Unit> = try {
        val clearRequest = ClearCredentialStateRequest(
            requestType = ClearCredentialStateRequest.TYPE_CLEAR_RESTORE_CREDENTIAL
        )
        credentialManager.clearCredentialState(request = clearRequest)
        Result.success(Unit)
    } catch (cancellationException: CancellationException) {
        throw cancellationException
    } catch (throwable: Throwable) {
        Result.failure(throwable)
    }
}
```

---

# 4. ENFORCEMENT & GATE E29 COMPLIANCE (2026–2027)

Every release, feature, and review task must satisfy **GATE E29** in `rules/21-enforcement-engine.md`:
* `E29.1`: Zero Dynamic Code Loading Gate
* `E29.2`: Android 14–16 FGS Eligibility, UIDT & 2027 Geofencing FGS Ban Gate
* `E29.3`: On-Device Container Defense (`REQUIRE_SECURE_ENV`) Gate
* `E29.4`: `FLAG_SECURE` Surface Protection Gate
* `E29.5`: Untrusted WebView Remote Execution Gate
* `E29.6`: Mandatory Account Deletion Web Link Gate
* `E29.7`: Better Ads Standards Gate (15s close, no unexpected interstitials)
* `E29.8`: Generative AI Moderation, In-App Flagging & Third-Party AI Prominent Disclosure Gate
* `E29.9`: Minimum Functionality & Anti-Spam Gate
* `E29.10`: Families Policy, Certified Ad SDK & Anonymous Chat Age-Gate (Aug 2026)
* `E29.11`: 2027 Restricted Permissions Gate (`READ_CALL_LOG` Verification Ban & `READ_CONTACTS` Picker Mandate)
* `E29.12`: Android Developer Verification & Package Registration Gate (2026–2027)

