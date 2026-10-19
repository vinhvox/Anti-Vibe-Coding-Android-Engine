---
name: policy
description: "Quick tag `#policy`: Instantly executes a Google Play Policy & Device/Network Abuse Compliance Audit (2026–2027 Standard) based on Rule 38 and Gates E29.1–E29.12 + E34.6–E34.9."
---

# Quick Tag: #policy (Google Play 2026–2027 Policy & Vitals Audit Engine)

## Purpose
The `#policy` quick tag triggers an automated, deterministic audit of the codebase against **Google Play's Developer Program Policies (2026–2027 Roadmap)**, **Rule 38** (`rules/38-device-network-abuse-policy.md`), and **Gates E29.1–E29.12 & E34.6–E34.9** in `rules/21-enforcement-engine.md`.

---

## When Invoked via `#policy`
Whenever the user writes `#policy` in their prompt or requests a policy audit:
1. Announce: `"Activating Google Play 2026–2027 Policy & Android Vitals Audit Engine (#policy)..."`
2. Perform a comprehensive static scan across the 7 Pillars of Rule 38 and Gates `E29.1–E29.12` + `E34.6–E34.9`.
3. Output the **Compliance Audit Report** with specific PASS/FAIL status for each gate.
4. If violations are detected, immediately supply drop-in code fixes using the Rule 38 & Rule 27 blueprints.

---

## The 7 Pillars & Gates E29.1–E29.12 Audit Checklist (2026–2027)

### 1. [E29.1] Zero Dynamic Code Loading (Zero DCL) Gate
- **Scan:** `libs.versions.toml`, `build.gradle.kts`, `DexClassLoader`, `PathClassLoader`, reflection calls, and remote file downloads.
- **Reject if:** The app or any 3rd-party SDK downloads or executes binary code (`.dex`, `.jar`, `.so`) at runtime, or attempts self-updating outside Google Play Core In-App Updates.
- **Fix:** Package all executable code inside the AAB. Remove hotfix libraries that download remote dex files.

### 2. [E29.2] Android 14–16 Foreground Service (FGS), UIDT & 2027 Geofencing FGS Ban Gate
- **Scan:** `AndroidManifest.xml` `<service>` tags, `startForegroundService` calls, geofencing managers, and background workers.
- **Reject if:**
  - Any FGS lacks an explicit `android:foregroundServiceType` attribute.
  - FGS (`foregroundServiceType="location"`) is used for Geofencing (banned effective **January 27, 2027**).
  - An FGS is used for deferrable work or holds non-exempt `PARTIAL_WAKE_LOCK`s $\ge 2\text{h}$ in 24h (**March 2026** Vitals enforcement).
- **Fix:** Specify `android:foregroundServiceType`; migrate Geofencing to `GeofencingClient`; migrate deferrable work to `WorkManager` / `UIDT`.

### 3. [E29.3] On-Device Android Container Defense Gate (`REQUIRE_SECURE_ENV`)
- **Scan:** `AndroidManifest.xml` inside `<application>`.
- **Reject if:** `<meta-data android:name="android.os.REQUIRE_SECURE_ENV" android:value="true" />` is missing in apps handling sensitive data.
- **Fix:** Declare `REQUIRE_SECURE_ENV` in the manifest to block untrusted container apps (Parallel Space, Dual Space, VirtualApp).

### 4. [E29.4] FLAG_SECURE Anti-Bypass & Surface Protection Gate
- **Scan:** Window management, screenshot handlers, auth screens, payment screens, and vault screens.
- **Reject if:** Sensitive authentication, payment, or credential screens fail to apply `FLAG_SECURE`, or app attempts to bypass `FLAG_SECURE`.
- **Fix:** Implement `SecureScreenEffect` on all sensitive Composable screens.

### 5. [E29.5] WebView Untrusted JavaScript Interface Gate
- **Scan:** `WebView` implementations and `addJavascriptInterface` calls.
- **Reject if:** `addJavascriptInterface` is attached to a WebView that loads unverified or cleartext (`http://`) web content.
- **Fix:** Restrict JS interfaces strictly to verified first-party `https://` URLs.

### 6. [E29.6] Mandatory Account Deletion Web Link Gate
- **Scan:** Account settings screens and privacy constants.
- **Reject if:** App supports account creation but lacks an in-app deletion action AND a public web deletion URL.
- **Fix:** Expose both in-app Account Deletion and a verified public web URL (`AccountPolicyManager`).

### 7. [E29.7] Better Ads Standards Gate
- **Scan:** Ad triggers and interstitial timers.
- **Reject if:** Unexpected interstitials interrupt active user actions or lack a 15-second close button.
- **Fix:** Trigger interstitials only at natural transition breaks with $\le 15\text{s}$ dismiss capability.

