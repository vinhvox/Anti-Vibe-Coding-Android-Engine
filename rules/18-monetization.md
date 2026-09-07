# 18-admob.md

# Purpose

This document defines the application's advertising architecture.

Advertising should:

- Maximize revenue
- Preserve user experience
- Respect privacy
- Be easy to maintain
- Be easy to replace

Advertising is an infrastructure concern.

Business logic must never depend on advertising SDKs.

---

# Core Principles

Advertising must be isolated.

Preferred architecture:

```text
UI
      │
      ▼
ViewModel
      │
      ▼
AdManager
      │
      ▼
Ad Provider
      │
      ▼
Google Mobile Ads SDK
```

Never call SDK APIs directly from UI.

---

# Approved SDK

Current provider:

- Google Mobile Ads SDK (AdMob)

Future providers may include:

- AppLovin MAX
- Google Ad Manager
- IronSource
- Pangle

Implementation should remain provider-independent.

---

# Layer Responsibilities

Presentation

Responsible for:

- Requesting ad display

Never:

- Load ads
- Cache ads
- Handle SDK callbacks

---

Core

Responsible for:

- Ad loading
- Ad caching
- Ad lifecycle
- Revenue events
- Frequency control

---

Infrastructure

Responsible for:

- SDK integration
- Initialization
- Mediation
- Consent

---

# Ad Manager

Use a centralized AdManager.

Example:

```text
InterstitialManager

RewardedManager

AppOpenManager

NativeManager

BannerManager
```

Avoid one giant manager containing all ad logic.

---

# Dependency Injection

Register managers as Singleton.

Example:

```text
AdManager

ConsentManager

RevenueTracker
```

Never instantiate ad managers manually.

---

# Ad Types

Support:

- App Open
- Banner
- Native
- Interstitial
- Rewarded
- Rewarded Interstitial

Each type owns its own lifecycle.

---

# Loading Strategy

Ads should preload when appropriate.

Preferred:

```text
Application

↓

Load

↓

Cache

↓

Ready
```

Avoid loading only after the user taps.

---

# Cache Strategy

Keep cached ads.

Reload after:

- Show
- Expiration
- Failure

Never reuse expired ads.

---

# Display Rules

Ads should appear naturally.

Examples:

- Screen transition
- Completed action
- Exit point

Never interrupt critical workflows.

---

# Frequency Control

Limit ad frequency.

Respect:

- Cooldown
- Session limits
- User experience

Avoid excessive ad exposure.

---

# Consent

Respect privacy regulations.

Support:

- GDPR
- UMP
- Regional privacy requirements

Do not request personalized ads without valid consent where required.

---

# Error Handling

Handle:

- Load failure
- Show failure
- Network unavailable
- Expired ads

Failures must never crash the application.

---

# Retry Strategy

Retry with backoff.

Avoid infinite retry loops.

Retry only when appropriate.

---

# Revenue Tracking

Track:

- Impression
- Click
- Revenue
- Fill Rate
- Load Time

Do not mix analytics with UI logic.

---

# Analytics

Record:

- Ad Type
- Placement
- Result
- Revenue
- Error Code

Do not collect personal user data.

---

# Placement Rules

Define placements centrally.

Example:

```text
HOME_EXIT

FILE_DELETE

FILE_SHARE

SCAN_COMPLETE

SETTINGS_EXIT
```

Avoid hardcoded placement names.

---

# Navigation

Ads should never own navigation.

Navigation belongs to Navigation layer.

---

# Rewarded Ads

Rewards should only be granted after verified completion.

Never reward on ad load.

---

# App Open & Splash Ads (refs: `rules/27-app-quality-vitals.md`)

Show only when:

- Returning from background (App Open Ad)
- In-App Splash Screen (Tier 2 Compose Splash with fail-safe timeout $\le 3500\text{ms}$)

Rules:
- Never block app launch indefinitely: always enforce `withTimeoutOrNull(3500L)`
- Never show splash ads during the first-launch onboarding flow (D1 retention protection)
- Always clear Splash from Navigation backstack upon entering Home (`navigateAndClearBackStack`)
- Suppress ads if the Splash screen has already unmounted or navigated away

---

# Native Ads

Native ads must follow the application's Design System.

Maintain visual consistency.

Clearly distinguish ads from organic content.

---

# Banner Ads

Avoid placing banners where they obstruct interaction.

Support adaptive banner sizes.

---

# Interstitial Ads

Show only at natural transition points.

Never display:

- Immediately after app launch
- During active user interaction
- While loading critical content

---

# Offline Behavior

If ads are unavailable:

Continue normal application flow.

Advertising must never block the user.

---

# Testing

Support:

- Test IDs
- Mock providers
- Fake AdManager

Never use production ad units during development.

---

# Release Rules

Release builds must:

- Use production IDs
- Remove debug logging
- Disable test devices

Verify all placements before release.

---

# Review Checklist

Before completing implementation:

□ SDK isolated

□ AdManager used

□ No direct SDK calls in UI

□ Ads cached

□ Frequency controlled

□ Consent implemented

□ Errors handled

□ Analytics tracked

□ Test IDs removed

□ User experience preserved

---

# Anti-patterns

Do not:

Composable

↓

MobileAds.load()

Do not:

ViewModel

↓

Ad SDK

Do not:

Hardcoded Ad Unit IDs

Do not:

Show multiple interstitials consecutively

Do not:

Block users when ads fail

Do not:

Reward before completion

---

# Decision Priority

When implementing advertising:

1. User Experience

2. Privacy

3. Stability

4. Revenue

5. Performance

6. Maintainability

7. Testability

---

# Final Rule

Advertising should enhance monetization without degrading user experience.

Keep advertising isolated, configurable, privacy-aware, and easy to replace with another provider in the future.