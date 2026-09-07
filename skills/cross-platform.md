# Kotlin Multiplatform (KMP) & Compose Multiplatform (CMP) Architecture & Engineering Standards

Comprehensive reference and execution guide for architecting, building, and scaling cross-platform applications using **Kotlin Multiplatform (KMP 2.0+)** and **Compose Multiplatform (CMP 1.6+)** targeting **Android, iOS, Desktop (JVM), and Web (Wasm)**.

---

## 1. Core Architectural Philosophy: Maximal Clean Sharing & Native Isolation

Modern KMP is NOT about writing the lowest-common-denominator code. It is about **sharing 80-100% of business logic, data pipelines, and declarative UI in pure Kotlin**, while keeping platform-specific hardware/system bridges isolated and swappable.

```text
┌───────────────────────────────────────────────────────────────────────────────────┐
│                           commonMain (Shared 90-100%)                             │
│  ├── Domain: Models, Use Cases, Repository Contracts, Business Rules             │
│  ├── Data: Ktor HTTP Client, Room KMP Database, DataStore Preferences, JSON       │
│  ├── State: BaseViewModel (MVI / UDF), StateFlow, Coroutines                      │
│  └── UI: Compose Multiplatform (Stateless Screens, Design System Tokens, Theme)  │
└────────────────────────────────────────┬──────────────────────────────────────────┘
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 ▼                                               ▼
┌─────────────────────────────────┐             ┌──────────────────────────────────┐
│      androidMain (Platform)     │             │       iosMain (Platform)         │
│  ├── Android Stateful Route     │             │  ├── iOS Stateful Route / Swift  │
│  ├── Android Permissions        │             │  ├── iOS Permissions & Bridge    │
│  ├── Android Koin Platform DI   │             │  ├── iOS Koin / Swift DI Hook    │
│  └── Native Android Services    │             │  └── Native iOS Capabilities     │
└─────────────────────────────────┘             └──────────────────────────────────┘
```

---

## 2. Source Sets & Placement Guide

### What BELONGS in `commonMain`:
- **Domain Layer:** Models, Entities, Value Objects, Use Cases, Repository Interfaces.
- **Data Layer:** Ktor HTTP Client logic, Room KMP Database definitions (`@Database`, `@Dao`, `@Entity`), DataStore Preferences, Mappers, Serializers (`kotlinx.serialization`).
- **Presentation Layer:** UI State models, UI Intent/Event interfaces, `BaseViewModel` subclasses, MVI state reducers.
- **UI Layer:** Compose Multiplatform Stateless Screens (`*Screen`), Atomic UI Components, Centralized Design System (`AppTheme`, `AppColors`, `AppTypography`, `AppSpacing`), Multiplatform Resources (`Res.string`, `Res.drawable`).

### What MUST REMAIN in Platform Source Sets (`androidMain`, `iosMain`):
- Runtime Permission requests (`rememberLauncherForActivityResult` on Android, `UNUserNotificationCenter` on iOS).
- Native OS Shell & Windowing (Activity lifecycle, AppDelegate / `App.swift`).
- Native Hardware capabilities (Biometrics, Bluetooth Low Energy, Camera capture session, Platform Haptics).
- Deep Link handling with OS Intent / Universal Links.

| Concern | Default Placement | Implementation Pattern |
| :--- | :--- | :--- |
| **ViewModel & MVI State** | `commonMain` | `androidx.lifecycle.ViewModel` + `StateFlow` |
| **Repository Contract** | `commonMain` | Kotlin `interface` |
| **HTTP Networking** | `commonMain` | Ktor Client with Engine abstraction |
| **Local Database** | `commonMain` | Room KMP with `BundledSQLiteDriver` |
| **Stateless Screen UI** | `commonMain` | Compose Multiplatform `@Composable` |
| **Stateful Route Entry** | Platform / Common Shell | Route handling DI & OS callbacks |
| **Permissions / Dialogs** | Platform Shell | Hoisted to Router / Bridge |
| **Platform Services (GPS/Biometrics)**| `commonMain` Interface | Implemented in `androidMain` / `iosMain` via Koin |

---

## 3. Platform Bridge Patterns: Interface + DI vs `expect/actual`

### The Golden Rule:
- **Use Interfaces + Dependency Injection (Koin):** For 95% of platform capabilities (services with lifecycle, state, async operations, I/O, sensors, audio, auth, analytics). This guarantees testability, mockability, and swappable implementations.
- **Use `expect/actual`:** ONLY for thin, stateless platform facts or tiny sync primitives (e.g. `randomUUID()`, platform name string, system timestamp).