### 8. [E29.8] Generative AI Moderation, Flagging & 3rd-Party AI Prominent Disclosure Gate (Aug 2026)
- **Scan:** AI/LLM network calls, consent dialogs, and AI output screens.
- **Reject if:** User data is transmitted to a 3rd-party AI model/SDK without a Prominent In-App Disclosure and explicit consent, or GenAI outputs lack in-app reporting (`GenAiReportContentDialog`).
- **Fix:** Present prominent consent before sharing data with 3rd-party AI, declare in Data Safety, and provide in-app content flagging.

### 9. [E29.10] Families Policy & Anonymous Chat Age-Gate (Aug 26, 2026)
- **Scan:** Chat/social features, Ad SDKs, and onboarding age gates.
- **Reject if:** Anonymous/random chat features allow minor access without a neutral age gate blocking users under 18.
- **Fix:** Enforce `NeutralAgeVerificationScreen` and use Certified Ad SDKs for child audiences.

### 10. [E29.11] 2027 Restricted Permissions Gate (`READ_CALL_LOG`, `READ_CONTACTS`, Media & Health Connect)
- **Scan:** `AndroidManifest.xml` permissions and picker contracts.
- **Reject if:**
  - `READ_CALL_LOG` is requested for phone/missed-call account verification (banned **Jan 27, 2027**).
  - Broad `READ_CONTACTS` is requested instead of the Android System Contact Picker (`PickContact`, enforced **Jan 27, 2027**).
  - `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO` is requested for media picking instead of `PickVisualMedia`.
- **Fix:** Migrate verification to Digital Credentials API / SMS Retriever API; use `PickContact` and `PickVisualMedia`.

### 11. [E29.12 & E34.2–E34.9] 2026–2027 Platform, Memory, DEX & Zero-Tap Restore Gates
- **Scan:** `build.gradle.kts`, `.so` alignment, R8 config, `onTrimMemory`, and `androidx.credentials`.
- **Reject if:**
  - Native `.so` libraries fail 16KB page alignment (**May 1, 2026 / Feb 2027** block).
  - `targetSdk < 36` (**Aug 31, 2026** deadline).
  - Retained Bitmaps exceed P90 limits ($>200\text{MB}$ BG / $>400\text{MB}$ Cached) or DEX code ($>10\text{MB}$ App / $>50\text{MB}$ Game) lacks R8 optimization (**Feb 2027** enforcement).
  - Non-game app with login lacks **Zero-Tap Sign-In Restoration** via `androidx.credentials` `RestoreCredential` (**April 2027** enforcement).
  - Package name is not registered under Android Developer Verification (**Sept 30, 2026 ➔ Global 2027**).

---

## Pre-Submit Verification Report Template

```markdown
### 🛡️ Google Play 2026–2027 Policy & Vitals Audit (#policy)

| Gate | Category | Milestone | Status | Details |
|:---|:---|:---:|:---:|:---|
| **E29.1** | Zero DCL | Active | PASS / FAIL | No remote binary execution detected |
| **E29.2 / E34.6** | FGS, WakeLocks (<2h) & No Geofencing FGS | 03/2026 & 01/2027 | PASS / FAIL | Explicit FGS types, 0 manual WakeLocks, GeofencingClient |
| **E29.3** | REQUIRE_SECURE_ENV | Active | PASS / FAIL | Manifest container protection declared |
| **E29.4** | FLAG_SECURE Protection | Active | PASS / FAIL | SecureScreenEffect applied to sensitive UI |
| **E29.5** | WebView JS Hardening | Active | PASS / FAIL | addJavascriptInterface restricted to HTTPS |
| **E29.6** | Web & In-App Account Deletion | Active | PASS / FAIL | Public web deletion URL & in-app flow present |
| **E29.8** | 3rd-Party AI Disclosure & Flagging | 08/2026 | PASS / FAIL | Prominent consent + in-app report dialog |
| **E29.10** | Child Safety & Anonymous Chat Age-Gate | 08/2026 | PASS / FAIL | Neutral age gate blocks minors on random chat |
| **E29.11 / E34.5** | System Pickers & CallLog Ban | 01/2027 | PASS / FAIL | PickVisualMedia, PickContact, 0 READ_CALL_LOG OTP |
| **E29.12** | Developer Verification & Package Reg | 09/2026–2027 | PASS / FAIL | Package name registered & Play App Signing active |
| **E34.2 / E34.3** | 16KB Page Size & Target SDK 36 | 05/2026 & 08/2026 | PASS / FAIL | 16KB .so aligned, targetSdk = 36, Edge-to-Edge |
| **E34.7 / E34.8** | Memory/Bitmap P90 & R8 DEX Optimization | 02/2027 | PASS / FAIL | onTrimMemory eviction + R8 fullMode >= 75% |
| **E34.9** | Zero-Tap Sign-In Restoration | 04/2027 | PASS / FAIL | Restore Credentials API integrated |
```

