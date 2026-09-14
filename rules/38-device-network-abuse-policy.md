# 38 - GOOGLE PLAY DEVELOPER PROGRAM POLICIES MASTER STANDARD (2025–2026)

## 1. PURPOSE & HIGHEST MANDATE
This document establishes the mandatory architectural and engineering compliance standard for the complete **Google Play Developer Program Policies** (2025–2026).

Google Play enforces strict automated AI analysis and human review. Violating policies results in **Update Rejections**, **App Suspension/Removal**, or **Developer Account Termination**.

Every Android and KMP project developed under the Antigravity Engine MUST comply with these 7 pillars by default.

---

# 2. THE 7 PILLARS OF GOOGLE PLAY DEVELOPER POLICIES

```text
+---------------------------------------------------------------------------------------------+
|                      GOOGLE PLAY DEVELOPER PROGRAM POLICIES RADAR                           |
+---------------------------------------------------------------------------------------------+
| 1. Security & Device Abuse     --> Zero DCL, 16KB Page Alignment, Target SDK, Secure Env    |
| 2. Privacy & User Data         --> Data Safety, Mandatory Web Account Deletion, PhotoPicker |
| 3. Monetization & Ads          --> Google Play Billing, Subscription clarity, 15s Ad limit  |
| 4. Quality & Functionality     --> Zero WebView wrappers, Crash < 1.09%, ANR < 0.47%        |
| 5. Families & Children Policy  --> COPPA, Certified Ad SDKs, Neutral Age Screen, No AAID   |
| 6. Generative AI Policy        --> In-App Content Reporting/Flagging, Moderation Filters    |
| 7. Verification & Testing      --> D-U-N-S verification, 20 testers for 14 days             |
+---------------------------------------------------------------------------------------------+
```

---

### Pillar 1: Security, Malware & Device/Network Abuse Defense
1. **Zero Dynamic Code Loading (Zero DCL):**
   * An app distributed via Google Play may NOT download, modify, or update executable binaries (`.dex`, `.jar`, `.so`) from remote servers, CDNs, or external storage at runtime.
   * Self-updating outside Google Play is strictly banned. Only the official Play Core In-App Updates API is permitted.
2. **Target SDK & 16KB Memory Page Alignment:**
   * Apps must target the latest Android API level (within 1 year of public release).
   * All native NDK C/C++ libraries (`.so`) MUST be compiled with `-Wl,-z,max-page-size=16384` to prevent SIGSEGV crashes on Android 15+ devices.
3. **Container Defense (`REQUIRE_SECURE_ENV`):**
   * Apps handling sensitive data must declare `<meta-data android:name="android.os.REQUIRE_SECURE_ENV" android:value="true" />` to block untrusted container apps (Parallel Space, Dual Space) from hooking runtime memory.
4. **Surface Protection (`FLAG_SECURE`):**
   * Sensitive auth, password, and payment screens must enable `FLAG_SECURE` to block unauthorized screen captures and task switcher snooping.

---

### Pillar 2: Privacy & User Data Governance
1. **Accurate Data Safety Declaration:**
   * 100% of data collected or shared (directly or via 3rd-party SDKs like Firebase, AdMob, Facebook) must be accurately declared in the Google Play Console Data Safety section.
2. **Mandatory Public Web Account Deletion Link (Fatal Trap):**
   * Any app that allows users to create an account **MUST** provide:
     1. An in-app account and data deletion path (e.g., in Settings/Profile).
     2. A **public web URL link** outside the app where users can request account and data deletion without reinstalling the app.
3. **Zero Storage Permission Abuse:**
   * Requesting `READ_EXTERNAL_STORAGE` or `READ_MEDIA_IMAGES` solely for picking user photos/videos is strictly prohibited. Apps MUST use the **AndroidX System Photo Picker** (`PickVisualMedia`).
4. **Background Location Justification:**
   * `ACCESS_BACKGROUND_LOCATION` is permitted ONLY if it is critical to the app's core purpose (e.g., emergency SOS, real-time navigation). A demonstration video must be approved by Google.

---

### Pillar 3: Monetization & Better Ads Standards
1. **Google Play In-App Billing Mandate:**
   * All digital goods, in-game currencies, premium features, and subscriptions MUST use the Google Play Billing Library. External payment links or web checkout workarounds are prohibited (unless enrolled in official User Choice Billing programs).
2. **Subscription Transparency:**
   * Subscription screens must clearly display localized price, billing period, free-trial terms, and direct deep-links to the Google Play Subscription Center for cancellation.