### Pattern 1: Interface + Koin DI (Mandatory for Services)

```kotlin
// 1. commonMain: Define the Contract
interface BiometricAuthenticator {
    suspend fun authenticate(title: String, subtitle: String): Boolean
}

// 2. androidMain: Implement using AndroidX Biometric API
class AndroidBiometricAuthenticator(
    private val context: Context
) : BiometricAuthenticator {
    override suspend fun authenticate(title: String, subtitle: String): Boolean {
        // Android BiometricPrompt implementation...
        return true
    }
}

// 3. iosMain: Implement using LocalAuthentication (LAContext)
class IosBiometricAuthenticator : BiometricAuthenticator {
    override suspend fun authenticate(title: String, subtitle: String): Boolean = suspendCancellableCoroutine { cont ->
        val context = LAContext()
        context.evaluatePolicy(LAPolicyDeviceOwnerAuthenticationWithBiometrics, localizedReason = title) { success, _ ->
            cont.resume(success)
        }
    }
}

// 4. Koin Module Registration
// commonMain
val commonModule = module { /* shared repositories, usecases, viewmodels */ }

// androidMain
val androidPlatformModule = module {
    single<BiometricAuthenticator> { AndroidBiometricAuthenticator(get()) }
}

// iosMain
val iosPlatformModule = module {
    single<BiometricAuthenticator> { IosBiometricAuthenticator() }
}
```

### Pattern 2: `expect/actual` for Thin Primitives

```kotlin
// commonMain
expect fun getPlatformName(): String

// androidMain
actual fun getPlatformName(): String = "Android ${android.os.Build.VERSION.SDK_INT}"

// iosMain
actual fun getPlatformName(): String = UIDevice.currentDevice.systemName() + " " + UIDevice.currentDevice.systemVersion
```

---

## 4. Compose Multiplatform UI & Multiplatform Resources

### 1. The 3-Tier UI Architecture in KMP
Every screen must adhere to the **Stateful Router $\rightarrow$ Stateless Screen $\rightarrow$ Mandatory Previews** triad:
- **`*Route` Composable:** Handles Koin injection (`koinViewModel()`), lifecycle collection, permissions, and platform dialogs.
- **`*Screen` Composable (`commonMain`):** 100% Stateless UI accepting only `UiState` and `onIntent`.
- **`*Preview` Composable:** Uses Compose Multiplatform `@Preview` support for instant feedback.

### 2. Multiplatform Resources (CMP 1.6+)
Never import `android.R` or raw resource IDs in `commonMain`. Use the official Compose Multiplatform Resource Generator:

```kotlin
// commonMain/src/commonMain/composeResources/values/strings.xml
// <string name="app_name">My Cross-Platform App</string>
// <string name="welcome_user">Welcome, %1$s!</string>

// commonMain Kotlin usage:
import myproject.generated.resources.Res
import myproject.generated.resources.app_name
import myproject.generated.resources.welcome_user
import org.jetbrains.compose.resources.stringResource

@Composable
fun Header(userName: String) {
    Text(text = stringResource(Res.string.welcome_user, userName))
}
```

---

## 5. Room KMP Database Configuration (Room 2.7+)

Room 2.7+ natively supports Kotlin Multiplatform for Android, iOS, and Desktop.

```kotlin
// 1. commonMain: Database Definition
@Database(entities = [UserEntity::class], version = 1)
@ConstructedBy(AppDatabaseConstructor::class)
abstract class AppDatabase : RoomDatabase() {
    abstract fun userDao(): UserDao
}

@Suppress("NO_ACTUAL_FOR_EXPECT")
expect object AppDatabaseConstructor : RoomDatabaseConstructor<AppDatabase>

// 2. Database Builder Factory in commonMain / platformMain
fun getRoomDatabase(builder: RoomDatabase.Builder<AppDatabase>): AppDatabase {
    return builder
        .setDriver(BundledSQLiteDriver())
        .setQueryCoroutineContext(Dispatchers.IO)
        .build()
}

// 3. androidMain Database Builder Provider
fun getDatabaseBuilder(context: Context): RoomDatabase.Builder<AppDatabase> {
    val dbFile = context.getDatabasePath("app.db")
    return Room.databaseBuilder<AppDatabase>(
        context = context.applicationContext,
        name = dbFile.absolutePath
    )
}

// 4. iosMain Database Builder Provider
fun getDatabaseBuilder(): RoomDatabase.Builder<AppDatabase> {
    val dbFilePath = documentDirectory() + "/app.db"
    return Room.databaseBuilder<AppDatabase>(
        name = dbFilePath,
        factory = { AppDatabase::class.instantiateImpl() }
    )
}

private fun documentDirectory(): String {
    val documentDirectory = NSFileManager.defaultManager.URLForDirectory(
        directory = NSDocumentDirectory,
        inDomain = NSUserDomainMask,
        appropriateForURL = null,
        create = false,
        error = null,
    )
    return requireNotNull(documentDirectory?.path)
}
```

