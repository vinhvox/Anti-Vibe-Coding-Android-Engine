# Testing Host Apps & SDK Components with `:sdk:testing`

The `:sdk:testing` module provides a 100% deterministic, coroutine-friendly test harness (`PandaTestHarness` and `FakeAdEngine`) so you can unit-test ViewModels, Splash flows, Rewarded SSV flows, Monetization policies, and XML Views on the JVM without real AdMob network calls.

## 1. Gradle Setup

```kotlin
dependencies {
    testImplementation("com.panda.ads:testing:1.3.0")
    testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test:1.9.0")
    testImplementation("junit:junit:4.13.2")
    testImplementation("io.mockk:mockk:1.13.12")
}
```

## 2. Deterministic JVM Testing with `PandaTestHarness`

Always call `PandaTestHarness.uninstall()` in `@After` to reset singleton state (`PandaAds` runtime, premium state, LTV state, and dispatchers).

```kotlin
import android.app.Activity
import com.panda.ads.AdFailVisibilityMode
import com.panda.ads.BlockReason
import com.panda.ads.PandaAds
import com.panda.ads.Placement
import com.panda.ads.Reward
import com.panda.ads.RewardSsvData
import com.panda.ads.ShowResult
import com.panda.ads.testing.FakeAdEngine
import com.panda.ads.testing.FakeAdEngine.LoadScript.Loaded
import com.panda.ads.testing.PandaTestHarness
import io.mockk.mockk
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

@OptIn(ExperimentalCoroutinesApi::class)
class MonetizationFlowTest {

    private val activity = mockk<Activity>(relaxed = true)

    private val testConfig = """{
      "global": {
        "cooldownSec": 20,
        "adFreeAfterRewardSec": 60,
        "segmentCooldownMultipliers": { "AD_WHALE": 0.5 }
      },
      "placements": {
        "inter_home": {
          "format": "INTERSTITIAL",
          "enabled": true,
          "ids": ["INT_1"],
          "minSessionNumber": 1
        },
        "reward_coins": {
          "format": "REWARDED",
          "enabled": true,
          "ids": ["RW_1"],
          "waitForLoadTimeoutSec": 8
        }
      }
    }"""

    @After
    fun tearDown() = PandaTestHarness.uninstall()

    @Test
    fun `rewarded flow grants reward and activates post-reward interstitial grace period`() = runTest {
        val harness = PandaTestHarness(this, testConfig).apply { premium(false) }
        val expectedReward = Reward("coins", 100)
        harness.engine.givenLoad("RW_1", Loaded(network = "admob"))
        harness.engine.givenLoad("INT_1", Loaded(network = "admob"))
        harness.engine.defaultShowScript = FakeAdEngine.ShowScript.Completes(reward = expectedReward)
        harness.start()

        val ssv = RewardSsvData(userId = "u_42", customData = "tx_1")
        val rewardResult = PandaAds.rewarded.show(activity, Placement("reward_coins"), ssv = ssv)
        advanceUntilIdle()
        assertTrue(rewardResult is ShowResult.Rewarded)

        // Immediately attempting to show interstitial is blocked by REWARD_GRACE_PERIOD (60s)
        val interResult = PandaAds.interstitial.show(activity, Placement("inter_home"))
        assertEquals(ShowResult.Blocked(BlockReason.REWARD_GRACE_PERIOD), interResult)
    }

    @Test
    fun `premium user blocks interstitial and auto-grants showForReward`() = runTest {
        val harness = PandaTestHarness(this, testConfig).apply { premium(true) }
        harness.start()
        advanceUntilIdle()

        val interResult = PandaAds.interstitial.show(activity, Placement("inter_home"))
        assertEquals(ShowResult.Blocked(BlockReason.PREMIUM), interResult)

        var rewardGranted = false
        PandaAds.rewarded.showForReward(activity, Placement("reward_coins")) { granted ->
            rewardGranted = granted
        }
        advanceUntilIdle()
        assertTrue(rewardGranted)
    }
}
```