3. **Better Ads Experiences (Non-Intrusive Ads):**
   * **No Unexpected Interstitials:** Full-screen interstitial ads MUST NOT pop up abruptly when the user is actively engaged in gameplay or right after tapping an action button.
   * **15-Second Close Button:** All interstitial ads must provide a visible, working close button within **15 seconds**.
   * **No Lock-Screen or Background Ads:** Ads displayed outside the active app window or on the device lock screen are strictly banned.

---

### Pillar 4: App Quality & Minimum Functionality
1. **Minimum Functionality (Anti-Spam):**
   * Apps that merely wrap a website in a WebView without native functionality, apps with limited utility (single static text/button), or apps that spam similar content will be rejected.
2. **Zero Broken Functionality:**
   * Apps that crash on launch, display perpetual loading skeletons without timeout fallbacks, or feature non-functional broken buttons will be immediately rejected during review.
3. **Google Play Vitals Compliance:**
   * Maintain User-perceived Crash Rate $< 1.09\%$ and ANR Rate $< 0.47\%$ across 28-day rolling periods.

---

### Pillar 5: Families Policy & Children Protection (COPPA)
If the target audience includes children under 13:
1. **Certified Ad SDKs Only:** Only integrate ad networks from Google Play's Certified Ad SDKs list.
2. **Zero Identifiers:** Never transmit the Android Advertising ID (AAID) or personally identifiable information of children.
3. **Neutral Age Screen:** Implement an age gate requiring users to manually enter their birth year without suggesting an adult age.

---

### Pillar 6: Generative AI & Synthetic Content Policy
For features generating text, images, or audio via Generative AI:
1. **Mandatory In-App Content Reporting:** Users must be able to report or flag offensive/harmful AI-generated content directly within the UI.
2. **Moderation Guardrails:** AI integrations must enforce server-side or SDK filters against CSAM, non-consensual deepfakes, self-harm, hate speech, and harassment.
3. **No Impersonation:** AI must not generate deceptive content impersonating real individuals or organizations without authorization.

---

### Pillar 7: Developer Account Verification & Testing Mandates
1. **Organization Accounts:** Must provide a verified **D-U-N-S Number** matching company registration records.
2. **Personal Accounts (Created post-Nov 2023):** Must run a Closed Testing track with **at least 20 opted-in testers for 14 continuous days** before applying for Production release.

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

---

### Blueprint 38.2: Account Deletion Web Link & Privacy Settings
```kotlin
package com.base.compose.core.account

import android.content.Context
import android.content.Intent
import android.net.Uri

object AccountPolicyManager {
    const val ACCOUNT_DELETION_WEB_URL = "https://yourdomain.com/account/delete-request"

    fun openAccountDeletionWebPage(context: Context) {
        val intent = Intent(Intent.ActionView, Uri.parse(ACCOUNT_DELETION_WEB_URL))
        context.startActivity(intent)
    }
}
```

---

### Blueprint 38.3: Generative AI Content Report Dialog
```kotlin
@Composable
fun GenAiReportContentDialog(
    contentId: String,
    onDismiss: () -> Unit,
    onSubmitReport: (reason: String) -> Unit
) {
    // Mandated by Google Play GenAI Policy: In-app user reporting mechanism
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.report_ai_content_title)) },
        text = { Text(stringResource(R.string.report_ai_content_description)) },
        confirmButton = {
            TextButton(onClick = { onSubmitReport("Offensive/Harmful") }) {
                Text(stringResource(R.string.action_report))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text(stringResource(R.string.action_cancel))
            }
        }
    )
}
```

---

# 4. ENFORCEMENT & GATE E29 COMPLIANCE

Every release, feature, and review task must satisfy **GATE E29** in `rules/21-enforcement-engine.md`:
* `E29.1`: Zero Dynamic Code Loading Gate
* `E29.2`: Android 14+ FGS Eligibility Gate
* `E29.3`: On-Device Container Defense (`REQUIRE_SECURE_ENV`) Gate
* `E29.4`: FLAG_SECURE Surface Protection Gate
* `E29.5`: Untrusted WebView Remote Execution Gate
* `E29.6`: Mandatory Account Deletion Web Link Gate
* `E29.7`: Better Ads Standards Gate (15s close, no unexpected interstitials)
* `E29.8`: Generative AI Moderation & In-App Flagging Gate
* `E29.9`: Minimum Functionality & Anti-Spam Gate
* `E29.10`: Families Policy & Certified Ad SDK Gate