---

## 6. Ktor 3.x Multiplatform Networking

Configure `HttpClient` in `commonMain` using platform engine injection:

```kotlin
// commonMain
fun createHttpClient(engine: HttpClientEngine): HttpClient {
    return HttpClient(engine) {
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true
                isLenient = true
                prettyPrint = false
            })
        }
        install(Logging) {
            level = LogLevel.INFO
        }
        install(HttpTimeout) {
            requestTimeoutMillis = 15_000
            connectTimeoutMillis = 15_000
            socketTimeoutMillis = 15_000
        }
    }
}

// androidMain Koin binding:
single { createHttpClient(OkHttp.create()) }

// iosMain Koin binding:
single { createHttpClient(Darwin.create()) }
```

---

## 7. Koin KMP Dependency Injection Initialization

Provide a shared `initKoin` entry point that Android `Application.onCreate` and iOS `KoinHelper` invoke:

```kotlin
// commonMain/src/commonMain/kotlin/com/example/di/Koin.kt
fun initKoin(appDeclaration: KoinAppDeclaration = {}) = startKoin {
    appDeclaration()
    modules(
        commonModule,
        networkModule,
        databaseModule,
        viewModelModule
    )
}

// androidMain/src/androidMain/kotlin/com/example/MyApplication.kt
class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        initKoin {
            androidContext(this@MyApplication)
        }
    }
}

// iosMain/src/iosMain/kotlin/com/example/di/KoinHelper.kt
fun initKoinIos() = initKoin {
    modules(iosPlatformModule)
}
```

In iOS Swift (`iOSApp.swift`):
```swift
import SwiftUI
import SharedModule

@main
struct iOSApp: App {
    init() {
        KoinHelperKt.doInitKoinIos()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---

## 8. Coroutines & Dispatchers in KMP

1. **`Dispatchers.Main`:** Works seamlessly across Android (Main Looper) and iOS (Darwin Main Queue).
2. **`Dispatchers.Default` & `Dispatchers.IO`:**
   - In modern Kotlin Multiplatform (Kotlin 1.9+ / 2.0+), `Dispatchers.IO` is supported on Native iOS.
   - For CPU-intensive operations (JSON parsing, cryptography, hashing), use `withContext(Dispatchers.Default)`.
   - For database and network operations, use `withContext(Dispatchers.IO)`.

---

## 9. KMP Migration Roadmap (Android Single-Platform to KMP)

When migrating an existing Android application to KMP, execute in strict sequential phases:

```text
Phase 1: Domain & Models Migration
  - Move domain models, value objects, and repository interfaces to commonMain
  - Remove all android.* and java.io.* imports from Domain
        ↓
Phase 2: Data Layer Migration (Ktor + Room KMP)
  - Replace Retrofit/OkHttp with Ktor Client in commonMain
  - Replace Room Android with Room 2.7+ KMP with BundledSQLiteDriver
  - Replace SharedPreferences with DataStore Preferences in commonMain
        ↓
Phase 3: State & ViewModel Migration
  - Inherit BaseViewModel from androidx.lifecycle.ViewModel in commonMain
  - Ensure UiState and Intent interfaces live in commonMain
        ↓
Phase 4: Presentation & UI Migration (Compose Multiplatform)
  - Move Stateless Screen composables to commonMain
  - Migrate android.R strings/drawables to Compose Multiplatform Res.string / Res.drawable
  - Keep Stateful Routers in androidMain / iosMain
        ↓
Phase 5: iOS Project Binding & Verification
  - Configure iosArm64, iosSimulatorArm64 targets in build.gradle.kts
  - Build XCFramework and bind to SwiftUI iOS project
```
