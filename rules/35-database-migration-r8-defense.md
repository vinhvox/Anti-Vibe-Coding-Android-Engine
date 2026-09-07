# 35 - Database Migration & R8 ProGuard Release Defense (The Zero-Data-Loss & Zero-Release-Crash Mandate)

## Purpose

This document establishes the official **Database Migration & R8 ProGuard Release Defense Standard** across the entire Antigravity Engine.

Its mission is to eliminate the two catastrophic production failure modes:
1. **Database Data Loss during App Upgrades** caused by missing Room migrations or destructive fallbacks.
2. **Release-Mode Runtime Crashes** caused by R8 minification, code shrinking, and reflection obfuscation.

---

# 1. THE 5 PILLARS OF MIGRATION & R8 DEFENSE

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. ZERO DESTRUCTIVE MIGRATION  │ Strictly ban fallbackToDestructiveMigration() in prod │
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 2. SCHEMA EXPORT & TEST HELPER │ Export schema JSON via KSP; mandatory Migration tests  │
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 3. CONSUMER PROGUARD RULES     │ Every module/SDK ships its own 'consumer-rules.pro'    │
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 4. SERIALIZATION & KEEP GUARD  │ Mandatory @Serializable / @Keep on all boundary models │
├────────────────────────────────┼────────────────────────────────────────────────────────┤
│ 5. REAL RELEASE MINIFY BUILD   │ Mandatory ./gradlew assembleRelease before shipping   │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# 2. CORE ARCHITECTURAL MANDATES

## Rule 35.1: Zero Destructive Migration Mandate
- **Rule:** Never call `fallbackToDestructiveMigration()` or `fallbackToDestructiveMigrationOnDowngrade()` in production Room database configurations.
- **Data Integrity:** When updating any `@Entity`, table structure, index, or foreign key, the developer MUST provide an explicit `Migration(from, to)` or configure Room `@AutoMigration`.
- **Violation:** Any PR or feature modification that triggers a destructive database wipe on update is strictly rejected.

---

## Rule 35.2: Schema Export & Mandatory `MigrationTestHelper`
- **Rule:** KSP Room compiler MUST be configured with `room.schemaLocation` pointing to the version-controlled `schemas/` directory.
- **Migration Test Suite:** Every database version bump MUST be accompanied by an automated test utilizing `MigrationTestHelper`:
  1. Insert sample data into old schema Version $N$.
  2. Execute migration to Version $N+1$ using `helper.runMigrationsAndValidate()`.
  3. Assert that historical user data survives the migration completely intact.

---

## Rule 35.3: Consumer Proguard Rules Isolation (`consumer-rules.pro`)
- **Rule:** Every internal module and SDK module MUST maintain its own `consumer-rules.pro` file.
- **Self-Contained Rules:** Modules must protect their own DTOs, Room entities, and serialized contracts so that host applications automatically inherit the necessary keep rules without manual host configuration.
- **Gradle Linkage:** Link via `consumerProguardFiles("consumer-rules.pro")` in the module's `build.gradle.kts`.

---

## Rule 35.4: Serialization & Reflection Keep Guard
- **Rule:** Every data boundary model MUST be protected from R8 obfuscation:
  1. **Network DTOs (Ktor / OkHttp):** Annotated with `@Serializable` or `@Keep`.
  2. **Room Database Entities:** Protected via `@Entity` keep rules.
  3. **Navigation 3 Routes:** Annotated with `@Serializable` sealed class/object.
  4. **Koin DI Components:** Reflective constructors and factory lambdas preserved.

---

## Rule 35.5: Mandatory Release Minified Build Verification
- **Rule:** Before marking any milestone or release task complete, the build pipeline MUST execute a minified release compilation:
  ```bash
  ./gradlew assembleRelease testReleaseUnitTest --stacktrace
  ```
- **Crash Isolation:** If R8 strips a required class or constructor, the build or unit test will fail immediately in CI rather than crashing on end-user devices.

---

# 3. DROP-IN CODE BLUEPRINTS

### A. Room Migration Test Blueprint
```kotlin
@RunWith(AndroidJUnit4::class)
class DatabaseMigrationTest {

    private val TEST_DB = "migration-test-db"

    @get:Rule
    val helper: MigrationTestHelper = MigrationTestHelper(
        InstrumentationRegistry.getInstrumentation(),
        AppDatabase::class.java
    )

    @Test
    fun testMigrateFromV1ToV2_PreservesUserData() {
        helper.createDatabase(TEST_DB, 1).apply {
            execSQL("INSERT INTO users (id, name, created_at) VALUES ('user_1', 'Alice', 1700000000)")
            close()
        }

        val db = helper.runMigrationsAndValidate(TEST_DB, 2, true, AppDatabase.MIGRATION_1_2)

        val cursor = db.query("SELECT name FROM users WHERE id = 'user_1'")
        cursor.moveToFirst()
        assertEquals("Alice", cursor.getString(0))
        cursor.close()
    }
}
```

### B. Standard `consumer-rules.pro` Blueprint
```proguard
# 1. Kotlinx Serialization
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod
-keepclassmembers class * {
    @kotlinx.serialization.Serializable <fields>;
}
-keep class * implements kotlinx.serialization.KSerializer { *; }

# 2. Room Database Entities & DAOs
-keepclassmembers class * {
    @androidx.room.Entity <fields>;
    @androidx.room.Dao <methods>;
}

# 3. Navigation 3 Serializable Routes
-keep @kotlinx.serialization.Serializable class * extends java.lang.Object { *; }
```

---

# 4. REVIEW & ENFORCEMENT (GATE E26)

Every database and release implementation must pass **GATE E26** in `rules/21-enforcement-engine.md`:
- `E26.1`: Zero-Destructive-Migration Gate
- `E26.2`: Room Schema Export & Migration Test Gate
- `E26.3`: Consumer Proguard Rules Isolation Gate
- `E26.4`: R8 Serialization & Keep Annotation Gate
- `E26.5`: Real Release Minify Build Gate
