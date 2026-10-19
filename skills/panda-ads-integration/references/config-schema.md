# `panda_ads_config.json` Schema, Monetization Rules & Remote Config Reference

Place the default configuration file at `app/src/main/assets/panda_ads_config.json`.
When Remote Config contains the JSON string under key `panda_ads_config`, `SplashController` automatically parses, sanitizes (`ConfigSanitizer`), and applies it via `PandaAds.updateConfig(json)`.

## 1. Automatic Sanitizer & Policy Limits

- **Cache TTL (`global.cache.ttlMs`)**:
  - Minimum floor: **`300,000` ms (5 minutes)** for all formats.
  - Maximum ceiling: **`3,600,000` ms (1 hour)** for `interstitial`, `rewarded`, `native`; **`14,400,000` ms (4 hours)** for `appOpen`.
- **Banner & Native Refresh (`reloadSec` / `banner.refresh.intervalMs` / `native.refresh.intervalMs`)**:
  - `0` = auto-refresh disabled.
  - Any positive value `< 30,000` ms (`< 30` sec) is clamped up to **`30,000` ms (30 seconds)** per Google AdMob policy.
- **User Segment Cooldown Multipliers (`global.segmentCooldownMultipliers`)**:
  - Clamped to `[0.25, 5.0]` so malformed remote configs can never set 0ms or infinite cooldowns.
- **Failure Visibility Mode (`failMode` / `failVisibilityMode`)**:
  - Supported values (case-insensitive): `"GONE"`, `"INVISIBLE"`, `"SHIMMER"`.
  - Can be configured at the flat placement level (`placements.<key>.failMode`), inside `banner`, inside `native`, or inside `native.list`.

---

## 2. Production `panda_ads_config.json` Template (Flat-First Schema)

```json
{
  "schemaVersion": 1,
  "global": {
    "enabled": true,
    "adapterInitMode": "EAGER",
    "initBarrierTimeoutMs": 3000,
    "premiumGateTimeoutMs": 1500,
    "cooldownSec": 15,
    "cooldownScope": "ONLY_INTER",
    "adFreeAfterRewardSec": 60,
    "segmentCooldownMultipliers": {
      "AD_WHALE": 0.7,
      "STANDARD": 1.0,
      "CHURN_RISK": 1.8
    },
    "fullscreen": {
      "cooldownSec": 15,
      "cooldownScope": "ONLY_INTER",
      "overlay": {
        "enabled": true,
        "durationSec": 0.8
      }
    },
    "cache": {
      "ttlMs": {
        "interstitial": 3300000,
        "appOpen": 14400000,
        "rewarded": 3300000,
        "native": 3300000
      }
    },
    "loader": {
      "maxRetries": 2,
      "retryBackoffMs": [2000, 5000],
      "chainSafetyTimeoutMs": 15000
    }
  },
  "splash": {
    "type": "RATIO",
    "appOpenPlacement": "ad_open_app",
    "interstitialPlacement": "inter_splash",
    "appOpenRatio": 50,
    "interstitialRatio": 50,
    "totalTimeoutSec": 8,
    "minDisplaySec": 1.5,
    "lateAdPolicy": "KEEP_FOR_BORROW"
  },
  "resume": {
    "placement": "ad_open_app",
    "fallbackPlacement": "inter_home",
    "minBackgroundSec": 5,
    "skipAfterFullscreenSec": 10,
    "skipOnAdClick": true,
    "respectGlobalCooldown": true
  },
  "poolGroups": {
    "lfo_native_pool": {
      "format": "NATIVE",
      "borrowEnabled": true,
      "lenderRefill": "IMMEDIATE"
    }
  },
  "placements": {
    "ad_open_app": {
      "format": "APP_OPEN",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/9257395921"],
      "shareCache": true
    },
    "inter_splash": {
      "format": "INTERSTITIAL",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/1033173712"],
      "shareCache": true
    },
    "banner_splash": {
      "format": "BANNER",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/9214589741"],
      "failMode": "GONE"
    },
    "native_language_1": {
      "format": "NATIVE",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/2247696110"],
      "template": "SMALL",
      "poolGroup": "lfo_native_pool",
      "reloadOnClick": true,
      "showCachedWhileLoading": true,
      "failMode": "INVISIBLE"
    },
    "native_language_2": {
      "format": "NATIVE",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/2247696110"],
      "template": "MEDIUM",
      "poolGroup": "lfo_native_pool",
      "reloadOnClick": true,
      "showCachedWhileLoading": true,
      "failMode": "INVISIBLE"
    },
    "banner_home": {
      "format": "BANNER",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/2014213617"],
      "collapsible": "BOTTOM",
      "collapsibleCooldownSec": 180,
      "reloadSec": 30,
      "failMode": "GONE"
    },
    "native_home": {
      "format": "NATIVE",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/2247696110"],
      "template": "MEDIUM",
      "reloadOnClick": true,
      "reloadSec": 45,
      "failMode": "GONE"
    },
    "inter_home": {
      "format": "INTERSTITIAL",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/1033173712"],
      "shareCache": true,
      "cooldownSec": 15,
      "minSessionNumber": 2,
      "installGracePeriodSec": 120,
      "waitForLoadTimeoutSec": 3
    },
    "native_feed": {
      "format": "NATIVE",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/2247696110"],
      "template": "MEDIUM",
      "firstPosition": 2,
      "listInterval": 3,
      "maxAds": 8,
      "poolSize": 2,
      "failMode": "GONE"
    },
    "reward_unlock": {
      "format": "REWARDED",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/5224354917"],
      "fallbackPlacement": "rewarded_inter_daily",
      "adFreeAfterRewardSec": 60,
      "waitForLoadTimeoutSec": 8
    },
    "rewarded_inter_daily": {
      "format": "REWARDED_INTERSTITIAL",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/5354046379"],
      "introCountdownSec": 5,
      "adFreeAfterRewardSec": 45
    },
    "native_exit_dialog": {
      "format": "NATIVE",
      "enabled": true,
      "ids": ["ca-app-pub-3940256099942544/2247696110"],
      "template": "EXIT_DIALOG",
      "failMode": "GONE"
    }
  }
}
```
