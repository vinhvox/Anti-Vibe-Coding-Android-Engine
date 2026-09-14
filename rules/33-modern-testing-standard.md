# 33 - Modern Android & Compose Testing Standard (The Anti-Brittle Testing Mandate)

## Purpose

This document establishes the official **Modern Android, Jetpack Compose, and Kotlin Multiplatform Testing Standard** across the entire Antigravity Engine.

Its mission is to eliminate brittle, over-mocked tests, eliminate flaky asynchronous tests, and enforce a high-confidence, production-grade 4-tier testing pipeline covering ViewModel StateFlows (Turbine), Dependency Injection graphs (Koin), Database migrations (Room), and Compose UI Semantics.

---

# 1. THE 4-TIER MODERN TESTING PYRAMID

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ TIER 4: REAL ASSEMBLE BUILD & DEX (5%)  │ Mandatory ./gradlew assembleDebug (Gate E20) │
├─────────────────────────────────────────┼──────────────────────────────────────────────┤
│ TIER 3: COMPOSE UI & SEMANTICS (15%)    │ 5-State Matrix, Touch Targets >= 48dp, a11y  │
├─────────────────────────────────────────┼──────────────────────────────────────────────┤
│ TIER 2: INTEGRATION & CONTRACT (20%)    │ Koin appModule.verify(), Room Migrations     │
├─────────────────────────────────────────┼──────────────────────────────────────────────┤
│ TIER 1: UNIT & CONCURRENCY (60%)        │ Turbine StateFlow, In-Memory Fakes > Mocks   │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# 2. THE 5 GOLDEN LAWS OF ANTI-BRITTLE TESTING

```text
1. [FAKES OVER MOCKS]
   ➔ Prefer clean in-memory Fakes (e.g. FakeUserRepository) over brittle MockK mocks with dozens of 'every { ... } returns ...'.

2. [TEST BEHAVIOR, NOT IMPLEMENTATION]
   ➔ Assert observable outputs (StateFlow states, database entries, rendered UI semantics), NEVER private functions or internal call counts.

3. [ZERO FLAKINESS (Deterministic Coroutines)]
   ➔ Strictly ban Thread.sleep() and arbitrary delay() in tests. Mandate 100% runTest with StandardTestDispatcher and advanceUntilIdle().

4. [GHERKIN SPEC ALIGNMENT]
   ➔ Structure test names using BDD Gherkin format:
      `given [precondition], when [action], then [expected state transition]`

5. [EVIDENCE BEFORE ASSERTION]
   ➔ Never claim tests pass without executing real terminal commands and capturing BUILD SUCCESSFUL and PASSED test reports.

6. [THE 6-DIMENSION ADVERSARIAL BOUNDARY COVERAGE]
   ➔ Strictly forbid "Happy-Path Only" tests. Every test suite MUST systematically cover:
      - Data Boundaries (Empty, Blank, Whitespace, 0, 1, Max, Overflow, Unicode/Emoji, Malformed).
      - State Machine & Transitions (Re-entrancy, Illegal transitions, Abrupt cancellation).
      - Timing & Concurrency (Rapid multi-taps < 400ms, Parallel races, Out-of-order async, 401 races).
      - Hostile OS & Environment (Process death rehydration, Offline, Captive portal, Full disk).
      - Adversarial User Behavior (Button spamming, Rotation mid-flight, Massive clipboard paste).
      - Business Invariants & Security (Non-negative balances, Idempotency, Zero leaks, Injection).

7. [LIVING EXECUTABLE TRACEABILITY]
   ➔ Every Gherkin scenario in `spec.md` MUST have an explicit Scenario ID (`@Scenario("ID")`) mapped 1-to-1 to a test method in code. An implementation is incomplete if any scenario in spec lacks an executable test in code.
```

---

# 3. DROP-IN TESTING CODE BLUEPRINTS

### A. MVI ViewModel & StateFlow Testing with Turbine
```kotlin
class UserViewModelTest {

    private val testDispatcher = StandardTestDispatcher()
    private val fakeRepository = FakeUserRepository()

    @BeforeTest
    fun setUp() {
        Dispatchers.setMain(testDispatcher)
    }

    @AfterTest
    fun tearDown() {
        Dispatchers.resetMain()
    }

    @Test
    fun `given initial state, when load intent dispatched, then emits loading then success`() = runTest(testDispatcher) {
        val mockData = listOf(User(id = "1", name = "Alice"))
        fakeRepository.setUsers(mockData)

        val viewModel = UserViewModel(fakeRepository)

        viewModel.state.test {
            assertEquals(UserState.Loading, awaitItem())
            
            viewModel.onIntent(UserIntent.Load)
            advanceUntilIdle()

            assertEquals(UserState.Success(mockData), awaitItem())
            cancelAndIgnoreRemainingEvents()
        }
    }
}
```

### B. Clean In-Memory Fake Pattern (No Over-Mocking)
```kotlin
class FakeUserRepository : UserRepository {
    private val usersFlow = MutableStateFlow<List<User>>(emptyList())
    var shouldReturnError = false

    fun setUsers(users: List<User>) {
        usersFlow.value = users
    }

    override fun observeUsers(): Flow<AppResult<List<User>>> = usersFlow.map { list ->
        if (shouldReturnError) {
            AppResult.Failure(DomainError.Network("Simulated error"))
        } else {
            AppResult.Success(list)
        }
    }
}
```

### C. Koin DI Graph Self-Verification
```kotlin
class KoinModuleVerificationTest : KoinTest {

    @Test
    fun `verify Koin dependency graph integrity`() {
        appModule.verify(
            extraTypes = listOf(
                SavedStateHandle::class,
                CoroutineDispatcher::class
            )
        )
    }
}
```

### D. Room Database Migration Test
```kotlin
@RunWith(AndroidJUnit4::class)
class RoomDatabaseMigrationTest {

    private val TEST_DB = "migration-test"

    @get:Rule
    val helper: MigrationTestHelper = MigrationTestHelper(
        InstrumentationRegistry.getInstrumentation(),
        AppDatabase::class.java
    )

    @Test
    fun `migrate from version 1 to 2 preserves user data`() {
        helper.createDatabase(TEST_DB, 1).apply {
            execSQL("INSERT INTO users (id, name) VALUES ('1', 'Alice')")
            close()
        }

        val db = helper.runMigrationsAndValidate(TEST_DB, 2, true, MIGRATION_1_2)
        // Verify table contents survive migration
    }
}
```

---

# 4. REVIEW & ENFORCEMENT (GATE E24 & GATE E33)

Every task involving tests must pass **GATE E24** and **GATE E33** in `rules/21-enforcement-engine.md`:
- `E24.1`: Turbine Flow Emission Gate
- `E24.2`: Fakes Over Mocks Gate
- `E24.3`: Zero-Flakiness Coroutine Gate
- `E24.4`: Koin DI Graph Verification Gate
- `E24.5`: 5-State UI Matrix Test Coverage Gate
- `E33.1`: Scientific Debugging Gate (Minimal failing test before bugfix)
- `E33.2`: Single-Variable Isolation Gate
- `E33.3`: Living Executable Traceability Gate (1:1 Gherkin Scenario mapping)
- `E33.4`: Adversarial Red-Team Gate (Independent chaos audit)
